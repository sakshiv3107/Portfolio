/// Bundled asset paths for images, resume, etc.
class AppAssets {
  AppAssets._();

  static const String avatar = 'assets/images/avatar.png';

  /// Served from [web/images/avatar.png] when running on Flutter Web.
  static const String avatarWebPath = 'images/avatar.png';

  static const String resume = 'assets/resume/Sakshi_Vishnoi_Resume_Flutter.pdf';
  static const String resumeFileName = 'Sakshi_Vishnoi_Resume_Flutter.pdf';

  /// Web-served resume URL (file also lives under [web/resume/]).
  static const String resumeWebPath = 'resume/Sakshi_Vishnoi_Resume_Flutter.pdf';
}
