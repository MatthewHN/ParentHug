import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/section_header.dart';

/// Placeholder Library tab: a browsable shelf of activities, conversation
/// starters, and games for families. The structure is in place; the individual
/// items are stubs ("coming soon") until the real content is wired up.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _sections = <_LibrarySection>[
    _LibrarySection('Activities', [
      _LibraryItem('Indoor', '🏠', AppColors.yellowSoft),
      _LibraryItem('Outdoor', '🧭', AppColors.mintSoft),
      _LibraryItem('Holidays', '🎁', AppColors.coralSoft),
    ]),
    _LibrarySection('Talks', [
      _LibraryItem('Word Games', '🗣️', AppColors.primarySoft),
      _LibraryItem('Questions', '💬', AppColors.mintSoft),
      _LibraryItem('Tell a Story', '📖', AppColors.yellowSoft),
    ]),
    _LibrarySection('Games', [
      _LibraryItem('Charades', '🎭', AppColors.coralSoft),
      _LibraryItem('Guess the Flag', '🚩', AppColors.primarySoft),
      _LibraryItem('Mood Tracker', '🙂', AppColors.yellowSoft),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            const _SearchBar(),
            const SizedBox(height: 8),
            for (final section in _sections) ...[
              const SizedBox(height: 18),
              SectionHeader(title: section.title),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemCount: section.items.length,
                itemBuilder: (_, i) => _Tile(item: section.items[i]),
              ),
            ],
            const SizedBox(height: 24),
            Center(
              child: Text(
                'More activities & games are on the way.',
                style: TextStyle(
                    color: AppColors.inkFaint,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppSnackbar.show(context, 'Search is coming soon'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.inkFaint),
            SizedBox(width: 10),
            Text('Search activities & games',
                style: TextStyle(color: AppColors.inkFaint, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item});
  final _LibraryItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppSnackbar.show(context, '${item.label} is coming soon'),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              alignment: Alignment.center,
              child: Text(item.emoji, style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

class _LibrarySection {
  const _LibrarySection(this.title, this.items);
  final String title;
  final List<_LibraryItem> items;
}

class _LibraryItem {
  const _LibraryItem(this.label, this.emoji, this.color);
  final String label;
  final String emoji;
  final Color color;
}
