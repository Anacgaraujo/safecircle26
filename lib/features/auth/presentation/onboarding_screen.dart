import 'package:flutter/material.dart';
import 'package:safecircle/core/widgets/feather_icons.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safecircle/features/auth/data/auth_repository.dart';
import 'package:safecircle/features/auth/data/session_loader.dart';
import 'package:safecircle/features/auth/domain/auth_error.dart';
import 'package:safecircle/features/profile/data/user_repository.dart';
import 'package:safecircle/core/utils/phone.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/phone_field.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/core/permissions/permissions.dart';

const _kSocialLogin = false;

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key, this.resumeAfterRegister = false});
  final bool resumeAfterRegister;

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

enum _Step {
  welcome,
  create,
  login,
  recover,
  permissions,
  pinSafety,
  pinPanic,
  tutorial,
  done
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  late _Step step = widget.resumeAfterRegister ? _Step.permissions : _Step.welcome;

  String safetyPin = '';
  String panicPin = '';
  bool panicError = false;
  bool busy = false;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final pass2Ctrl = TextEditingController();
  String phoneCountry = kDefaultCountry;
  String phoneDigits = '';

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    pass2Ctrl.dispose();
    super.dispose();
  }

  void _go(_Step s) => setState(() => step = s);

  Future<void> _register() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    if (name.isEmpty) return showScToast(context, 'Enter your name.');
    if (email.isEmpty) return showScToast(context, 'Enter your email.');
    if (passCtrl.text.length < 6) {
      return showScToast(context, 'Password must have at least 6 characters.');
    }
    if (passCtrl.text != pass2Ctrl.text) {
      return showScToast(context, "Passwords don't match.");
    }
    setState(() => busy = true);
    try {
      final user = await ref.read(authRepositoryProvider).register(email, passCtrl.text);
      final phone = phoneDigits.isEmpty ? '' : formatPhone(phoneCountry, phoneDigits);
      await ref
          .read(userRepositoryProvider)
          .createUserDoc(uid: user.uid, name: name, email: email, phone: phone);
    } catch (e) {
      if (mounted) {
        showScToast(context, describeAuthError(e));
        setState(() => busy = false);
      }
    }
  }

  Future<void> _login() async {
    if (emailCtrl.text.trim().isEmpty || passCtrl.text.isEmpty) {
      return showScToast(context, 'Enter your email and password.');
    }
    setState(() => busy = true);
    try {
      await ref.read(authRepositoryProvider).login(emailCtrl.text, passCtrl.text);
    } catch (e) {
      if (mounted) {
        showScToast(context, describeAuthError(e));
        setState(() => busy = false);
      }
    }
  }

  Future<void> _recover() async {
    if (emailCtrl.text.trim().isEmpty) {
      return showScToast(context, 'Enter your email.');
    }
    setState(() => busy = true);
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(emailCtrl.text);
      if (mounted) {
        showScToast(context, 'Recovery link sent. Check your inbox.');
        setState(() {
          busy = false;
          step = _Step.login;
        });
      }
    } catch (e) {
      if (mounted) {
        showScToast(context, describeAuthError(e));
        setState(() => busy = false);
      }
    }
  }

  Future<void> _finishPanic() async {
    if (panicPin.length < 4) return;
    if (panicPin == safetyPin) {
      setState(() => panicError = true);
      return;
    }
    setState(() => busy = true);
    try {
      await ref.read(userRepositoryProvider).savePins(safety: safetyPin, panic: panicPin);
      if (mounted) _enterApp();
    } catch (e) {
      if (mounted) {
        showScToast(context, 'Could not save your PINs. Try again.');
        setState(() => busy = false);
      }
    }
  }

  void _enterApp() {
    Navigator.of(context).popUntil((r) => r.isFirst);
    ref.invalidate(sessionLoadProvider);
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = switch (step) {
      _Step.welcome => _buildWelcome(),
      _Step.create => _buildCreate(),
      _Step.login => _buildLogin(),
      _Step.recover => _buildRecover(),
      _Step.permissions => PermissionsScreen(onContinue: () => _go(_Step.pinSafety)),
      _Step.pinSafety => _buildPin(isPanic: false),
      _Step.pinPanic => _buildPin(isPanic: true),
      _Step.tutorial => _buildTutorial(),
      _Step.done => _buildDone(),
    };

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 340),
        switchInCurve: ScMotion.easeOut,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, .02), end: Offset.zero)
                .animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(
            key: ValueKey(step),
            child: SafeArea(
                child: (step == _Step.pinSafety || step == _Step.pinPanic)
                    ? body
                    : _scrollable(body))),
      ),
    );
  }

  Widget _scrollable(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -1.2),
              radius: 1.4,
              colors: [Color(0xFFFCD9EF), Color(0xFFFCE7F5), ScColors.canvas],
              stops: [0, .52, 1],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(44),
              bottomRight: Radius.circular(44),
            ),
          ),
          padding: const EdgeInsets.only(top: 18, bottom: 14),
          alignment: Alignment.center,
          child:
              Image.asset('assets/images/welcome-illustration.png', width: 296),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome to',
                    style: ScText.sans(
                        size: 18,
                        weight: FontWeight.w700,
                        color: ScColors.purple700,
                        spacing: .2)),
                const SizedBox(height: 4),
                Text('Safe Circle',
                    style: ScText.display(size: 47, spacing: -1.6, height: 47)),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  child: Text(
                    "Build a trusted circle and let someone always know you're safe.",
                    style: ScText.sans(
                        size: 16,
                        weight: FontWeight.w500,
                        color: ScColors.textSubtle,
                        height: 24),
                  ),
                ),
                const Spacer(),
                ScButton(
                    label: 'Start',
                    rightIcon: FeatherIcons.arrowRight,
                    onPressed: () => _go(_Step.create)),
                const SizedBox(height: 4),
                Center(
                  child: ScButton(
                    label: 'Skip intro',
                    variant: ScButtonVariant.link,
                    fullWidth: false,
                    onPressed: () => _go(_Step.login),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 6, 26, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScBackButton(onTap: () => _go(_Step.welcome)),
          const SizedBox(height: 10),
          Text('Create account', style: ScText.headline()),
          const SizedBox(height: 6),
          Text('Join SafeCircle in a few seconds.', style: ScText.sub()),
          const SizedBox(height: 24),
          ScInput(
              label: 'Name',
              placeholder: 'e.g. Alex Morgan',
              leadingIcon: FeatherIcons.user,
              controller: nameCtrl),
          const SizedBox(height: 16),
          ScInput(
              label: 'Email',
              placeholder: 'name@example.com',
              trailingIcon: FeatherIcons.mail,
              keyboardType: TextInputType.emailAddress,
              controller: emailCtrl),
          const SizedBox(height: 16),
          ScPhoneField(
            label: 'Phone',
            initialCountryCode: phoneCountry,
            initialDigits: phoneDigits,
            onChanged: (code, d) {
              phoneCountry = code;
              phoneDigits = d;
            },
          ),
          const SizedBox(height: 16),
          ScInput(
              label: 'Password',
              placeholder: '••••••••',
              obscure: true,
              controller: passCtrl),
          const SizedBox(height: 16),
          ScInput(
              label: 'Repeat password',
              placeholder: '••••••••',
              obscure: true,
              controller: pass2Ctrl),
          const Spacer(),
          const SizedBox(height: 26),
          ScButton(
              label: busy ? 'Creating account…' : 'Register',
              rightIcon: busy ? null : FeatherIcons.arrowRight,
              onPressed: busy ? null : _register),
          const SizedBox(height: 16),
          Center(
            child: Text.rich(
              TextSpan(
                text: 'Already have an account? ',
                style: ScText.sans(
                    size: 14,
                    weight: FontWeight.w500,
                    color: ScColors.textSecondary),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _go(_Step.login),
                      child: Text('Login',
                          style: ScText.sans(
                              size: 14,
                              weight: FontWeight.w800,
                              color: ScColors.brand)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogin() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 34),
          Center(child: Image.asset('assets/images/logo.png', height: 96)),
          const SizedBox(height: 16),
          Center(
            child: Text("Someone always knows you're safe.",
                style: ScText.sub(), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 22),
          ScInput(
              label: 'Email',
              placeholder: 'name@example.com',
              trailingIcon: FeatherIcons.mail,
              keyboardType: TextInputType.emailAddress,
              controller: emailCtrl),
          const SizedBox(height: 14),
          ScInput(
              label: 'Password',
              placeholder: '••••••••',
              obscure: true,
              controller: passCtrl),
          Align(
            alignment: Alignment.centerRight,
            child: ScButton(
                label: 'Forgot?',
                variant: ScButtonVariant.link,
                fullWidth: false,
                onPressed: () => _go(_Step.recover)),
          ),
          ScButton(
              label: busy ? 'Logging in…' : 'Login',
              rightIcon: busy ? null : FeatherIcons.arrowRight,
              onPressed: busy ? null : _login),
          if (_kSocialLogin) ...[
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                  child: Divider(color: ScColors.borderDefault, height: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('Or, login with...',
                    style: ScText.sans(
                        size: 12,
                        weight: FontWeight.w600,
                        color: ScColors.textMuted,
                        spacing: .4)),
              ),
              const Expanded(
                  child: Divider(color: ScColors.borderDefault, height: 1)),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _socialButton('Google', 'G')),
              const SizedBox(width: 12),
              Expanded(child: _socialButton('Apple', '')),
            ],
          ),
          ],
          const Spacer(),
          const SizedBox(height: 24),
          Center(
            child: Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                style: ScText.sans(
                    size: 14,
                    weight: FontWeight.w500,
                    color: ScColors.textSecondary),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _go(_Step.create),
                      child: Text('Register!',
                          style: ScText.sans(
                              size: 14,
                              weight: FontWeight.w800,
                              color: ScColors.brand)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(String label, String glyph) {
    return ScPressable(
      onTap: () => showScToast(context, 'Social login coming soon.'),
      pressedScale: .98,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: ScColors.surfaceCard,
          borderRadius: BorderRadius.circular(15),
          boxShadow: ScShadows.card,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(glyph, style: ScText.sans(size: 18, weight: FontWeight.w800)),
            const SizedBox(width: 8),
            Text(label, style: ScText.sans(size: 15, weight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecover() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 6, 26, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScBackButton(onTap: () => _go(_Step.login)),
          const SizedBox(height: 10),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: ScColors.brandTint,
                borderRadius: BorderRadius.circular(20)),
            child: const Icon(FeatherIcons.lock, size: 28, color: ScColors.brand),
          ),
          const SizedBox(height: 20),
          Text('Recover password', style: ScText.headline()),
          const SizedBox(height: 10),
          Text(
            "Enter the email linked to your account and we'll send you a secure link to reset your password.",
            style: ScText.sub(),
          ),
          const SizedBox(height: 24),
          ScInput(
              label: 'Email',
              placeholder: 'name@example.com',
              trailingIcon: FeatherIcons.mail,
              keyboardType: TextInputType.emailAddress,
              controller: emailCtrl),
          const Spacer(),
          const SizedBox(height: 26),
          ScButton(
              label: busy ? 'Sending…' : 'Recover password',
              rightIcon: busy ? null : FeatherIcons.send,
              onPressed: busy ? null : _recover),
        ],
      ),
    );
  }

  Widget _buildPin({required bool isPanic}) {
    final pin = isPanic ? panicPin : safetyPin;

    void press(String d) {
      if (pin.length >= 4) return;
      setState(() {
        if (isPanic) {
          panicPin += d;
          panicError = false;
        } else {
          safetyPin += d;
        }
      });
    }

    void del() {
      if (pin.isEmpty) return;
      setState(() {
        if (isPanic) {
          panicPin = panicPin.substring(0, panicPin.length - 1);
          panicError = false;
        } else {
          safetyPin = safetyPin.substring(0, safetyPin.length - 1);
        }
      });
    }

    Widget stepDot(bool on) => Container(
          width: 30,
          height: 4,
          decoration: BoxDecoration(
            color: on ? ScColors.brand : ScColors.borderDefault,
            borderRadius: BorderRadius.circular(2),
          ),
        );

    return LayoutBuilder(builder: (context, constraints) {
      final fixed = isPanic ? 400.0 : 350.0;
      const gap = 12.0;
      final keySize =
          ((constraints.maxHeight - fixed - 3 * gap) / 4).clamp(42.0, 58.0);

      return Padding(
        padding: const EdgeInsets.fromLTRB(26, 0, 26, 12),
        child: Column(
          children: [
            if (isPanic)
              ScBackButton(onTap: () => _go(_Step.pinSafety))
            else
              ScBackButton(onTap: () => _go(_Step.permissions)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              stepDot(true),
              const SizedBox(width: 7),
              stepDot(isPanic),
            ]),
            const SizedBox(height: 6),
            Text('STEP ${isPanic ? 2 : 1} OF 2', style: ScText.micro()),
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: ScColors.brandTint,
                  borderRadius: BorderRadius.circular(13)),
              child: Icon(isPanic ? FeatherIcons.eyeOff : FeatherIcons.shield,
                  size: 20, color: ScColors.brand),
            ),
            const SizedBox(height: 8),
            Text(isPanic ? 'Set your panic PIN' : 'Set your safety PIN',
                textAlign: TextAlign.center,
                style: ScText.sans(
                    size: 22,
                    weight: FontWeight.w800,
                    color: ScColors.textHeading,
                    height: 27,
                    spacing: -0.5)),
            const SizedBox(height: 6),
            SizedBox(
              width: 320,
              child: Text(
                isPanic
                    ? "If you're forced to open the app, enter this PIN. The screen looks normal, but your circle is silently alerted."
                    : "Use this PIN to confirm you're safe during check-ins.",
                textAlign: TextAlign.center,
                style: ScText.sans(
                    size: 13,
                    weight: FontWeight.w500,
                    color: ScColors.textSubtle,
                    height: 18),
              ),
            ),
            const SizedBox(height: 14),
            PinBoxes(length: pin.length, error: isPanic && panicError),
            const Spacer(),
            PinKeypad(onDigit: press, onDelete: del, keySize: keySize, gap: gap),
            const Spacer(),
            if (isPanic)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: panicError
                    ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(FeatherIcons.alertCircle,
                            size: 15, color: ScColors.red500),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                              'That matches your safety PIN. Choose a different code.',
                              style: ScText.sans(
                                  size: 12.5,
                                  weight: FontWeight.w700,
                                  color: ScColors.red500,
                                  height: 17)),
                        ),
                      ])
                    : Text('Must be different from your safety PIN.',
                        textAlign: TextAlign.center,
                        style: ScText.sans(
                            size: 12.5,
                            weight: FontWeight.w500,
                            color: ScColors.textMuted,
                            height: 17)),
              ),
            ScButton(
              label: isPanic ? (busy ? 'Saving…' : 'Finish') : 'Continue',
              rightIcon: isPanic ? null : FeatherIcons.arrowRight,
              onPressed: pin.length == 4 && !busy
                  ? (isPanic ? _finishPanic : () => _go(_Step.pinPanic))
                  : null,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTutorial() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 26, 26, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GETTING STARTED',
              style: ScText.sans(
                  size: 12,
                  weight: FontWeight.w700,
                  color: ScColors.brand,
                  spacing: .9)),
          const SizedBox(height: 8),
          Text('Create your first Circle',
              style: ScText.sans(
                  size: 28,
                  weight: FontWeight.w800,
                  color: ScColors.textHeading,
                  height: 34,
                  spacing: -0.6)),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: 'Tap ',
              style: ScText.sans(
                  size: 15,
                  weight: FontWeight.w500,
                  color: ScColors.textSubtle,
                  height: 23),
              children: [
                TextSpan(
                    text: 'Circles',
                    style: ScText.sans(
                        size: 15, weight: FontWeight.w800, color: ScColors.brand)),
                const TextSpan(
                    text:
                        " in the bottom bar, give it a name, and add the people you trust. They'll get an invite to follow your journeys."),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: 26),
          ScButton(
              label: 'Next',
              rightIcon: FeatherIcons.arrowRight,
              onPressed: () => _go(_Step.done)),
        ],
      ),
    );
  }

  Widget _buildDone() {
    return Padding(
      padding: const EdgeInsets.all(34),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 104,
              height: 104,
              decoration: const BoxDecoration(
                  color: ScColors.green50, shape: BoxShape.circle),
              child: const Icon(FeatherIcons.checkCircle,
                  size: 48, color: ScColors.green500),
            ),
          ),
          const SizedBox(height: 26),
          Text("You're all set!",
              textAlign: TextAlign.center,
              style: ScText.sans(
                  size: 30,
                  weight: FontWeight.w800,
                  color: ScColors.textHeading,
                  height: 36,
                  spacing: -0.6)),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 280,
              child: Text(
                'Your SafeCircle is ready. Plan your first journey whenever you head out.',
                textAlign: TextAlign.center,
                style: ScText.sub(),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ScButton(label: 'Enter SafeCircle', onPressed: _enterApp),
        ],
      ),
    );
  }
}
