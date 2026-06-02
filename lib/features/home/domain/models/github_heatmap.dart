class ContributionDay {
  final String date;
  final int count;
  final String level;
  final String color;

  ContributionDay({
    required this.date,
    required this.count,
    required this.level,
    required this.color,
  });

  factory ContributionDay.fromJson(Map<String, dynamic> json) {
    return ContributionDay(
      date: json['date'] as String? ?? '',
      count: json['contributionCount'] as int? ?? 0,
      level: json['contributionLevel'] as String? ?? 'NONE',
      color: json['color'] as String? ?? '#ebedf0',
    );
  }
}

class GitHubHeatmap {
  final List<List<ContributionDay>> weeks;
  final int totalContributions;

  GitHubHeatmap({
    required this.weeks,
    required this.totalContributions,
  });

  factory GitHubHeatmap.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawWeeks = json['contributions'] ?? [];
    
    final List<List<ContributionDay>> parsedWeeks = rawWeeks.map((week) {
      final List<dynamic> days = week as List<dynamic>;
      return days.map((day) => ContributionDay.fromJson(day as Map<String, dynamic>)).toList();
    }).toList();

    return GitHubHeatmap(
      weeks: parsedWeeks,
      totalContributions: json['totalContributions'] as int? ?? 0,
    );
  }
}
