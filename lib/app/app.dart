import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safecircle/app/main_shell.dart';
import 'package:safecircle/core/session/session.dart';
import 'package:safecircle/core/theme/sc_theme.dart';
import 'package:safecircle/core/widgets/sc_widgets.dart';
import 'package:safecircle/features/auth/data/auth_repository.dart';
import 'package:safecircle/features/auth/data/session_loader.dart';
import 'package:safecircle/features/auth/presentation/onboarding_screen.dart';

class SafeCircleApp extends StatelessWidget {
  const SafeCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeCircle',
      debugShowCheckedModeBanner: false,
      theme: buildScTheme(),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (_, next) {
      if (next is AsyncData && next.value == null) ref.read(sessionProvider).clear();
    });
    return switch (ref.watch(authStateProvider)) {
      AsyncData(value: final user?) =>
        _SessionGate(user: (uid: user.uid, email: user.email ?? '')),
      AsyncData() || AsyncError() => const OnboardingFlow(),
      _ => const _Splash(),
    };
  }
}

class _SessionGate extends ConsumerWidget {
  const _SessionGate({required this.user});
  final SessionUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(sessionLoadProvider(user)).when(
          skipLoadingOnRefresh: false,
          loading: () => const _Splash(),
          error: (_, __) => _SessionError(onRetry: () => ref.invalidate(sessionLoadProvider(user))),
          data: (hasPins) =>
              hasPins ? const MainShell() : const OnboardingFlow(resumeAfterRegister: true),
        );
  }
}

class _SessionError extends ConsumerWidget {
  const _SessionError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(34),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/logo.png', height: 64),
              const SizedBox(height: 28),
              Text("We couldn't load your account",
                  textAlign: TextAlign.center,
                  style: ScText.sans(
                      size: 20, weight: FontWeight.w800, color: ScColors.textHeading)),
              const SizedBox(height: 10),
              Text('Check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: ScText.sub()),
              const SizedBox(height: 32),
              ScButton(label: 'Try again', onPressed: onRetry),
              const SizedBox(height: 8),
              Center(
                child: ScButton(
                  label: 'Log out',
                  variant: ScButtonVariant.link,
                  fullWidth: false,
                  onPressed: () => ref.read(authRepositoryProvider).logout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScColors.canvas,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 72),
            const SizedBox(height: 24),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: ScColors.brand),
            ),
          ],
        ),
      ),
    );
  }
}
