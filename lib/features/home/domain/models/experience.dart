class Experience {
  final String role;
  final String organization;
  final String period;
  final List<String> bullets;
  final List<String> technologies;
  final bool isCurrent;

  const Experience({
    required this.role,
    required this.organization,
    required this.period,
    required this.bullets,
    required this.technologies,
    this.isCurrent = false,
  });
}
