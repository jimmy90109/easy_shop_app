//palette.dart
import 'package:flutter/material.dart';
class Palette {
  static const MaterialColor kToGrey = MaterialColor(
    0xffdedede, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffc8c8c8),//10%
      100: Color(0xffb2b2b2),//20%
      200: Color(0xff9b9b9b),//30%
      300: Color(0xff858585),//40%
      400: Color(0xff6f6f6f),//50%
      500: Color(0xff595959),//60%
      600: Color(0xff434343),//70%
      700: Color(0xff2c2c2c),//80%
      800: Color(0xff161616),//90%
      900: Color(0xff000000),//100%
    },
  );
}