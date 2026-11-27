import 'package:flutter/material.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';

import 'package:safecircle/core/platform/local_image.dart';

import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/l10n/l10n.dart';

enum ScButtonVariant { primary, secondary, ghost, danger, ink, link }

class ScButton extends StatelessWidget {
  const ScButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ScButtonVariant.primary,
    this.leftIcon,
    this.rightIcon,
    this.fullWidth = true,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final ScButtonVariant variant;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool fullWidth;
  final double height;

  bool get _disabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    if (variant == ScButtonVariant.link) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: ScColors.brand,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
        child: Text(label, style: ScText.sans(size: 14, weight: FontWeight.w800, color: ScColors.brand)),
      );
    }

    Color bg;
    Color fg;
    List<BoxShadow> shadow = const [];
    BoxBorder? border;
    switch (variant) {
      case ScButtonVariant.primary:
        bg = _disabled ? ScColors.brand.withValues(alpha: .4) : ScColors.brand;
        fg = Colors.white;
        if (!_disabled) shadow = ScShadows.brand;
        break;
      case ScButtonVariant.secondary:
        bg = ScColors.brandTint;
        fg = ScColors.brand;
        break;
      case ScButtonVariant.ghost:
        bg = Colors.transparent;
        fg = ScColors.textSecondary;
        border = Border.all(color: ScColors.borderDefault, width: 1.5);
        break;
      case ScButtonVariant.danger:
        bg = ScColors.red500;
        fg = Colors.white;
        break;
      case ScButtonVariant.ink:
        bg = ScColors.ink;
        fg = Colors.white;
        break;
      case ScButtonVariant.link:
        bg = Colors.transparent;
        fg = ScColors.brand;
    }

    return _Pressable(
      onTap: onPressed,
      pressedScale: .98,
      child: Container(
        height: height,
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(15),
          boxShadow: shadow,
          border: border,
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null) ...[
              Icon(leftIcon, size: 19, color: fg),
              const SizedBox(width: 9),
            ],
            // A long label (or translation) shrinks to fit instead of overflowing.
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label, style: ScText.sans(size: 16, weight: FontWeight.w800, color: fg)),
              ),
            ),
            if (rightIcon != null) ...[
              const SizedBox(width: 9),
              Icon(rightIcon, size: 19, color: fg),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pressable extends StatefulWidget {
  const _Pressable({required this.child, this.onTap, this.pressedScale = .985});
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? widget.pressedScale : 1,
        duration: ScMotion.fast,
        curve: ScMotion.easeOut,
        child: widget.child,
      ),
    );
  }
}

class ScPressable extends StatelessWidget {
  const ScPressable({super.key, required this.child, this.onTap, this.pressedScale = .985});
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  @override
  Widget build(BuildContext context) =>
      _Pressable(onTap: onTap, pressedScale: pressedScale, child: child);
}

class ScCard extends StatelessWidget {
  const ScCard({super.key, required this.child, this.padding = const EdgeInsets.all(14), this.radius = 16, this.color = ScColors.surfaceCard});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: ScShadows.card,
      ),
      child: child,
    );
  }
}

class ScSectionLabel extends StatelessWidget {
  const ScSectionLabel(this.text, {super.key, this.icon, this.iconColor = ScColors.textMuted});
  final String text;
  final IconData? icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 8),
        ],
        Text(text.toUpperCase(), style: ScText.micro()),
      ],
    );
  }
}

enum ScAvatarRing { none, safe, overdue, brand }

class ScAvatar extends StatelessWidget {
  const ScAvatar({super.key, this.image, required this.name, this.size = 48, this.ring = ScAvatarRing.none});

