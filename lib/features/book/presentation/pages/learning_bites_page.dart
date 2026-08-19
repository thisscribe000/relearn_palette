import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/library_book.dart';
import '../../../home/presentation/widgets/coming_soon.dart';
import '../../data/mock_book_bites.dart';
import '../../domain/book_bite.dart';
import '../widgets/book_discussion_sheet.dart';

/// The full-screen Learning Bites experience — a focused, vertical swipe
/// through the book's ideas, one bite per screen.
///
/// Reached from Book Detail ("Learn the Book") and the Library continue card
/// ("Revisit in bites"). Each bite is an editorial composition on the bare
/// canvas, in the same literary voice as the Home feed: kicker, serif
/// headline, explanation, key-idea flourish, and (unlike the social feed)
/// Save / Discuss / Share actions at the foot of the page. Mock/local state
/// only.
class LearningBitesPage extends StatefulWidget {
  const LearningBitesPage({super.key, required this.book});

  final LibraryBook book;

  @override
  State<LearningBitesPage> createState() => _LearningBitesPageState();
}

class _LearningBitesPageState extends State<LearningBitesPage> {
  late final List<BookBite> _bites = bookBitesFor(widget.book);
  final Set<String> _savedIds = {};
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final total = _bites.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              bookTitle: widget.book.title,
              current: _index + 1,
              total: total,
            ),
            _ProgressLine(value: total > 0 ? (_index + 1) / total : 0),
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: total,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final bite = _bites[i];
                  return _LearningBiteView(
                    bite: bite,
                    saved: _savedIds.contains(bite.id),
                    onSave: () => _toggleSave(bite),
                    onDiscuss: () => showBookDiscussion(
                      context,
                      bookTitle: widget.book.title,
                      biteTitle: bite.title,
                    ),
                    onShare: () => showComingSoon(context, 'Share'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSave(BookBite bite) {
    setState(() {
      if (!_savedIds.add(bite.id)) {
        _savedIds.remove(bite.id);
      }
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bookTitle,
    required this.current,
    required this.total,
  });

  final String bookTitle;
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primaryGreen,
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learning Bites',
                  style: TextStyle(
                    fontFamily: AppFonts.serif,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  bookTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$current of $total',
            style: const TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 13.5,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          minHeight: 2,
          value: value,
          backgroundColor: AppColors.indicatorInactive.withValues(alpha: 0.55),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mutedGold),
        ),
      ),
    );
  }
}

class _LearningBiteView extends StatelessWidget {
  const _LearningBiteView({
    required this.bite,
    required this.saved,
    required this.onSave,
    required this.onDiscuss,
    required this.onShare,
  });

  final BookBite bite;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onDiscuss;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 620;
        final columnWidth = compact ? 320.0 : 360.0;

        return Padding(
          padding: EdgeInsets.fromLTRB(26, compact ? 10 : 16, 26, 14),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: columnWidth),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bite.category,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppFonts.sans,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.8,
                              color: AppColors.mutedGold,
                            ),
                          ),
                          SizedBox(height: compact ? 10 : 14),
                          Text(
                            bite.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFonts.serif,
                              fontSize: compact ? 28 : 34,
                              fontWeight: FontWeight.w700,
                              height: 1.14,
                              letterSpacing: 0,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          SizedBox(height: compact ? 12 : 16),
                          Text(
                            bite.explanation,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppFonts.serif,
                              fontSize: 15.5,
                              height: 1.6,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: compact ? 14 : 18),
                          const SizedBox(
                            width: 34,
                            height: 1.5,
                            child: ColoredBox(
                              color: AppColors.indicatorInactive,
                            ),
                          ),
                          SizedBox(height: compact ? 10 : 12),
                          Text(
                            bite.keyIdea,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontFamily: AppFonts.serif,
                                  fontSize: compact ? 12.5 : 13.5,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.4,
                                  height: 1.4,
                                  color: AppColors.primaryGreen,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: AppColors.indicatorInactive.withValues(alpha: 0.4),
              ),
              SizedBox(height: compact ? 10 : 14),
              Text(
                'Chapter ${bite.chapterIndex + 1} · ${bite.chapterTitle}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: AppColors.secondaryText,
                ),
              ),
              SizedBox(height: compact ? 2 : 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BiteAction(
                    icon: saved ? Icons.bookmark : Icons.bookmark_border,
                    label: saved ? 'SAVED' : 'SAVE',
                    active: saved,
                    onTap: onSave,
                  ),
                  const SizedBox(width: 26),
                  _BiteAction(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'DISCUSS',
                    active: false,
                    onTap: onDiscuss,
                  ),
                  const SizedBox(width: 26),
                  _BiteAction(
                    icon: Icons.ios_share,
                    label: 'SHARE',
                    active: false,
                    onTap: onShare,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BiteAction extends StatelessWidget {
  const _BiteAction({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryGreen : AppColors.secondaryText;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
