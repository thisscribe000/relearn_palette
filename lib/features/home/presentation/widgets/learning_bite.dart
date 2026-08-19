import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../reader/data/mock_reader_book.dart';
import '../../../reader/presentation/pages/reader_page.dart';
import '../../domain/learning_bite.dart';

import 'coming_soon.dart';

/// Full-screen reading reel for a single Learning Bite.
///
/// The passage is the main event: surrounding lines stay quiet while the
/// current line is highlighted like a slow karaoke read-through.
class LearningBite extends StatefulWidget {
  const LearningBite({
    super.key,
    required this.bite,
    required this.onDiscussionChanged,
  });

  final LearningBiteData bite;
  final ValueChanged<bool> onDiscussionChanged;

  @override
  State<LearningBite> createState() => _LearningBiteState();
}

class _LearningBiteState extends State<LearningBite> {
  late final PageController _pageController;
  bool _liked = false;
  bool _saved = false;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final compact = height < 640;
        final lines = widget.bite.passageLines.isEmpty
            ? [widget.bite.body]
            : widget.bite.passageLines;
        final activeLine = _clampedActiveLine(lines.length);

        return PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (page) => widget.onDiscussionChanged(page == 1),
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTap: _doubleTapLike,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      28,
                      compact ? 16 : 24,
                      28,
                      compact ? 12 : 20,
                    ),
                    child: Column(
                      children: [
                        _BookContext(bite: widget.bite, compact: compact),
                        Expanded(
                          child: _PassageReader(
                            lines: lines,
                            activeLine: activeLine,
                            compact: compact,
                          ),
                        ),
                        _LearningCue(bite: widget.bite, compact: compact),
                        SizedBox(height: compact ? 6 : 8),
                        InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: _openReader,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              'Read the full book →',
                              style: TextStyle(
                                fontFamily: AppFonts.sans,
                                fontSize: compact ? 11.5 : 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: compact ? 10 : 14),
                        _AudioProgress(
                          duration: widget.bite.listenDuration,
                          progress: (activeLine + 1) / lines.length,
                          compact: compact,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: compact ? 4 : 10,
                    right: 10,
                    child: _MoreButton(
                      liked: _liked,
                      saved: _saved,
                      onLike: _toggleLike,
                      onSave: _toggleSave,
                      onDiscuss: _showDiscussionPage,
                    ),
                  ),
                  Center(child: _HeartBurst(visible: _showHeart)),
                ],
              ),
            ),
            _DiscussionPane(
              bite: widget.bite,
              compact: compact,
              liked: _liked,
              saved: _saved,
              onLike: _toggleLike,
              onSave: _toggleSave,
              onBackToReading: _showReadingPage,
            ),
          ],
        );
      },
    );
  }

  int _clampedActiveLine(int lineCount) {
    if (lineCount <= 1) return 0;
    if (widget.bite.activeLineIndex < 0) return 0;
    if (widget.bite.activeLineIndex >= lineCount) return lineCount - 1;
    return widget.bite.activeLineIndex;
  }

  void _toggleLike() {
    setState(() => _liked = !_liked);
  }

  void _openReader() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ReaderPage(book: mockReaderBook),
      ),
    );
  }

  void _toggleSave() {
    setState(() => _saved = !_saved);
  }

  void _doubleTapLike() {
    setState(() {
      _liked = true;
      _showHeart = true;
    });
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() => _showHeart = false);
      }
    });
  }

  void _showDiscussionPage() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _showReadingPage() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }
}

class _DiscussionPane extends StatelessWidget {
  const _DiscussionPane({
    required this.bite,
    required this.compact,
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onSave,
    required this.onBackToReading,
  });

  final LearningBiteData bite;
  final bool compact;
  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onBackToReading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        28,
        compact ? 16 : 24,
        28,
        compact ? 12 : 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackToReading,
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.primaryGreen,
                tooltip: 'Back to reading',
              ),
              const Spacer(),
              Text(
                'Discussion',
                style: TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: compact ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          SizedBox(height: compact ? 18 : 28),
          Text(
            bite.topic,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: AppFonts.serif,
              fontSize: compact ? 28 : 34,
              fontWeight: FontWeight.w700,
              height: 1.08,
              letterSpacing: 0,
              color: AppColors.primaryGreen,
            ),
          ),
          SizedBox(height: compact ? 12 : 18),
          Text(
            bite.keyIdea,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: compact ? 10.5 : 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.mutedGold,
            ),
          ),
          const Spacer(),
          _CommentPreview(
            name: 'Amina',
            text:
                'This makes the passage feel less like information and more like a habit: look first, explain later.',
            compact: compact,
          ),
          SizedBox(height: compact ? 10 : 14),
          _CommentPreview(
            name: 'David',
            text:
                'The active line helps. I can slow down instead of rushing through the idea.',
            compact: compact,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DiscussionAction(
                icon: liked ? Icons.favorite : Icons.favorite_border,
                label: 'Like',
                active: liked,
                compact: compact,
                onTap: onLike,
              ),
              _DiscussionAction(
                icon: saved ? Icons.bookmark : Icons.bookmark_border,
                label: 'Save',
                active: saved,
                compact: compact,
                onTap: onSave,
              ),
              _DiscussionAction(
                icon: Icons.ios_share,
                label: 'Share',
                active: false,
                compact: compact,
                onTap: () => showComingSoon(context, 'Share'),
              ),
            ],
          ),
          SizedBox(height: compact ? 14 : 22),
          _CommentComposer(compact: compact),
        ],
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onSave,
    required this.onDiscuss,
  });

  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onDiscuss;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.paper,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MenuAction(
                  icon: Icons.chat_bubble_outline,
                  label: 'Open discussion',
                  onTap: () {
                    Navigator.of(context).pop();
                    onDiscuss();
                  },
                ),
                _MenuAction(
                  icon: liked ? Icons.favorite : Icons.favorite_border,
                  label: liked ? 'Liked' : 'Like',
                  onTap: () {
                    Navigator.of(context).pop();
                    onLike();
                  },
                ),
                _MenuAction(
                  icon: saved ? Icons.bookmark : Icons.bookmark_border,
                  label: saved ? 'Saved' : 'Save',
                  onTap: () {
                    Navigator.of(context).pop();
                    onSave();
                  },
                ),
                _MenuAction(
                  icon: Icons.ios_share,
                  label: 'Share',
                  onTap: () {
                    Navigator.of(context).pop();
                    showComingSoon(context, 'Share');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      icon: const Icon(Icons.more_horiz_rounded),
      color: AppColors.secondaryText,
      tooltip: 'More',
    );
  }
}

