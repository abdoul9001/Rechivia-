import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rechivia/app.dart';
import 'package:rechivia/core/router/app_router.dart';
import 'package:rechivia/core/router/app_routes.dart';
import 'package:rechivia/features/auth/data/fake_auth_repository.dart';
import 'package:rechivia/features/auth/presentation/providers/auth_providers.dart';
import 'package:rechivia/features/preferences/data/fake_preferences_repository.dart';
import 'package:rechivia/features/preferences/presentation/providers/preferences_providers.dart';

/// Démarre l'application complète pour un test avec un dépôt factice rapide.
Future<void> pumpRechivia(
  WidgetTester tester, {
  String initialLocation = AppRoutes.onboarding,
  FakePreferencesRepository? preferencesRepository,
}) async {
  tester.view.physicalSize = const Size(1200, 3000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(latency: Duration.zero),
        ),
        preferencesRepositoryProvider.overrideWithValue(
          preferencesRepository ??
              FakePreferencesRepository(latency: Duration.zero),
        ),
      ],
      child: RechiviaApp(
        router: createAppRouter(initialLocation: initialLocation),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
