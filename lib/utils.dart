import 'package:flutter/material.dart' show ImageProvider;
import 'package:palette_generator/palette_generator.dart';

class Utils {
  static Future<List<PaletteColor>> getImagePalette(
    ImageProvider imageProvider,
  ) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.paletteColors;
  }
}
