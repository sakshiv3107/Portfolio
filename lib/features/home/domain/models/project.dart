class Project {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String problem;
  final String approach;
  final List<String> technologies;
  final String outcomes;
  final String category; // 'Flutter' | 'AI' | 'Web'
  final String? githubUrl;
  final String? liveUrl;
  final String? thumbnailAsset;

  const Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.problem,
    required this.approach,
    required this.technologies,
    required this.outcomes,
    required this.category,
    this.githubUrl,
    this.liveUrl,
    this.thumbnailAsset,
  });
}
