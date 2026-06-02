import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/github_heatmap.dart';
import '../../domain/models/github_stats.dart';

class GitHubRepository {
  /// Fetches the contribution heatmap for a given GitHub username
  /// Uses a public Deno proxy to avoid CORS and authentication issues on Flutter Web.
  Future<GitHubHeatmap> fetchHeatmap(String username) async {
    try {
      final url = Uri.parse('https://github-contributions-api.deno.dev/$username.json');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GitHubHeatmap.fromJson(data);
      } else {
        throw Exception('Failed to load GitHub data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching GitHub data: $e');
    }
  }

  /// Fetches repository stats (repos count, languages) for a given GitHub username
  Future<GitHubRepoStats> fetchRepoStats(String username) async {
    try {
      final url = Uri.parse('https://api.github.com/users/$username/repos?per_page=100');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return GitHubRepoStats.fromJson(data);
      } else {
        throw Exception('Failed to load GitHub repos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching GitHub repos: $e');
    }
  }
}
