# Sakshi Vishnoi — Flutter Portfolio

A production-ready personal developer portfolio built with **Flutter Web**, featuring:
- 🎨 Dark Precision theme (deep navy + electric cyan)
- 📱 Fully responsive (mobile / tablet / desktop)
- ⚡ Smooth scroll navigation with staggered animations
- 🤖 AI-powered project showcase (Gemini API integration)
- 📊 Live GitHub stats + contribution graph
- 📬 Contact form with mailto fallback

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter Web |
| Navigation | go_router |
| State | flutter_riverpod |
| Fonts | JetBrains Mono + IBM Plex Sans |
| Icons | font_awesome_flutter + SimpleIcons CDN |
| Images | cached_network_image |
| Links | url_launcher |

---

## Project Structure

```
lib/
├── main.dart
├── app.dart                          # MaterialApp.router + theme
├── core/
│   ├── constants/
│   │   ├── app_colors.dart           # Dark Precision palette
│   │   ├── app_typography.dart       # JetBrains Mono + IBM Plex Sans
│   │   └── app_spacing.dart          # Spacing tokens
│   ├── router/app_router.dart        # go_router config
│   ├── theme/app_theme.dart          # Global ThemeData
│   └── utils/responsive.dart        # Breakpoint helpers
├── features/home/
│   ├── domain/
│   │   ├── models/                   # Project, Skill, Experience, Article
│   │   └── data/portfolio_data.dart  # All hardcoded content
│   └── presentation/
│       ├── home_page.dart            # Main scroll layout
│       └── widgets/
│           ├── hero_section.dart
│           ├── about_section.dart
│           ├── skills_section.dart
│           ├── experience_section.dart
│           ├── projects_section.dart
│           ├── github_section.dart
│           ├── achievements_section.dart
│           ├── blog_section.dart
│           └── contact_section.dart
└── shared/widgets/
    ├── nav_bar.dart
    ├── footer.dart
    ├── section_header.dart
    ├── tech_badge.dart
    ├── project_card.dart
    └── experience_card.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.19.0
- Chrome browser

### Install dependencies
```bash
flutter pub get
```

### Run in development (Chrome — fast hot reload)
```bash
flutter run -d chrome --web-renderer html
```

### Production build (CanvasKit renderer)
```bash
flutter build web --web-renderer canvaskit --release
```

### Serve locally to test production build
```bash
cd build/web && python -m http.server 8080
# Open: http://localhost:8080
```

### Deploy to Firebase Hosting
```bash
firebase login
firebase init hosting    # set public dir to: build/web
flutter build web --web-renderer canvaskit --release
firebase deploy --only hosting
```

### Deploy to GitHub Pages
```bash
flutter build web --web-renderer canvaskit --base-href "/your-repo-name/"
# Then push build/web contents to gh-pages branch
```

---

## Customization

See [CONTENT_GUIDE.md](CONTENT_GUIDE.md) for a complete list of all
`[CUSTOMIZE]` tags and how to update them.

---

## License

MIT — feel free to fork and adapt for your own portfolio.
