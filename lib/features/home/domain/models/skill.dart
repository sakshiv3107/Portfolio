class Skill {
  final String name;
  final String category;
  final String? iconSlug; // SimpleIcons slug
  final String? iconColor; // hex without #

  const Skill({
    required this.name,
    required this.category,
    this.iconSlug,
    this.iconColor,
  });

  String? get iconUrl => iconSlug != null
      ? 'https://cdn.simpleicons.org/$iconSlug/${iconColor ?? '00E5FF'}'
      : null;
}
