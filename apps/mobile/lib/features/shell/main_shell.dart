import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

/// Bottom-navigation shell hosting the five main tabs. The Hug tab sits in the
/// center and is visually emphasized as the app's core action.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  static const _items = [
    _NavSpec('Today', Icons.wb_sunny_outlined, Icons.wb_sunny_rounded),
    _NavSpec('Hug', Icons.volunteer_activism_outlined,
        Icons.volunteer_activism_rounded),
    _NavSpec('Board', Icons.dashboard_outlined, Icons.dashboard_rounded),
    _NavSpec('Memories', Icons.photo_library_outlined,
        Icons.photo_library_rounded),
    _NavSpec('Profile', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  void _go(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: const Color(0x141F2A44),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
                    child: i == 1
                        ? _HugTab(
                            selected: shell.currentIndex == 1,
                            onTap: () => _go(1),
                          )
                        : _NavTab(
                            spec: _items[i],
                            selected: shell.currentIndex == i,
                            onTap: () => _go(i),
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavSpec {
  const _NavSpec(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final _NavSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.inkFaint;
    return InkResponse(
      onTap: onTap,
      radius: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected ? spec.activeIcon : spec.icon, color: color, size: 25),
          const SizedBox(height: 4),
          Text(
            spec.label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HugTab extends StatelessWidget {
  const _HugTab({required this.selected, required this.onTap});
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.hugGradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.coral.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.volunteer_activism_rounded,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(height: 3),
            Text(
              'Hug',
              style: TextStyle(
                color: selected ? AppColors.coral : AppColors.inkMuted,
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
