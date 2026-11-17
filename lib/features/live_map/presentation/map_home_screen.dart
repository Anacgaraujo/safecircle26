import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart' hide Circle, Path;

import 'package:safecircle/core/permissions/permissions.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/utils/clock.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_camera.dart';
import 'package:safecircle/core/widgets/sc_tiles.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/live_map/application/live_sharing.dart';
import 'package:safecircle/features/live_map/data/status_repository.dart';
import 'package:safecircle/features/live_map/domain/map_rules.dart';
import 'package:safecircle/features/live_map/domain/tracking.dart';
import 'package:safecircle/features/live_map/presentation/member_pin.dart';
import 'package:safecircle/features/live_map/presentation/widgets/map_controls.dart';
import 'package:safecircle/features/live_map/presentation/widgets/map_top_bar.dart';
import 'package:safecircle/features/live_map/presentation/widgets/member_card.dart';
import 'package:safecircle/features/live_map/presentation/widgets/safety_strip_view.dart';
import 'package:safecircle/features/places/data/place_repository.dart';
import 'package:safecircle/l10n/l10n.dart';

class MapHomeScreen extends ConsumerStatefulWidget {
  const MapHomeScreen({super.key, this.onGoCircles, this.onToggleHome});
  final VoidCallback? onGoCircles;

  final VoidCallback? onToggleHome;

  @override
  ConsumerState<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends ConsumerState<MapHomeScreen> with TickerProviderStateMixin {
  final _map = MapController();
  late final _glide = ScCameraGlide(this, _map);
  PageController? _pages;
  double _pagesFraction = 0;

  PageController _pageController(double screenWidth) {
    final fraction = ((screenWidth - 28) / screenWidth).clamp(.5, 1.0);
    if (_pages == null || (fraction - _pagesFraction).abs() > .001) {
      _pages?.dispose();
      _pagesFraction = fraction;
      _pages = PageController(viewportFraction: fraction, initialPage: _focus);
    }
    return _pages!;
  }

  String? _circleId;
  int _focus = 0;

  String? _focusUid;

  bool _userPicked = false;
  bool _menuOpen = false;
  bool _mapReady = false;
  String? _centeredOn;

  LatLng? _centeredAt;
  bool _following = true;
  DateTime? _lastFollow;

  final _stackKey = GlobalKey();
  final _sheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.read(liveSharingProvider.notifier).startIfAllowed();
  }

  @override
  void dispose() {
    _pages?.dispose();
    _glide.dispose();
    super.dispose();
  }

  Offset _focusOffset() {
    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final sheet = _sheetKey.currentContext?.findRenderObject() as RenderBox?;
    if (stack == null || sheet == null || !stack.hasSize || !sheet.hasSize) {
      return Offset.zero;
    }
    final sheetTop = sheet.localToGlobal(Offset.zero, ancestor: stack).dy;
    const top = 64.0;
    if (sheetTop < top + 60) return Offset.zero;
    return Offset(0, (top + sheetTop) / 2 + 36 - stack.size.height / 2);
  }

  void _focusOn(int i, List<MemberStatus> list, {bool scroll = true, bool byUser = true}) {
    if (i < 0 || i >= list.length) return;
    final s = list[i];
    if (byUser && s.uid != _focusUid) _userPicked = true;
    setState(() {
      _focus = i;
      _focusUid = s.uid;
    });
    if (_mapReady && s.hasPosition) {
      _glide.to(LatLng(s.lat!, s.lng!), _map.camera.zoom.clamp(14.0, 17.0),
          offset: _focusOffset());
      _centeredOn = s.uid;
      _centeredAt = LatLng(s.lat!, s.lng!);
      _lastFollow = DateTime.now();
      _following = true;
    }
    if (scroll && (_pages?.hasClients ?? false)) {
      _pages!.animateToPage(i,
          duration: const Duration(milliseconds: 420), curve: ScMotion.easeOut);
    }
  }

