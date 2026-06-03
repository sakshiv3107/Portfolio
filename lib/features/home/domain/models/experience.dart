class ExperienceItem {
  final String role;
  final String company;
  final String? companyUrl;
  final String? linkedInUrl;
  final String dateRange;
  final bool isCurrent;
  final String description;
  final List<String> bullets;

  const ExperienceItem({
    required this.role,
    required this.company,
    this.companyUrl,
    this.linkedInUrl,
    required this.dateRange,
    this.isCurrent = false,
    required this.description,
    required this.bullets,
  });
}
