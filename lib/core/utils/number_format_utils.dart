import 'package:intl/intl.dart';

class NumberFormatUtils {
  NumberFormatUtils._();

  static String formatNumber(
    double value, {
    String format = 'comma',
    int decimals = 2,
  }) {
    if (format == 'comma') {
      final formatter = NumberFormat('#,##0.${'0' * decimals}', 'es_ES');
      return formatter.format(value);
    } else {
      final formatter = NumberFormat('#,##0.${'0' * decimals}', 'en_US');
      return formatter.format(value);
    }
  }

  static String formatCurrency(
    double value, {
    required String currency,
    String format = 'comma',
    bool showSymbol = true,
  }) {
    final formattedNumber = formatNumber(value, format: format, decimals: 2);

    if (!showSymbol) {
      return formattedNumber;
    }

    final symbol = getCurrencySymbol(currency);

    if (currency == 'EUR') {
      return '$formattedNumber $symbol';
    } else {
      return '$symbol$formattedNumber';
    }
  }

  static String formatPercentage(
    double value, {
    String format = 'comma',
    int decimals = 2,
    bool showSign = false,
  }) {
    final formattedNumber = formatNumber(
      value,
      format: format,
      decimals: decimals,
    );
    final sign = showSign && value > 0 ? '+' : '';
    return '$sign$formattedNumber%';
  }

  static String formatCompact(double value, {String format = 'comma'}) {
    if (value.abs() >= 1000000000) {
      return '${formatNumber(value / 1000000000, format: format, decimals: 1)}B';
    } else if (value.abs() >= 1000000) {
      return '${formatNumber(value / 1000000, format: format, decimals: 1)}M';
    } else if (value.abs() >= 1000) {
      return '${formatNumber(value / 1000, format: format, decimals: 1)}K';
    } else {
      return formatNumber(value, format: format, decimals: 0);
    }
  }

  static String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CHF':
        return 'CHF';
      case 'CAD':
        return 'CA\$';
      case 'AUD':
        return 'A\$';
      case 'CNY':
        return '¥';
      case 'MXN':
        return 'MX\$';
      case 'BRL':
        return 'R\$';
      default:
        return currency;
    }
  }

  static String getCurrencyName(String currency) {
    switch (currency) {
      case 'EUR':
        return 'Euro';
      case 'USD':
        return 'Dólar Estadounidense';
      case 'GBP':
        return 'Libra Esterlina';
      case 'JPY':
        return 'Yen Japonés';
      case 'CHF':
        return 'Franco Suizo';
      case 'CAD':
        return 'Dólar Canadiense';
      case 'AUD':
        return 'Dólar Australiano';
      case 'CNY':
        return 'Yuan Chino';
      case 'MXN':
        return 'Peso Mexicano';
      case 'BRL':
        return 'Real Brasileño';
      default:
        return currency;
    }
  }
}
