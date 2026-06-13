import '../models/project.dart';
import '../models/skill.dart';
import '../models/experience.dart';
import '../models/article.dart';

class PortfolioData {
  PortfolioData._();

  // ── PROJECTS ─────────────────────────────────────────────────────────────

  static const List<Project> projects = [
    Project(
      id: 'codesphere',
      title: 'CodeSphere',
      subtitle: 'Multi-platform coding analytics aggregator',
      description:
          'Aggregates competitive programming stats from LeetCode, CodeChef, Codeforces, GeeksforGeeks, and HackerRank into one unified dashboard. Features an AI-powered Insight Coach (Gemini API), OTA update system via GitHub Releases, and a Vercel-hosted Node.js proxy to handle LeetCode CORS restrictions.',
      problem:
          'Developers waste time switching between 5+ platforms to track their coding progress.',
      approach:
          'Built with Clean Architecture + Riverpod. Gemini REST API for AI insights. flutter_local_notifications + WorkManager for background jobs. Glassmorphism UI with JetBrains Mono typography.',
      technologies: [
        'Flutter',
        'Dart',
        'Riverpod',
        'Gemini API',
        'Firebase',
        'Node.js',
        'Vercel',
        'go_router',
        'GraphQL',
        'WorkManager',
      ],
      outcomes:
          'Single-app coding dashboard with AI coaching and live contest tracking.',
      category: 'Flutter',
      githubUrl:
          'https://github.com/sakshiv3107/CodeSphere-Coding-Analytics-App',
    ),
    Project(
      id: 'mediauth',
      title: 'MediAuth AI',
      subtitle: 'AI-powered healthcare prior authorization automation',
      description:
          'Healthcare application automating prior authorization workflows using Agentic AI. Reduces manual insurance approval delays for clinical staff. Built during the Veersa Hackathon focused on Agentic AI systems in healthcare.',
      problem:
          'Prior authorization is a manual, time-consuming bottleneck in healthcare workflows.',
      approach:
          'Flutter frontend with Firebase Auth + Riverpod. Gemini API drives the agentic decision logic. Clean Architecture separates domain, data, and UI layers.',
      technologies: [
        'Flutter',
        'Dart',
        'Firebase Auth',
        'Riverpod',
        'Gemini API',
        'Clean Architecture',
      ],
      outcomes:
          'Hackathon project demonstrating agentic AI in clinical workflow automation.',
      category: 'AI',
    ),
    Project(
      id: 'dark-commerce',
      title: 'Dark Commerce',
      subtitle: 'E-commerce app with Clean Architecture + Riverpod',
      description:
          'Production-grade Flutter e-commerce app with Firestore pagination, go_router navigation, a "Dark Commerce" design system, and full Clean Architecture with Riverpod state management. Demonstrates production-level architecture decisions.',
      problem:
          'Demo shopping apps rarely demonstrate production-level architectural decisions or patterns.',
      approach:
          'Repository pattern, UseCases, and DTO models. Firestore for paginated product listings. go_router for nested navigation. Riverpod AsyncNotifier for cart and auth state.',
      technologies: [
        'Flutter',
        'Dart',
        'Riverpod',
        'Firebase Firestore',
        'go_router',
        'Clean Architecture',
      ],
      outcomes:
          'Resume-ready portfolio app demonstrating production architecture patterns.',
      category: 'Flutter',
    ),
    Project(
      id: 'finance-tracker',
      title: 'Finance Tracker',
      subtitle: 'Personal finance management application',
      description:
          'A comprehensive finance tracker app built with Flutter and Dart. Features expense tracking, budgeting, and financial insights with an intuitive user interface.',
      problem:
          'Managing personal finances across multiple accounts is complicated and lacks unified insights.',
      approach:
          'Built using Flutter and Dart with a focus on a clean, responsive UI and robust state management for real-time financial tracking.',
      technologies: [
        'Flutter',
        'Dart',
        'State Management',
      ],
      outcomes:
          'Provides users with clear financial insights and a seamless tracking experience.',
      category: 'Flutter',
    ),
  ];

