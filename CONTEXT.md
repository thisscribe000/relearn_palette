# Re-Learn — Project Context

Flutter mobile app: social learning around books and learning material.
The app converts a full book's ideas into short, narrated "learning bites".

## Product
- Read complete books
- Discover bite-sized explanations
- Listen to narrated learning content
- Review concepts and answer recall questions
- Track learning progress
- Future: learn socially with other users

The product does NOT replace reading — it helps users understand, revisit,
and remember what they read.

## Current Status
Implemented so far (onboarding visuals + Home Learning Feed; no backend/auth/AI):

**Onboarding** — a single horizontally swipeable flow with three pages inside ONE
`PageView`, plus an animated indicator strip at the bottom driven by the
`PageController`:

1. **Page 0 — Splash** (`splash_page.dart`): wordmark "Re-Learn",
   tagline "Learn in scroll-length bites", `ReLearnLogo` mark.
2. **Page 1 — Concept** (`concept_page.dart`): headline "Turn any book into a reel.",
   supporting paragraph, `BookLearningIllustration` (open book + emerging cards).
3. **Page 2 — Get Started** (`get_started_page.dart`): headline "Your library, reimagined.",
   supporting text, `ReadingJourneyIllustration` (book → card → recall loop),
   "Get Started" + "I already have an account".

**Screen 04 — Home / Learning Feed** — built. After "Get Started", onboarding
navigates to `HomeFeedPage`, a shell with:

- A persistent custom `BottomNavigation` (Home → Learning Feed, Discover, Library,
  Me). Discover/Library/Me are **placeholders** (Screens 05–07 not built yet).
  Compact by design: content wrapped in `SafeArea` (bottom system inset respected)
  with `EdgeInsets.only(top: 5, bottom: 2)` and tight icon/label/dot spacing.
- **Home tab** = `FeedHeader` (Re-Learn wordmark, search icon, For You/Following
  tabs) above a **vertical** `PageView.builder` of full-screen `LearningBite`
  widgets (one bite per swipe, 8 bites in `mock_bites.dart`).
- Each bite is an **editorial magazine composition** on the bare canvas — NOT a
  card. Hierarchy (top→bottom): small letterspaced-caps category kicker
  (e.g. `OBSERVATION`), large serif headline, `LearningBiteIllustration`
  (CustomPaint line art, observe/control/wonder motifs), 2-line explanation,
  gold hairline rule + `KEY IDEA` in serif italics, Listen chip, hairline
  divider, then the **source book** (serif title + author) with a
  "Read the full book →" link — the source book is treated as an important
  literary element, not tiny metadata. A right-edge `LearningBiteActions` rail
  (Like, Discuss, Save, Share — Like/Save toggle locally; the rest show a
  "coming soon" SnackBar via `showComingSoon`).
- `LearningBite` uses `FittedBox(scaleDown)` guards around the headline and the
  body/key-idea block so they scale instead of overflowing on short screens.
- Design rule: the background is the canvas; whitespace (Spacers) creates
  hierarchy. No cards, no excess borders/shadows, no gradients.

Content is static mock data — no audio, reader, backend, or auth yet. The first
bite uses canonical editorial copy ("What do you actually see?" /
"NOTICE FIRST. INTERPRET SECOND.").

## Architecture
```
lib/
  main.dart                      # ReLearnApp, home = OnboardingPage
  core/theme/
    app_colors.dart              # palette constants
    app_theme.dart               # ThemeData + AppFonts + button themes
  features/onboarding/presentation/
    pages/
      onboarding_page.dart       # ONE PageView flow (Page 0, 1, 2)
      splash_page.dart           # Page 0
      concept_page.dart          # Page 1
      get_started_page.dart      # Page 2 (callbacks onGetStarted/onSignIn)
    widgets/
      re_learn_logo.dart         # editorial ring + serif R logomark
      book_learning_illustration.dart  # open book + bite cards illustration
      reading_journey_illustration.dart # READ->LEARN->REMEMBER illustration
      onboarding_indicators.dart # animated pill indicator strip (activeIndex)
  features/home/
    domain/
      learning_bite.dart         # LearningBiteData model + BiteVisual enum
                                 #   (category, bookTitle, author, topic/headline,
                                 #   body, keyIdea, listenDuration, visual)
    data/
      mock_bites.dart            # 8 static prototype bites
    presentation/
      pages/
        home_feed_page.dart      # Screen 04 shell + vertical bite feed
        discover_page.dart       # placeholder (Screen 06, not built)
        library_page.dart        # placeholder (Screen 05, not built)
        me_page.dart             # placeholder (Screen 07, not built)
      widgets/
        learning_bite.dart       # full-screen editorial bite composition
        learning_bite_actions.dart # Like/Discuss/Save/Share rail
        learning_bite_illustration.dart # CustomPaint line art, 3 variants
        feed_header.dart         # wordmark + search + For You/Following
        bottom_navigation.dart   # Home/Discover/Library/Me tabs
        coming_soon.dart         # showComingSoon() SnackBar helper
```

## Design System
| Token | Value |
|---|---|
| Background | `#F9F7F2` |
| Primary deep green | `#061B0E` |
| Secondary muted text | `#5E5E5B` |
| Indicator inactive | `#C3C8C1` |
| Paper (illustration fill) | `#FFFDF8` |
| Muted gold (accent) | `#B08D57` |

- Editorial, literary, premium, minimal. NOT school/kids/AI/dashboard/crypto style.
- No shadows, no gradients, no continuous animation.
- Headings: Source Serif 4 (700/600). Supporting/utility text: Inter (500/400).
- Sharp corners, generous whitespace, 8px spacing rhythm.

## Indicators
`OnboardingIndicators(activeIndex: i)` — active = 24x6 pill, inactive = 6x6 circle.

## Fonts
Local font files NOT yet bundled (POC falls back to system fonts).
`AppFonts.serif = 'Source Serif 4'`, `AppFonts.sans = 'Inter'`.
Add TTFs and uncomment the `fonts:` block in `pubspec.yaml` when available.

## Commands
- `flutter run` — run on simulator/device
- `flutter build apk --debug` — Android debug build (verified working)
- `flutter analyze` — static analysis (should be clean)

## Notes / Environment
- Xcode 26.6 requires the iOS 26.5 simulator runtime.
  If simulators appear ineligible, run `xcodebuild -downloadPlatform iOS`.
- Platform targets: Android + iOS only.
- No external packages used.
