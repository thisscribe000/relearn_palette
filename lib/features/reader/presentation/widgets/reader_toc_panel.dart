import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/reader_book.dart';
import '../reader_settings.dart';

/// Table of contents sheet for the Reader. Lists chapters; the current
/// chapter is marked with a gold bar, and a Learning bites entry links to
/// the book's generated bites.
class ReaderTocPanel extends StatelessWidget {
  const ReaderTocPanel({
    super.key,
    required this.book,
    required this.currentChapter,
    required this.overallLabel,
    required this.palette,
    required this.onSelectChapter,
    required this.onSelectBites,
  });

  final ReaderBook book;
  final int currentChapter;
  final String overallLabel;
  final ReaderPalette palette;
  final ValueChanged<int> onSelectChapter;
  final VoidCallback onSelectBites;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contents',
                    style: TextStyle(
                      fontFamily: AppFonts.serif,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: palette.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${book.title} · $overallLabel',
                    style: TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 12,
                      color: palette.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: book.chapters.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  thickness: 1,
                  color: palette.secondary.withValues(alpha: 0.18),
                ),
                itemBuilder: (context, index) {
                  final chapter = book.chapters[index];
                  final isCurrent = index == currentChapter;
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onSelectChapter(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 20,
                            color: isCurrent
                                ? AppColors.mutedGold
                                : Colors.transparent,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chapter.title,
                                  style: TextStyle(
                                    fontFamily: AppFonts.serif,
                                    fontSize: 15,
                                    fontWeight: isCurrent
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isCurrent
                                        ? palette.ink
                                        : palette.secondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Chapter ${index + 1}',
                                  style: TextStyle(
                                    fontFamily: AppFonts.sans,
                                    fontSize: 11,
                                    color: palette.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: palette.secondary.withValues(alpha: 0.18),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onSelectBites();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_stories_outlined,
                      size: 20,
                      color: AppColors.mutedGold,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Learning bites',
                      style: TextStyle(
                        fontFamily: AppFonts.serif,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: palette.ink,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${book.bites.length}',
                      style: TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 12,
                        color: palette.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
