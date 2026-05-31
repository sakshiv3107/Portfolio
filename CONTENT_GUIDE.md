# Content Customization Guide

This file lists every `[CUSTOMIZE]` item in the codebase and how to update it.

---

## 1. Avatar Photo

**File:** `lib/features/home/presentation/widgets/hero_section.dart`

Find the `_buildAvatar()` method. Currently shows initials "SV". To use a photo:

```dart
// Replace:
CircleAvatar(
  radius: 72,
  backgroundColor: AppColors.surface,
  child: Text('SV', ...),
)

// With:
CircleAvatar(
  radius: 72,
  backgroundImage: AssetImage('assets/images/avatar.jpg'),
)
```

Then place your photo at: `assets/images/avatar.jpg`

---

## 2. Email Address

Search for `sakshi.vishnoi3107@gmail.com` and replace with your email in:

- `lib/features/home/presentation/widgets/hero_section.dart`
- `lib/features/home/presentation/widgets/contact_section.dart`
- `lib/shared/widgets/footer.dart`

---

## 3. GitHub Username

Currently set to `sakshiv3107`. To change:

**File:** `lib/features/home/presentation/widgets/github_section.dart`
```dart
static const String _username = 'sakshiv3107'; // ← change here
```

This automatically updates the contribution graph and stats card URLs.

---

## 4. LinkedIn URL

Search for `https://www.linkedin.com/in/sakshi-vishnoi-7770b2315/` and replace in:

- `lib/features/home/presentation/widgets/about_section.dart`
- `lib/features/home/presentation/widgets/contact_section.dart`
- `lib/shared/widgets/footer.dart`

---

## 5. Resume PDF

**File:** `lib/features/home/presentation/widgets/hero_section.dart`

```dart
// In _downloadResume():
final uri = Uri.parse('assets/resume_sakshi_verma.pdf'); // ← update path
```

Place your resume at: `assets/resume_sakshi_verma.pdf`
Then add it to `pubspec.yaml` assets:
```yaml
flutter:
  assets:
    - assets/resume_sakshi_verma.pdf
```

**Nav bar resume button:**
`lib/shared/widgets/nav_bar.dart` — `_downloadResume()` method.

---

## 6. Project GitHub Links

**File:** `lib/features/home/domain/data/portfolio_data.dart`

For each project, update the `githubUrl` and `liveUrl` fields:
```dart
Project(
  ...
  githubUrl: 'https://github.com/YOUR_USERNAME/YOUR_REPO',
  liveUrl: 'https://your-app.vercel.app',
)
```

Currently only CodeSphere has a GitHub link. Update MediAuth AI, Dark Commerce, and Decoding Visuals.

---

## 7. Custom Domain

**File:** `web/index.html`
- Update `<link rel="canonical" href="https://sakshiverma.dev">`
- Update `og:url` meta tag
- Update JSON-LD `"url"` field

---

## 8. Experience Dates

**File:** `lib/features/home/domain/data/portfolio_data.dart`

Find the experience entries and update `period:` fields:
```dart
Experience(
  period: 'Nov 2024 – Present',  // ← update start dates
  ...
)
```

---

## 9. Blog Articles

**File:** `lib/features/home/domain/data/portfolio_data.dart`

Replace the placeholder articles with real ones:
```dart
Article(
  title: 'Your Real Article Title',
  excerpt: 'Your article excerpt...',
  datePublished: 'Jun 2025',
  url: 'https://medium.com/@you/your-article',
  readingTimeMinutes: '5',
  isPlaceholder: false,   // ← set to false
),
```

---

## 10. Availability Status

**File:** `lib/features/home/presentation/widgets/hero_section.dart`

Find the badge widget:
```dart
Text('Open to Internships', ...)  // ← update as needed
```

Also update the availability card in:
`lib/features/home/presentation/widgets/contact_section.dart`
```dart
Text('Summer / Fall 2025 · Flutter & Mobile', ...)
```

---

## 11. LeetCode Username

**File:** `lib/features/home/presentation/widgets/about_section.dart`  
and `lib/features/home/presentation/widgets/contact_section.dart`

Change `sakshiv31` to your LeetCode username in the profile URLs.

---

## 12. OG / Social Preview Image

Place a 1200×630 PNG at `web/og-image.png` for social media link previews.
Referenced in `web/index.html` Open Graph meta tags.

---

## Quick Checklist

- [ ] Add avatar photo → `assets/images/avatar.jpg`
- [ ] Add resume PDF → `assets/resume_sakshi_verma.pdf`
- [ ] Update email addresses (3 files)
- [ ] Update project GitHub/live URLs in `portfolio_data.dart`
- [ ] Update experience start dates in `portfolio_data.dart`
- [ ] Replace placeholder articles with real content
- [ ] Add `og-image.png` to `web/` folder
- [ ] Set canonical URL in `web/index.html`
- [ ] Deploy to Firebase Hosting or GitHub Pages
