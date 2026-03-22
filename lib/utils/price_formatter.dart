import 'package:intl/intl.dart';

class PriceFormatter {
  static String format(double price) {
    final formatter = NumberFormat.currency(
      locale: 'en_NP',
      symbol: 'Rs. ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }
}
