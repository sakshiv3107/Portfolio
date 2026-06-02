import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/github_repository.dart';
import '../../domain/models/github_heatmap.dart';
import '../../domain/models/github_stats.dart';

final githubRepositoryProvider = Provider((ref) => GitHubRepository());

final githubHeatmapProvider = FutureProvider.family<GitHubHeatmap, String>((ref, username) async {
  final repository = ref.watch(githubRepositoryProvider);
  return repository.fetchHeatmap(username);
});

final githubRepoStatsProvider = FutureProvider.family<GitHubRepoStats, String>((ref, username) async {
  final repository = ref.watch(githubRepositoryProvider);
  return repository.fetchRepoStats(username);
});
