import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../di/injection.dart';

/// [AppInitializer] is responsible for all low-level system configurations
/// that need to be set before the app starts.
class AppInitializer {
  AppInitializer._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    // Force google_fonts to use the bundled Poppins assets only — never fetch
    // over the network at runtime. Fonts must ship in assets/google_fonts/.
    GoogleFonts.config.allowRuntimeFetching = false;

    // Initialize Dependency Injection
    await initInjection();

    _configureImageCache();
  }

  /// Configures the Flutter Image Cache to prevent frequent redecoding.
  ///
  /// RATIONALE:
  /// Flutter's default image cache is 1000 entries / 100 MB. 
  /// For AutoWay app, which features multiple car listings, carousels, 
  /// and high-res driver/client profiles, memory-pressure evictions 
  /// can force the same images to redecode frequently. 
  /// We bump the cap to 2000 entries and 250 MB to ensure a smooth 
  /// round-trip between screens and reduce CPU/GPU overhead.
  static void _configureImageCache() {
    PaintingBinding.instance.imageCache.maximumSize = 2000;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 250 * 1024 * 1024;
  }
}
