import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/presentation/providers/app_preferences_provider.dart';

class ConfirmationUtils {
  ConfirmationUtils._();

  static Future<bool> showDeleteConfirmation({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String message,
    String confirmText = 'Eliminar',
    String cancelText = 'Cancelar',
    IconData icon = Icons.delete_outline,
    bool isDangerous = true,
    VoidCallback? onConfirm,
  }) async {
    final prefsAsync = ref.read(appPreferencesProvider);

    bool confirmBeforeDelete = true;
    prefsAsync.whenData((prefs) {
      confirmBeforeDelete = prefs.confirmBeforeDelete;
    });

    if (!confirmBeforeDelete) {
      onConfirm?.call();
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Icon(
            icon,
            color: isDangerous
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelText),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isDangerous
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
                onConfirm?.call();
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static Future<bool> confirmDeletePortfolio({
    required BuildContext context,
    required WidgetRef ref,
    required String portfolioName,
    VoidCallback? onConfirm,
  }) {
    return showDeleteConfirmation(
      context: context,
      ref: ref,
      title: '¿Eliminar portfolio?',
      message:
          '¿Estás seguro de que quieres eliminar "$portfolioName"? Esta acción no se puede deshacer.',
      onConfirm: onConfirm,
    );
  }

  static Future<bool> confirmDeleteTransaction({
    required BuildContext context,
    required WidgetRef ref,
    VoidCallback? onConfirm,
  }) {
    return showDeleteConfirmation(
      context: context,
      ref: ref,
      title: '¿Eliminar transacción?',
      message:
          '¿Estás seguro de que quieres eliminar esta transacción? Esta acción no se puede deshacer.',
      onConfirm: onConfirm,
    );
  }

  static Future<bool> confirmDeleteAsset({
    required BuildContext context,
    required WidgetRef ref,
    required String assetSymbol,
    VoidCallback? onConfirm,
  }) {
    return showDeleteConfirmation(
      context: context,
      ref: ref,
      title: '¿Eliminar asset?',
      message:
          '¿Estás seguro de que quieres eliminar todas las posiciones de $assetSymbol? Esta acción no se puede deshacer.',
      onConfirm: onConfirm,
    );
  }

  static Future<bool> confirmAction({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    IconData icon = Icons.help_outline,
    VoidCallback? onConfirm,
  }) {
    return showDeleteConfirmation(
      context: context,
      ref: ref,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      isDangerous: false,
      onConfirm: onConfirm,
    );
  }
}
