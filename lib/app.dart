import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rechivia/core/router/app_router.dart';
import 'package:rechivia/core/theme/app_theme.dart';

/// Widget racine de Rechivia : applique le thème et la navigation.
///
/// Le routeur est créé une seule fois (dans l'état du widget) pour ne pas
/// perdre la position de l'utilisateur quand l'application se redessine.
/// Un [router] peut être injecté, ce qui sert surtout aux tests.
class RechiviaApp extends StatefulWidget {
  const RechiviaApp({this.router, super.key});

  /// Routeur à utiliser ; si `null`, le routeur de production est créé.
  final GoRouter? router;

  @override
  State<RechiviaApp> createState() => _RechiviaAppState();
}

class _RechiviaAppState extends State<RechiviaApp> {
  late final GoRouter _router = widget.router ?? createAppRouter();

  @override
  void dispose() {
    if (widget.router == null) {
      _router.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rechivia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
