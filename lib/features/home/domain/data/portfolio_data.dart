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
      id: 'decoding-visuals',
      title: 'Decoding Visuals',
      subtitle: 'Hackathon: AI-powered visual interpretation system',
      description:
          'Uses Generative AI to interpret and describe complex visual content, making data visualizations and infographics accessible to non-visual users. Addresses a real accessibility gap in how charts and graphs are consumed.',
      problem:
          'Charts and infographics are largely inaccessible to visually impaired users.',
      approach:
          'Multimodal generative AI model processes images and returns rich natural language descriptions. Presented at college-level hackathon.',
      technologies: [
        'Generative AI',
        'Multimodal LLM',
        'Python',
        'Flutter',
      ],
      outcomes:
          'First hackathon project integrating GenAI for an accessibility use case.',
      category: 'AI',
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

  static const List<Experience> experiences = [
    Experience(
      role: 'Social Media Head',
      organization: 'GDG ABESEC (Google Developer Groups)',
      period: 'Nov 2024 – Present',
      bullets: [
        'Manage social media presence and technical content for the chapter',
        'Design promotional graphics and event campaigns in Figma',
        'Coordinate with speakers and organizers for tech events',
      ],
      technologies: ['Figma', 'Canva', 'Content Strategy'],
      isCurrent: true,
    ),
    Experience(
      role: 'Graphics Lead',
      organization: 'CodeChef ABESEC Chapter',
      period: 'Oct 2024 – Present',
      bullets: [
        'Create visual assets for contests, workshops, and recruitment drives',
        'Collaborate with technical team to align design with event branding',
        'Maintain consistent brand identity across all chapter communications',
      ],
      technologies: ['Figma', 'Adobe', 'Graphic Design'],
      isCurrent: true,
    ),
    Experience(
      role: 'B.Tech Information Technology',
      organization: 'ABES Engineering College, Ghaziabad',
      period: '2023 – July 2027',
      bullets: [
        'CGPA: 9.0 — consistently in top academic standing',
        'Active in competitive programming — LeetCode 400+ problems, rating ~1550+',
        'Core member of multiple developer and design clubs',
      ],
      technologies: ['C++', 'DSA', 'Flutter', 'Dart', 'Networking'],
      isCurrent: true,
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
      'icon': '🤖',
      'title': 'GenAI Accessibility Hackathon',
      'detail': 'Decoding Visuals — AI for visually impaired users',
    },
  ];
}
