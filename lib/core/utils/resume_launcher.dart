import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_assets.dart';

/// Opens the Flutter resume PDF in a new browser tab (web) or external viewer.
Future<void> launchResume() async {
  final uri = kIsWeb
      ? Uri.base.resolve(AppAssets.resumeWebPath)
      : Uri.parse('asset:///${AppAssets.resume}');

  final launched = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );

  if (!launched && kIsWeb) {
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }
}
