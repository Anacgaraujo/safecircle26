import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/circles/data/circle_repository.dart';
import 'package:safecircle/features/circles/domain/circle.dart';
import 'package:safecircle/features/circles/presentation/add_participants_screen.dart';

class CircleNameScreen extends ConsumerStatefulWidget {
  const CircleNameScreen({super.key, this.circle});

  final Circle? circle;

  @override
  ConsumerState<CircleNameScreen> createState() => _CircleNameScreenState();
}

class _CircleNameScreenState extends ConsumerState<CircleNameScreen> {
  late final TextEditingController ctrl = TextEditingController(text: widget.circle?.name ?? '');
  bool _saving = false;

  bool get isRename => widget.circle != null;

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final name = ctrl.text.trim();
    if (name.isEmpty || _saving) return;
    if (isRename) {
      setState(() => _saving = true);
      widget.circle!.name = name;
      await ref.read(circleRepositoryProvider).updateCircle(widget.circle!);
      if (mounted) Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AddParticipantsScreen(draft: Circle(name: name))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScBackButton(),
              const SizedBox(height: 10),
              Text(isRename ? 'Rename circle' : 'Name your circle', style: ScText.headline()),
              const SizedBox(height: 6),
              Text('Pick a name — add an emoji to make it easy to spot.', style: ScText.sub()),
              const SizedBox(height: 26),
              ScInput(
                label: "Circle's name",
                placeholder: 'e.g. 🏠 Family',
                leadingIcon: FeatherIcons.users,
                controller: ctrl,
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              ScButton(
                label: isRename ? (_saving ? 'Saving…' : 'Save') : 'Continue',
                rightIcon: isRename ? null : FeatherIcons.arrowRight,
                onPressed: ctrl.text.trim().isEmpty || _saving ? null : _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