  final String? image;
  final String name;
  final double size;
  final ScAvatarRing ring;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  Widget _fallback(double size) => Container(
        width: size,
        height: size,
        color: ScColors.brandTint,
        alignment: Alignment.center,
        child: Text(
          _initials,
          style: ScText.sans(size: size * .34, weight: FontWeight.w800, color: ScColors.brand),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Color? ringColor;
    switch (ring) {
      case ScAvatarRing.safe:
        ringColor = ScColors.green600;
      case ScAvatarRing.overdue:
        ringColor = ScColors.red500;
      case ScAvatarRing.brand:
        ringColor = ScColors.brand;
      case ScAvatarRing.none:
        ringColor = null;
    }

    Widget? picture;
    if (image != null) {
      if (image!.startsWith('assets/')) {
        picture = Image.asset(image!, width: size, height: size, fit: BoxFit.cover);
      } else {
        final provider = localImageProvider(image!);
        if (provider != null) {
          picture = Image(
            image: provider,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(size),
          );
        }
      }
    }

    final inner = ClipOval(child: picture ?? _fallback(size));

    if (ringColor == null) return inner;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 2.5),
      ),
      child: inner,
    );
  }
}

class ScInput extends StatelessWidget {
  const ScInput({
    super.key,
    required this.label,
    this.placeholder,
    this.leadingIcon,
    this.trailingIcon,
    this.obscure = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
  });

  final String label;
  final String? placeholder;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ScText.sans(size: 14, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: ScColors.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            boxShadow: ScShadows.card,
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 20, color: ScColors.textSubtle),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  textInputAction: textInputAction,
                  style: ScText.sans(size: 16, weight: FontWeight.w500),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: placeholder,
                    hintStyle: ScText.sans(size: 16, weight: FontWeight.w500, color: ScColors.textMuted),
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 12),
                Icon(trailingIcon, size: 20, color: ScColors.textMuted),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class PinBoxes extends StatelessWidget {
  const PinBoxes({super.key, required this.length, this.total = 4, this.error = false});
  final int length;
  final int total;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final accent = error ? ScColors.red500 : ScColors.brand;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final filled = i < length;
        final active = !error && i == length;
        final ringErr = error && i == (length - 1).clamp(0, total - 1);
        return Container(
          width: 56,
          height: 64,
          margin: EdgeInsets.only(right: i == total - 1 ? 0 : 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ScColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: ScShadows.card,
            border: (active || ringErr) ? Border.all(color: accent, width: 2) : null,
          ),
          child: filled
              ? Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                )
              : null,
        );
      }),
    );
  }
}

class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onDelete,
    this.keySize = 66,
    this.gap = 16,
  });
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final double keySize;
  final double gap;

  Widget _key(String d) {
    return Semantics(
      button: true,
      label: d,
      onTap: () => onDigit(d),
      excludeSemantics: true,
      child: _keyBody(d),
    );
  }

  Widget _keyBody(String d) {
    return ScPressable(
      onTap: () => onDigit(d),
      pressedScale: .92,
      child: Container(
        width: keySize,
        height: keySize,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: ScColors.surfaceCard,
          shape: BoxShape.circle,
          boxShadow: ScShadows.card,
        ),
        child: Text(d, style: ScText.sans(size: keySize * .4, weight: FontWeight.w800, height: keySize * .4)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget row(List<Widget> children) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              children[i],
            ],
          ],
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        row([_key('1'), _key('2'), _key('3')]),
        SizedBox(height: gap),
        row([_key('4'), _key('5'), _key('6')]),
        SizedBox(height: gap),
        row([_key('7'), _key('8'), _key('9')]),
        SizedBox(height: gap),
        row([
          SizedBox(width: keySize, height: keySize),
          _key('0'),
          Semantics(
            button: true,
            label: context.l10n.delete,
            child: ScPressable(
              onTap: onDelete,
              pressedScale: .92,
              child: SizedBox(
                width: keySize,
                height: keySize,
                child: const Icon(FeatherIcons.delete, size: 24, color: ScColors.textSecondary),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}

Future<bool> showScConfirm(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  IconData icon = FeatherIcons.trash2,
  String? cancelLabel,
  bool danger = true,
}) async {
  final accent = danger ? ScColors.red500 : ScColors.brand;
  final ok = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x730C0710),
    builder: (dialogContext) => Dialog(
      backgroundColor: ScColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                  color: danger ? ScColors.red50 : ScColors.brandTint, shape: BoxShape.circle),
              child: Icon(icon, size: 24, color: accent),
            ),
            const SizedBox(height: 14),
            Text(title,
                textAlign: TextAlign.center,
                style: ScText.sans(size: 19, weight: FontWeight.w800, color: ScColors.textHeading)),
            const SizedBox(height: 8),
            Text(body,
                textAlign: TextAlign.center,
                style: ScText.sans(
                    size: 13.5, weight: FontWeight.w500, color: ScColors.textSecondary, height: 19)),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(confirmLabel,
                    style: ScText.sans(size: 15, weight: FontWeight.w800, color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelLabel ?? context.l10n.cancel,
                  style: ScText.sans(size: 14, weight: FontWeight.w700, color: ScColors.textMuted)),
            ),
          ],
        ),
      ),
    ),
  );
  return ok ?? false;
}