class _MenuAction extends StatelessWidget {
  const _MenuAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: AppFonts.sans,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}

class _HeartBurst extends StatelessWidget {
  const _HeartBurst({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: visible ? 1 : 0.72,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : 0,
        child: const Icon(
          Icons.favorite_rounded,
          size: 96,
          color: AppColors.mutedGold,
        ),
      ),
    );
  }
}

class _CommentPreview extends StatelessWidget {
  const _CommentPreview({
    required this.name,
    required this.text,
    required this.compact,
  });

  final String name;
  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.mutedGold.withValues(alpha: 0.75),
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: compact ? 12 : 13.5,
                height: 1.45,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscussionAction extends StatelessWidget {
  const _DiscussionAction({
    required this.icon,
    required this.label,
    required this.active,
    required this.compact,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final bool compact;
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
            Icon(icon, size: compact ? 20 : 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: compact ? 10.5 : 11.5,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentComposer extends StatelessWidget {
  const _CommentComposer({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => showComingSoon(context, 'Comments'),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: compact ? 10 : 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.indicatorInactive.withValues(alpha: 0.9),
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Add your thought...',
                style: TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: compact ? 12.5 : 13.5,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_upward_rounded,
              size: 18,
              color: AppColors.primaryGreen,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookContext extends StatelessWidget {
  const _BookContext({required this.bite, required this.compact});

  final LearningBiteData bite;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          bite.category,
          style: TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: compact ? 9.5 : 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.8,
            color: AppColors.mutedGold,
          ),
        ),
        SizedBox(height: compact ? 8 : 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 330),
          child: Text(
            bite.bookTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: AppFonts.serif,
              fontSize: compact ? 22 : 26,
              fontWeight: FontWeight.w700,
              height: 1.12,
              letterSpacing: 0,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
        SizedBox(height: compact ? 4 : 6),
        Text(
          bite.author,
          style: TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: compact ? 12 : 13.5,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _PassageReader extends StatelessWidget {
  const _PassageReader({
    required this.lines,
    required this.activeLine,
    required this.compact,
  });

  final List<String> lines;
  final int activeLine;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < lines.length; i++)
              _PassageLine(
                text: lines[i],
                active: i == activeLine,
                dimmed: (i - activeLine).abs() > 1,
                compact: compact,
              ),
          ],
        ),
      ),
    );
  }
}

class _PassageLine extends StatelessWidget {
  const _PassageLine({
    required this.text,
    required this.active,
    required this.dimmed,
    required this.compact,
  });

  final String text;
  final bool active;
  final bool dimmed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineSmall!.copyWith(
        fontFamily: AppFonts.serif,
        fontSize: active ? (compact ? 33 : 40) : (compact ? 24 : 29),
        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        height: active ? 1.12 : 1.2,
        letterSpacing: 0,
        color: active
            ? AppColors.primaryGreen
            : AppColors.secondaryText.withValues(alpha: dimmed ? 0.34 : 0.58),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: active ? 9 : 5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: active ? 1 : 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 3,
                  height: compact ? 34 : 42,
                  color: AppColors.mutedGold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningCue extends StatelessWidget {
  const _LearningCue({required this.bite, required this.compact});

  final LearningBiteData bite;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 34, height: 1.5, color: AppColors.indicatorInactive),
        SizedBox(height: compact ? 10 : 14),
        Text(
          bite.topic,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppFonts.sans,
            fontSize: compact ? 14 : 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
            color: AppColors.primaryGreen,
          ),
        ),
        SizedBox(height: compact ? 6 : 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 330),
          child: Text(
            bite.body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: AppFonts.sans,
              fontSize: compact ? 12 : 13.5,
              height: 1.45,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        SizedBox(height: compact ? 8 : 12),
        Text(
          bite.keyIdea,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            fontFamily: AppFonts.sans,
            fontSize: compact ? 10.5 : 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }
}

class _AudioProgress extends StatelessWidget {
  const _AudioProgress({
    required this.duration,
    required this.progress,
    required this.compact,
  });

  final String duration;
  final double progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => showComingSoon(context, 'Audio'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.play_arrow_rounded,
              size: 22,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: compact ? 92 : 118,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  minHeight: 3,
                  value: progress,
                  backgroundColor: AppColors.indicatorInactive.withValues(
                    alpha: 0.55,
                  ),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.mutedGold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              duration,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: compact ? 12 : 13,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
