class ProjectData {
  final String number;
  final String title;
  final String subtitle;
  final String description;
  final String badgeType;
  final String? githubUrl;
  final String status;
  final List<String> tags;
  final bool isLive;

  const ProjectData({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badgeType,
    this.githubUrl,
    required this.status,
    required this.tags,
    required this.isLive,
  });
}

final codeSphere = ProjectData(
  number: '01',
  title: 'CodeSphere',
  subtitle: 'Multi-platform coding analytics aggregator',
  description: 'Aggregates competitive programming stats from LeetCode, CodeChef, Codeforces, GFG, HackerRank. Features Gemini AI Insight Coach, OTA update system, and dark precision UI with sparklines and activity heatmaps.',
  badgeType: 'Flutter',
  githubUrl: 'https://github.com',
  status: 'Live',
  tags: ['Dart', 'Riverpod', 'Gemini API', 'Firebase'],
  isLive: true,
);

final mediAuth = ProjectData(
  number: '02',
  title: 'MediAuth AI',
  subtitle: 'AI-powered healthcare prior authorization',
  description: 'Autonomous insurance authorization agent with multi-level appeal loop. Built with LangGraph + Claude Sonnet + FastAPI + ChromaDB + PostgreSQL backend.',
  badgeType: 'AI',
  status: 'In Development',
  tags: ['FastAPI', 'LangGraph', 'ChromaDB', 'Flutter'],
  isLive: false,
);

final darkCommerce = ProjectData(
  number: '03',
  title: 'Dark Commerce',
  subtitle: 'E-commerce app with Clean Architecture + Riverpod',
  description: 'Production-grade Flutter e-commerce with Firestore pagination, go_router, Clean Architecture, and full dark design system.',
  badgeType: 'Flutter',
  status: 'In Development',
  tags: ['Dart', 'Riverpod', 'Firestore', 'go_router'],
  isLive: false,
);

final financeTracker = ProjectData(
  number: '04',
  title: 'Finance Tracker',
  subtitle: 'Personal finance management app',
  description: 'A comprehensive finance tracker app built with Flutter and Dart. Features expense tracking, budgeting, and financial insights with an intuitive user interface.',
  badgeType: 'Flutter',
  status: 'Completed',
  tags: ['Flutter', 'Dart', 'State Management'],
  isLive: true,
);