  // ── SKILLS ───────────────────────────────────────────────────────────────

  static const List<Skill> skills = [
    // Mobile Development
    Skill(name: 'Flutter', category: 'Mobile Development', iconSlug: 'flutter', iconColor: '00E5FF'),
    Skill(name: 'Dart', category: 'Mobile Development', iconSlug: 'dart', iconColor: '00E5FF'),
    Skill(name: 'Android', category: 'Mobile Development', iconSlug: 'android', iconColor: '3DDC84'),
    Skill(name: 'iOS', category: 'Mobile Development', iconSlug: 'apple', iconColor: 'F1F5F9'),
    Skill(name: 'Flutter Web', category: 'Mobile Development', iconSlug: 'flutter', iconColor: '54C5F8'),

    // State Management
    Skill(name: 'Riverpod', category: 'State Management', iconSlug: 'dart', iconColor: '00B4D8'),
    Skill(name: 'Provider', category: 'State Management', iconSlug: 'flutter', iconColor: '7C3AED'),
    Skill(name: 'Bloc / Cubit', category: 'State Management', iconSlug: 'dart', iconColor: '9B59B6'),

    // Backend & APIs
    Skill(name: 'Firebase', category: 'Backend & APIs', iconSlug: 'firebase', iconColor: 'FFCA28'),
    Skill(name: 'Supabase', category: 'Backend & APIs', iconSlug: 'supabase', iconColor: '3ECF8E'),
    Skill(name: 'REST API', category: 'Backend & APIs', iconSlug: 'postman', iconColor: 'FF6C37'),
    Skill(name: 'GraphQL', category: 'Backend & APIs', iconSlug: 'graphql', iconColor: 'E10098'),
    Skill(name: 'Node.js', category: 'Backend & APIs', iconSlug: 'nodedotjs', iconColor: '339933'),

    // AI & Integrations
    Skill(name: 'Gemini API', category: 'AI & Integrations', iconSlug: 'google', iconColor: '4285F4'),
    Skill(name: 'Vertex AI', category: 'AI & Integrations', iconSlug: 'googlecloud', iconColor: '4285F4'),
    Skill(name: 'RAG', category: 'AI & Integrations', iconSlug: 'openai', iconColor: 'F1F5F9'),

    // Architecture & Tooling
    Skill(name: 'Clean Architecture', category: 'Architecture & Tooling', iconSlug: 'dart', iconColor: '00E5FF'),
    Skill(name: 'MVVM', category: 'Architecture & Tooling', iconSlug: 'flutter', iconColor: '54C5F8'),
    Skill(name: 'Git', category: 'Architecture & Tooling', iconSlug: 'git', iconColor: 'F05032'),
    Skill(name: 'GitHub Actions', category: 'Architecture & Tooling', iconSlug: 'githubactions', iconColor: '2088FF'),
    Skill(name: 'Vercel', category: 'Architecture & Tooling', iconSlug: 'vercel', iconColor: 'F1F5F9'),
    Skill(name: 'go_router', category: 'Architecture & Tooling', iconSlug: 'dart', iconColor: '00B4D8'),

    // Design & Other
    Skill(name: 'Figma', category: 'Design & Other', iconSlug: 'figma', iconColor: 'F24E1E'),
    Skill(name: 'Material 3', category: 'Design & Other', iconSlug: 'materialdesign', iconColor: '757575'),
    Skill(name: 'Responsive UI', category: 'Design & Other', iconSlug: 'flutter', iconColor: '00E5FF'),
    Skill(name: 'Accessibility', category: 'Design & Other', iconSlug: 'googlechrome', iconColor: '4285F4'),
  ];

  static List<String> get skillCategories => skills
      .map((s) => s.category)
      .toSet()
      .toList();

  static List<Skill> skillsByCategory(String category) =>
      skills.where((s) => s.category == category).toList();

  // ── EXPERIENCE ───────────────────────────────────────────────────────────

