import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';

/// Champ de saisie standard : icône à gauche, texte d'aide, validation.
///
/// L'apparence (fond blanc, coins arrondis, bordures) vient du thème global
/// (`AppTheme`). Ce widget ajoute le comportement propre aux formulaires :
/// - [isPassword] masque le texte et affiche l'œil pour le révéler ;
/// - [validator] affiche un message d'erreur sous le champ.
///
/// À utiliser à l'intérieur d'un `Form` pour que la validation fonctionne.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    super.key,
  });

  /// Texte d'aide affiché quand le champ est vide (ex. "Adresse e-mail").
  final String hintText;

  /// Icône affichée à gauche du champ.
  final IconData prefixIcon;

  /// Contrôleur pour lire la valeur saisie (optionnel).
  final TextEditingController? controller;

  /// Masque la saisie (mot de passe) et ajoute le bouton "œil".
  final bool isPassword;

  /// Type de clavier (ex. `TextInputType.emailAddress`).
  final TextInputType? keyboardType;

  /// Action du bouton "entrée" du clavier (ex. `TextInputAction.next`).
  final TextInputAction? textInputAction;

  /// Retourne un message d'erreur, ou `null` si la valeur est valide.
  final String? Function(String?)? validator;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// Vrai tant que le mot de passe est caché.
  late bool _isObscured = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.prefixIcon, color: AppColors.violet),
        suffixIcon: widget.isPassword ? _buildVisibilityToggle() : null,
      ),
    );
  }

  /// Bouton "œil" qui montre ou cache le mot de passe.
  Widget _buildVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: AppColors.textSecondary,
      ),
      onPressed: () => setState(() => _isObscured = !_isObscured),
    );
  }
}