void showScToast(BuildContext context, String message) =>
    showScToastOn(Overlay.of(context, rootOverlay: true), message);

/// Shows a toast on [overlay]. Grab the root overlay before a long save and
/// use this, so the message still shows if the user leaves the screen first.
void showScToastOn(OverlayState overlay, String message) {
  if (!overlay.mounted) return;
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => Positioned(
      left: 0,
      right: 0,
      bottom: 110,
      child: IgnorePointer(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            curve: ScMotion.easeOut,
            builder: (_, t, child) => Opacity(
              opacity: t,
              child: Transform.translate(offset: Offset(0, (1 - t) * 10), child: child),
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: ScColors.ink,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: ScShadows.lg,
                ),
                child: Text(message, style: ScText.sans(size: 13.5, weight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  overlay.insert(entry);
  // Long messages (e.g. who has no account yet) stay up long enough to read.
  final ms = (1600 + message.length * 45).clamp(2200, 7000);
  Future.delayed(Duration(milliseconds: ms), () {
    if (entry.mounted) entry.remove();
  });
}

class ScBackButton extends StatelessWidget {
  const ScBackButton({super.key, this.label, this.onTap});
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onTap ?? () => Navigator.of(context).maybePop(),
        icon: const Icon(FeatherIcons.arrowLeft, size: 20, color: ScColors.textSecondary),
        label: Text(label ?? context.l10n.back, style: ScText.sans(size: 15, weight: FontWeight.w700, color: ScColors.textSecondary)),
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8)),
      ),
    );
  }
}

class ScCircleIconButton extends StatelessWidget {
  const ScCircleIconButton({super.key, required this.icon, this.onTap, this.size = 44, this.showDot = false});
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return ScPressable(
      onTap: onTap,
      pressedScale: .9,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: ScColors.surfaceCard,
          shape: BoxShape.circle,
          boxShadow: ScShadows.card,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 22, color: ScColors.textPrimary),
            if (showDot)
              Positioned(
                top: 9,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: ScColors.brand,
                    shape: BoxShape.circle,
                    border: Border.all(color: ScColors.surfaceCard, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ScStreamError extends StatelessWidget {
  const ScStreamError({super.key, required this.error, this.compact = false});
  final Object error;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    debugPrint('[SafeCircle] stream error: $error');
    final msg = error.toString();
    final needsIndex = msg.contains('index');
    final denied = msg.contains('permission-denied') || msg.contains('PERMISSION_DENIED');
    final hint = needsIndex
        ? 'Firestore needs an index for this list (see firestore.indexes.json).'
        : denied
            ? 'Access denied by Firestore rules (publish firestore.rules).'
            : context.l10n.checkConnection;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FeatherIcons.alertCircle, size: 40, color: ScColors.red500),
            const SizedBox(height: 12),
            Text(context.l10n.couldNotLoadThis,
                textAlign: TextAlign.center,
                style: ScText.sans(size: 16, weight: FontWeight.w800, color: ScColors.textHeading)),
            const SizedBox(height: 6),
            Text(hint,
                textAlign: TextAlign.center,
                style: ScText.sans(size: 13.5, weight: FontWeight.w500, color: ScColors.textSecondary, height: 19)),
          ],
        ),
      ),
    );
  }
}
