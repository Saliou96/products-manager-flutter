import 'dart:ffi';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Utils {
  String generateUniqueId() {
    var uuid = Uuid();
    return uuid.v4(); // Génère un UUID version 4
  }

  String amountFormatter(double amount) {
    return NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'F CFA',
      decimalDigits: 0, // Supprime les décimales
    ).format(amount);
  }
}
