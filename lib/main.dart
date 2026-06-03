import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Avoid hanging the first web frame on Google Fonts CDN fetches.
  if (kIsWeb) {
    GoogleFonts.config.allowRuntimeFetching = false;
  }

  runApp(
    const ProviderScope(
      child: PortfolioApp(),
    ),
  );
}
