import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/number_format_utils.dart';
import '../../features/settings/presentation/providers/app_preferences_provider.dart';

final formatProvider = Provider<FormatHelper>((ref) {
  final prefsAsync = ref.watch(appPreferencesProvider);

  return prefsAsync.when(
    data: (prefs) => FormatHelper(
      numberFormat: prefs.numberFormat,
      defaultCurrency: prefs.defaultCurrency,
    ),
    loading: () => const FormatHelper(), 
    error: (_, __) => const FormatHelper(),
  );
});

class FormatHelper {
  final String numberFormat;
  final String defaultCurrency;

  const FormatHelper({
    this.numberFormat = 'comma',
    this.defaultCurrency = 'EUR',
  });

   String number(double value, {int decimals = 2}) {
    return NumberFormatUtils.formatNumber(
      value,
      format: numberFormat,
      decimals: decimals,
    );
  }

   String currency(double value, {bool showSymbol = true}) {
    return NumberFormatUtils.formatCurrency(
      value,
      currency: defaultCurrency,
      format: numberFormat,
      showSymbol: showSymbol,
    );
  }

   String currencyWithCode(
    double value,
    String currency, {
    bool showSymbol = true,
  }) {
    return NumberFormatUtils.formatCurrency(
      value,
      currency: currency,
      format: numberFormat,
      showSymbol: showSymbol,
    );
  }

   String percentage(double value, {int decimals = 2, bool showSign = false}) {
    return NumberFormatUtils.formatPercentage(
      value,
      format: numberFormat,
      decimals: decimals,
      showSign: showSign,
    );
  }

   String compact(double value) {
    return NumberFormatUtils.formatCompact(value, format: numberFormat);
  }

   String get currencySymbol {
    return NumberFormatUtils.getCurrencySymbol(defaultCurrency);
  }
}

 extension FormatExtension on WidgetRef {
  FormatHelper get format => read(formatProvider);
}
