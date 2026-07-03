import "package:intl/intl.dart";

final _currency = NumberFormat.currency(locale: "en_US", symbol: "\$");
final _dateFmt = DateFormat("dd/MM/yyyy HH:mm");

String formatCurrency(num value) => _currency.format(value);
String formatDate(DateTime dt) => _dateFmt.format(dt);
