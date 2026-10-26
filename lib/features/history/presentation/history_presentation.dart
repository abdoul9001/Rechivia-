import 'package:flutter/material.dart';

import 'package:rechivia/core/theme/app_colors.dart';
import 'package:rechivia/features/history/domain/history_entry.dart';

extension HistoryKindPresentation on HistoryKind {
  String get label => switch (this) {
    HistoryKind.dailyQuestion => 'Question du jour',
    HistoryKind.guidedConversation => 'Conversation guidée',
  };

  IconData get icon => switch (this) {
    HistoryKind.dailyQuestion => Icons.favorite,
    HistoryKind.guidedConversation => Icons.chat_bubble_outline,
  };

  Color get color => switch (this) {
    HistoryKind.dailyQuestion => AppColors.pink,
    HistoryKind.guidedConversation => AppColors.violet,
  };
}

extension HistoryStatusPresentation on HistoryStatus {
  String get label => switch (this) {
    HistoryStatus.revealed => 'Répondu',
    HistoryStatus.waitingForPartner => 'En attente',
    HistoryStatus.passed => 'Passée',
    HistoryStatus.expired => 'Expirée',
  };

  Color get color => switch (this) {
    HistoryStatus.revealed => AppColors.categoryGreen,
    HistoryStatus.waitingForPartner => AppColors.violet,
    HistoryStatus.passed || HistoryStatus.expired => AppColors.textSecondary,
  };
}
