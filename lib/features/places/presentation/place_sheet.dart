import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' hide Circle, Path;

import 'package:safecircle/core/location/location_service.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/formatters.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_map.dart';
import 'package:safecircle/core/widgets/sc_tiles.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/places/application/place_service.dart';
import 'package:safecircle/features/places/presentation/place_icons.dart';

class PlaceSheet extends ConsumerStatefulWidget {
  const PlaceSheet({super.key, required this.circle, this.existing});
  final Circle circle;
  final Place? existing;

  @override
  ConsumerState<PlaceSheet> createState() => _PlaceSheetState();
}

class _PlaceSheetState extends ConsumerState<PlaceSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late double _radius = widget.existing?.radiusM ?? 800 / 3.28084;
  late bool _arrive = widget.existing?.notifyArrive ?? true;
  late bool _leave = widget.existing?.notifyLeave ?? true;
  late String _icon = widget.existing?.icon ?? 'mapPin';
  late double? _lat = widget.existing?.lat;
  late double? _lng = widget.existing?.lng;
  late String _address = widget.existing?.address ?? '';
  bool _busy = false;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    if (_lat == null) _useCurrentLocation();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    final loc = await LocationService.instance.getCurrent();
    if (!mounted) return;
    setState(() {
      _locating = false;
      if (loc != null) {
        _lat = loc.lat;
        _lng = loc.lng;
        _address = loc.label;
      }
    });
  }

  Future<void> _save() async {
    if (!_arrive && !_leave) {
      showScToast(context, 'Pick at least one alert.');
      return;
    }
    if (_lat == null || _lng == null) {
      showScToast(context, 'Waiting for a location — try again in a moment.');
      return;
    }
    setState(() => _busy = true);
    final name = _name.text.trim().isEmpty ? 'New place' : _name.text.trim();
    final place = widget.existing ??
        Place(circleId: widget.circle.id ?? '', name: name, lat: _lat!, lng: _lng!);
    place
      ..name = name
      ..icon = _icon
      ..lat = _lat!
      ..lng = _lng!
      ..radiusM = _radius
      ..notifyArrive = _arrive
      ..notifyLeave = _leave
      ..address = _address;
    try {
      await ref.read(placeServiceProvider).save(place, widget.circle);
      if (!mounted) return;
      Navigator.of(context).pop();
      showScToast(context, '$name added · circle will be alerted');
    } catch (e) {
      debugPrint('[SafeCircle] savePlace: $e');
      if (mounted) {
        setState(() => _busy = false);
        showScToast(context, 'Could not save the place. Try again.');
      }
    }
  }

  Future<void> _delete() async {
    final id = widget.existing?.id;
    if (id == null) return;
    final ok = await showScConfirm(
      context,
      title: 'Delete ${widget.existing!.name}?',
      body: 'Your circle will no longer be alerted about arrivals and departures here.',
      confirmLabel: 'Delete place',
    );
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(placeServiceProvider).delete(id);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      debugPrint('[SafeCircle] deletePlace: $e');
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                      color: ScColors.borderDefault, borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.existing == null ? 'New place' : 'Edit place',
                  style: ScText.sans(size: 20, weight: FontWeight.w800)),
              const SizedBox(height: 14),
              ScInput(
                label: 'Name',
                placeholder: "e.g. Gym, Grandma's house",
                controller: _name,
                leadingIcon: FeatherIcons.mapPin,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  for (final k in placeIconKeys) ...[
                    ScPressable(
                      pressedScale: .94,
                      onTap: () => setState(() => _icon = k),
                      child: Container(
                        width: 44,
                        height: 44,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _icon == k ? ScColors.brandTint : ScColors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _icon == k ? ScColors.brand : ScColors.borderDefault,
                              width: _icon == k ? 1.5 : 1),
                        ),
                        child: Icon(placeIcon(k),
                            size: 19,
                            color: _icon == k ? ScColors.brand : ScColors.textMuted),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 150,
                  child: _lat == null
                      ? Container(
                          color: ScColors.surfaceSunken,
                          alignment: Alignment.center,
                          child: Text(_locating ? 'Getting your location…' : 'No location yet',
                              style: ScText.sans(
                                  size: 13, weight: FontWeight.w600, color: ScColors.textMuted)),
                        )
                      : FlutterMap(
                          options: MapOptions(
                            backgroundColor: kMapBackground,
                            minZoom: kMapMinZoom,
                            cameraConstraint: kWorldConstraint,
                            maxZoom: kMapMaxZoom,
                            initialCenter: LatLng(_lat!, _lng!),
                            initialZoom: 15,
                            interactionOptions:
                                const InteractionOptions(flags: InteractiveFlag.none),
                          ),
                          children: [
                            scTileLayer(),
                            CircleLayer(circles: [
                              CircleMarker(
                                point: LatLng(_lat!, _lng!),
                                radius: _radius,
                                useRadiusInMeter: true,
                                color: ScColors.brand.withValues(alpha: .14),
                                borderColor: ScColors.brand,
                                borderStrokeWidth: 2,
                              ),
                            ]),
                            MarkerLayer(markers: [
                              Marker(
                                point: LatLng(_lat!, _lng!),
                                width: 40,
                                height: 48,
                                alignment: Alignment.topCenter,
                                child: ScMapPinSmall(icon: placeIcon(_icon)),
                              ),
                            ]),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: ScButton(
                  label: 'Use my current location',
                  variant: ScButtonVariant.link,
                  fullWidth: false,
                  onPressed: _useCurrentLocation,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('ALERT RADIUS',
                      style: ScText.sans(
                          size: 11,
                          weight: FontWeight.w700,
                          color: ScColors.textMuted,
                          spacing: 1)),
                  const Spacer(),
                  Text(scFeet(_radius),
                      style: ScText.mono(
                          size: 13, weight: FontWeight.w700, color: ScColors.brand)),
                ],
              ),
              Slider(
                value: (_radius * 3.28084).clamp(300.0, 3000.0),
                min: 300,
                max: 3000,
                divisions: 27,
                activeColor: ScColors.brand,
                onChanged: (ft) => setState(() => _radius = ft / 3.28084),
              ),
              Row(
                children: [
                  Expanded(
                    child: _RuleToggle(
                      label: 'Arrives',
                      icon: FeatherIcons.logIn,
                      on: _arrive,
                      onTap: () => setState(() => _arrive = !_arrive),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _RuleToggle(
                      label: 'Leaves',
                      icon: FeatherIcons.logOut,
                      on: _leave,
                      onTap: () => setState(() => _leave = !_leave),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ScButton(label: 'Save Place', onPressed: _busy ? null : _save),
              if (widget.existing != null) ...[
                const SizedBox(height: 6),
                Center(
                  child: ScButton(
                    label: 'Delete place',
                    variant: ScButtonVariant.link,
                    fullWidth: false,
                    onPressed: _busy ? null : _delete,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleToggle extends StatelessWidget {
  const _RuleToggle(
      {required this.label, required this.icon, required this.on, required this.onTap});
  final String label;
  final IconData icon;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      pressedScale: .98,
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? ScColors.brandTint : ScColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: on ? ScColors.brand : ScColors.borderDefault, width: on ? 1.5 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: on ? ScColors.brand : ScColors.textMuted),
            const SizedBox(width: 8),
            Text(label,
                style: ScText.sans(
                    size: 14,
                    weight: FontWeight.w700,
                    color: on ? ScColors.brand : ScColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
