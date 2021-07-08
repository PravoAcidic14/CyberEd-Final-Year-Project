import 'package:flutter/cupertino.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorPalleteGenerator {
  Future<PaletteGenerator> getPallete(moduleThumbnailUrl) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(moduleThumbnailUrl),
      size: Size(300, 300),
      region: Rect.fromLTWH(0, 0, 50.0, 50.0),
    );

    return generator;
  }

  Future<PaletteColor> getPalleteDominantColor(moduleThumbnailUrl) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(moduleThumbnailUrl),
      size: Size(300, 300),
      region: Rect.fromLTWH(0, 0, 50.0, 50.0),
    );
    return generator.dominantColor;
  }
}
