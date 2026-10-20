import 'package:intl/intl.dart';
import 'package:appcart/core/constants/app_constants.dart';

/// Formatter for Indian Rupee currency and numeric values
class CurrencyFormatter {
  static final NumberFormat _formatterDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 2,
  );

  static final NumberFormat _formatterWhole = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 0,
  );

  /// Formats a double value as an Indian Rupee string (e.g. ₹2,499 or ₹79.50)
  static String format(double amount) {
    if (amount % 1 == 0) {
      return _formatterWhole.format(amount);
    }
    return _formatterDecimals.format(amount);
  }
}

