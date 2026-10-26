import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/core/theme/app_spacing.dart';
import 'package:rechivia/core/widgets/primary_button.dart';
import 'package:rechivia/features/onboarding/presentation/onboarding_slide.dart';
import 'package:rechivia/features/onboarding/presentation/widgets/onboarding_slide_view.dart';
import 'package:rechivia/features/onboarding/presentation/widgets/page_indicator.dart';

/// Carrousel d'introduction : présente l'application en quelques diapositives.
///
/// L'utilisateur peut avancer avec "Suivant", glisser avec le doigt, ou tout
/// sauter avec "Passer". Dans les deux cas il arrive sur l'écran de bienvenue.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == onboardingSlides.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_isLastPage) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _finish() => context.go(AppRoutes.welcome);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text('Passer'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingSlides.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  return OnboardingSlideView(slide: onboardingSlides[index]);
                },
              ),
            ),
            PageIndicator(
              count: onboardingSlides.length,
              currentIndex: _currentPage,
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: PrimaryButton(
                label: _isLastPage ? 'Commencer' : 'Suivant',
                onPressed: _onNext,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
