class GitHubRepoStats {
  final int totalRepos;
  final Map<String, dynamic> topLanguages;

  GitHubRepoStats({
    required this.totalRepos,
    required this.topLanguages,
  });

  factory GitHubRepoStats.fromJson(List<dynamic> json) {
    int totalRepos = json.length;
    Map<String, int> langCounts = {};
    int totalLangsWithLanguage = 0;

    for (var repo in json) {
      if (repo['language'] != null) {
        String lang = repo['language'];
        langCounts[lang] = (langCounts[lang] ?? 0) + 1;
        totalLangsWithLanguage++;
      }
    }

    // Sort by count descending
    var sortedEntries = langCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Get top 3
    var top3 = sortedEntries.take(3).toList();
    
    Map<String, dynamic> topLanguages = {};
    
    // Default colors for common languages
    final langColors = {
      'HTML': '0xFFE34F26',
      'Dart': '0xFF00E5FF', // Cyan from theme
      'Python': '0xFFFF9800', // Orange
      'JavaScript': '0xFFF7DF1E', // Yellow
      'C++': '0xFF8B5CF6', // Purple
    };

    for (var entry in top3) {
      double percent = totalLangsWithLanguage > 0 ? entry.value / totalLangsWithLanguage : 0;
      topLanguages[entry.key] = {
        'value': '${(percent * 100).toStringAsFixed(1)}%',
        'percent': percent,
        'color': langColors[entry.key] ?? '0xFF888888',
      };
    }

    return GitHubRepoStats(
      totalRepos: totalRepos,
      topLanguages: topLanguages,
    );
  }
}