  static const List<ExperienceItem> experiences = [
    ExperienceItem(
      role: 'Social Media Head',
      company: 'GDG ABESEC (Google Developer Groups)',
      companyUrl: 'https://gdg.community.dev/',
      dateRange: 'Nov 2024 – Present',
      isCurrent: true,
      description:
          'Lead social strategy and technical content for the Google Developer Group chapter — growing reach, designing campaigns, and coordinating event communications.',
      bullets: [
        'Manage social media presence and technical content for the chapter',
        'Design promotional graphics and event campaigns in Figma',
        'Coordinate with speakers and organizers for tech events',
      ],
    ),
    ExperienceItem(
      role: 'Graphics Lead',
      company: 'CodeChef ABESEC Chapter',
      companyUrl: 'https://www.codechef.com/',
      dateRange: 'Oct 2024 – Present',
      isCurrent: true,
      description:
          'Own visual identity and creative assets for competitive programming events, workshops, and recruitment drives across the chapter.',
      bullets: [
        'Create visual assets for contests, workshops, and recruitment drives',
        'Collaborate with technical team to align design with event branding',
        'Maintain consistent brand identity across all chapter communications',
      ],
    ),
    ExperienceItem(
      role: 'B.Tech Information Technology',
      company: 'ABES Engineering College, Ghaziabad',
      companyUrl: 'https://abes.ac.in/',
      dateRange: '2023 – July 2027',
      isCurrent: true,
      description:
          'Pursuing a B.Tech in IT with strong academic performance and active involvement in developer communities, DSA, and mobile development.',
      bullets: [
        'CGPA: 9.0 — consistently in top academic standing',
        'Active in competitive programming — LeetCode 400+ problems, rating ~1550+',
        'Core member of multiple developer and design clubs',
      ],
    ),
  ];

  // ── ARTICLES ─────────────────────────────────────────────────────────────

  static const List<Article> articles = [
    Article(
      title: 'Clean Architecture in Flutter: A Practical Guide',
      excerpt:
          'How I structure large-scale Flutter apps using Clean Architecture, Riverpod, and go_router — with real code examples from CodeSphere.',
      datePublished: 'Coming Soon',
      isPlaceholder: true,
    ),
    Article(
      title: 'Integrating Gemini API in Flutter Without the SDK',
      excerpt:
          'A deep dive into using the Gemini REST API directly in Flutter for AI-powered features — no Dart SDK required.',
      datePublished: 'Coming Soon',
      isPlaceholder: true,
    ),
  ];

  // ── ACHIEVEMENTS ──────────────────────────────────────────────────────────

  static const List<Map<String, String>> achievements = [
    {
      'icon': '🏆',
      'title': '400+ LeetCode Problems',
      'detail': 'Rating ~1550+ | Consistent problem solver in DSA',
    },
    {
      'icon': '🚀',
      'title': 'Veersa Hackathon',
      'detail': 'Built MediAuth AI — Agentic AI for healthcare workflows',
    },
    {
      'icon': '👥',
      'title': 'GDG ABESEC Social Media Head',
      'detail': 'Managing community growth and technical content strategy',
    },
    {
      'icon': '🎨',
      'title': 'CodeChef ABESEC Graphics Lead',
      'detail': 'Designing branding assets for 1000+ member chapter',
    },
    {
      'icon': '💰',
      'title': 'Finance Tracker',
      'detail': 'Built a personal finance app with Flutter and Dart',
    },
  ];

  // ── GITHUB STATS ─────────────────────────────────────────────────────────

  static const String githubUsername = 'sakshiv3107';

  static const Map<String, dynamic> githubStats = {
    'Total Commits (2025)': {'value': '800+', 'percent': 0.85},
    'Pull Requests': {'value': '50+', 'percent': 0.65},
    'Repositories Contributed': {'value': '18', 'percent': 0.50},
  };

  static const Map<String, dynamic> topLanguages = {
    'Dart & Flutter': {'value': '74.2%', 'percent': 0.74, 'color': '0xFF00E5FF'},
    'C++': {'value': '18.5%', 'percent': 0.18, 'color': '0xFF8B5CF6'},
    'Python': {'value': '7.3%', 'percent': 0.07, 'color': '0xFFFF9800'},
  };
}
