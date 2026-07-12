import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/section_header.dart';
import 'charades_screen.dart';
import 'impostor_screen.dart';

/// A small, intentional shelf of family play. Video-generation entries are
/// discoverable here but remain unavailable until their APIs are connected.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _sections = <_LibrarySection>[
    _LibrarySection('Bring to life', [
      _LibraryItem('Photo to video', '📷', Color(0xFFFFD98A)),
      _LibraryItem('Drawing to video', '🎨', AppColors.mintSoft),
      _LibraryItem('Dream to video', '🌙', AppColors.coralSoft),
    ]),
    _LibrarySection('Games', [
      _LibraryItem('Charades', '🎭', AppColors.yellowSoft),
      _LibraryItem('Impostor', '🕵️', Color(0xFFD6C5FF)),
    ]),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const AppHeader(),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              for (final section in _sections) ...[
                const SizedBox(height: 24),
                SectionHeader(title: section.title),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: section.items.length,
                  itemBuilder: (_, index) => _Tile(item: section.items[index]),
                ),
              ],
            ],
          ),
        ),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item});
  final _LibraryItem item;

  void _open(BuildContext context) {
    switch (item.label) {
      case 'Charades':
        Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<void>(builder: (_) => const CharadesScreen()));
      case 'Impostor':
        Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<void>(builder: (_) => const ImpostorScreen()));
      default:
        AppSnackbar.show(context, '${item.label} is coming soon');
    }
  }

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: item.label,
        child: GestureDetector(
          onTap: () => _open(context),
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
        ),
      );
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