  MemberStatus? _syncFocus(List<MemberStatus> members, String me) {
    if (members.isEmpty) return null;
    var idx = _focusUid == null ? -1 : members.indexWhere((m) => m.uid == _focusUid);
    if (!_userPicked && (idx < 0 || members[idx].uid == me)) {
      final other = members.indexWhere((m) => m.uid != me);
      if (other >= 0) idx = other;
    }
    _focus = idx >= 0 ? idx : _focus.clamp(0, members.length - 1);
    if (!_userPicked) _focusUid = members[_focus].uid;
    final pages = _pages;
    if (pages != null && pages.hasClients && pages.page?.round() != _focus) {
      final target = _focus;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pages.hasClients && pages.page?.round() != target) pages.jumpToPage(target);
      });
    }
    final focus = members[_focus];
    final moved = shouldFollow(
        member: focus, centeredAt: _centeredAt, lastFollow: _lastFollow, now: DateTime.now());
    if (_mapReady && (focus.uid != _centeredOn || (_following && moved))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusOn(_focus, members, scroll: false, byUser: false);
      });
    }
    return focus;
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.now(const Duration(seconds: 30));
    final me = ref.watch(sessionProvider).uid;
    final circles = ref.watch(myCirclesProvider).value ?? const <Circle>[];
    final circle = circles.where((c) => c.id == _circleId).firstOrNull ?? circles.firstOrNull;
    final members = visibleMembers(
        ref.watch(circleStatusProvider).value ?? const <MemberStatus>[], circle, me);
    final focus = _syncFocus(members, me);
    final places = (ref.watch(placesProvider).value ?? const <Place>[])
        .where((p) => p.enabled && (circle == null || p.circleId == circle.id))
        .toList();

    return Stack(
      key: _stackKey,
      children: [
        Positioned.fill(child: _buildMap(members, places, focus, me, now)),
        MapTopBar(
          circles: circles,
          circle: circle,
          onToggleMenu: () => setState(() => _menuOpen = !_menuOpen),
          onGoCircles: widget.onGoCircles,
          onToggleHome: widget.onToggleHome,
        ),
        _buildSheet(members, circles, me, now),
        if (_menuOpen)
          CircleMenu(
            circles: circles,
            selected: circle,
            onPick: (c) => setState(() {
              _circleId = c.id;
              _focus = 0;
              _menuOpen = false;
              _centeredOn = null;
            }),
          ),
      ],
    );
  }

  Widget _buildMap(
      List<MemberStatus> members, List<Place> places, MemberStatus? focus, String me, DateTime now) {
    final located = focus?.hasPosition == true;
    final center = located ? LatLng(focus!.lat!, focus.lng!) : const LatLng(39.5, -98.35);

    return FlutterMap(
      mapController: _map,
      options: MapOptions(
        backgroundColor: kMapBackground,
        minZoom: kMapMinZoom,
        cameraConstraint: kWorldConstraint,
        maxZoom: kMapMaxZoom,
        initialCenter: center,
        initialZoom: located ? 15.5 : 3.8,
        onMapReady: () {
          _mapReady = true;
          if (focus != null) _focusOn(_focus, members, scroll: false, byUser: false);
        },
        onPositionChanged: (camera, hasGesture) {
          if (hasGesture) {
            _following = false;
            _glide.stop();
          }
        },
        interactionOptions:
            const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
      ),
      children: [
        scTileLayer(),
        scMapAttribution(alignment: const Alignment(-1, -0.72)),
        CircleLayer(
          circles: [
            for (final p in places)
              CircleMarker(
                point: LatLng(p.lat, p.lng),
                radius: p.radiusM,
                useRadiusInMeter: true,
                color: ScColors.brand.withValues(alpha: .08),
                borderColor: ScColors.brand.withValues(alpha: .35),
                borderStrokeWidth: 1.5,
              ),
          ],
        ),
        MarkerLayer(
          markers: [
            for (final p in places)
              Marker(
                point: LatLng(p.lat, p.lng),
                width: 140,
                height: 26,
                child: Center(child: PlaceLabel(place: p)),
              ),
          ],
        ),
        MarkerLayer(
          markers: [
            for (var i = 0; i < members.length; i++)
              Marker(
                point: LatLng(members[i].lat!, members[i].lng!),
                width: 64,
                height: 86,
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () => _focusOn(i, members),
                  child: MemberPin(
                    status: members[i],
                    focused: i == _focus,
                    isMe: members[i].uid == me,
                    stale: members[i].isStale(now),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _startSharing(BuildContext context) async {
    if (!await ensureLiveSharingPermissions(context)) return;
    final running = await ref.read(liveSharingProvider.notifier).resume();
    if (!context.mounted) return;
    showScToast(
        context,
        running
            ? context.l10n.sharingWithCircles
            : context.l10n.locationOffEnable);
  }

  Widget _buildSheet(List<MemberStatus> members, List<Circle> circles, String me, DateTime now) {
    final sharing = ref.watch(liveSharingProvider);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        key: _sheetKey,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              children: [
                Expanded(child: SafetyStripView(onGoCircles: widget.onGoCircles)),
                const SizedBox(width: 10),
                MapRoundButton(
                  icon: FeatherIcons.navigation,
                  iconColor: ScColors.brand,
                  onTap: () {
                    final mine = members.indexWhere((m) => m.uid == me);
                    if (mine >= 0) {
                      _focusOn(mine, members);
                    } else {
                      showScToast(context, context.l10n.positionNotShared);
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: ScColors.canvas,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              boxShadow: [
                BoxShadow(color: Color(0x1F000000), offset: Offset(0, -8), blurRadius: 30),
              ],
            ),
            padding: const EdgeInsets.only(top: 10, bottom: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                      color: ScColors.borderDefault, borderRadius: BorderRadius.circular(3)),
                ),
                const SizedBox(height: 12),
                if (!sharing)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: ShareLocationCta(onTap: () => _startSharing(context)),
                  ),
                if (members.isEmpty)
                  NoOneSharing(onGoCircles: widget.onGoCircles)
                else ...[
                  SizedBox(
                    height: 268,
                    child: PageView.builder(
                      controller: _pageController(MediaQuery.of(context).size.width),
                      padEnds: false,
                      itemCount: members.length,
                      onPageChanged: (i) => _focusOn(i, members, scroll: false),
                      itemBuilder: (context, i) => Padding(
                        padding: EdgeInsets.only(left: i == 0 ? 20 : 5, right: 5),
                        child: MemberCard(
                          status: members[i],
                          isMe: members[i].uid == me,
                          now: now,
                          phone: phoneOfMember(members[i], circles),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < members.length; i++) ...[
                        if (i > 0) const SizedBox(width: 5),
                        AnimatedContainer(
                          duration: ScMotion.base,
                          width: i == _focus ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _focus ? ScColors.brand : ScColors.borderDefault,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
