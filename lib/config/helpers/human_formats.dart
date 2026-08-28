// config/helpers/human_formats.dart
import 'package:intl/intl.dart';

class HumanFormats {
  // Convierte numeros grandes en una forma legible: 150000 -> "150k",
  // 4500564 -> "4.5M". Sin esto, los contadores de videos populares de
  // Pixabay (algunos con mas de 800K vistas) se verian como una fila
  // interminable de digitos.
  static String formatearNumeroLegible(double number) {
    return NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
    ).format(number);
  }
}
