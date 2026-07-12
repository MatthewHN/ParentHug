import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../data/game_word_bank.dart';

class ImpostorScreen extends StatefulWidget {
  const ImpostorScreen({super.key});

  @override
  State<ImpostorScreen> createState() => _ImpostorScreenState();
}

class _ImpostorScreenState extends State<ImpostorScreen> {
  final _random = Random();
  var _playerCount = 3;
  List<String>? _roles;
  final _assignedPlayers = <int>{};
  int? _revealedPlayer;

  void _play() {
    final word = GameWordBank.words[_random.nextInt(GameWordBank.words.length)];
    final roles = List<String>.filled(_playerCount, word)
      ..[_random.nextInt(_playerCount)] = 'Imposter';
    roles.shuffle(_random);
    setState(() {
      _roles = roles;
      _assignedPlayers.clear();
      _revealedPlayer = null;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Impostor')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _roles == null ? _setup() : _game(),
          ),
        ),
      );

  Widget _setup() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          const Text('How many players?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 26,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Text(
              'Everyone gets the same secret word except one Impostor. Give short clues and work out who is bluffing.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.inkMuted, height: 1.4)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: _playerCount > 3
                    ? () => setState(() => _playerCount--)
                    : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              SizedBox(
                width: 110,
                child: Text('$_playerCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 56,
                        fontWeight: FontWeight.w900)),
              ),
              IconButton.filledTonal(
                onPressed: _playerCount < 12
                    ? () => setState(() => _playerCount++)
                    : null,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const Spacer(),
          PrimaryButton(
              label: 'Play', icon: Icons.play_arrow_rounded, onPressed: _play),
        ],
      );

  Widget _game() {
    if (_revealedPlayer != null) return _revealRole(_revealedPlayer!);
    if (_assignedPlayers.length == _playerCount) return _complete();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Choose your card',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.ink,
                fontSize: 24,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text(
            'Tap one card, see your role privately, then pass the phone on.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.inkMuted, height: 1.4)),
        const SizedBox(height: 26),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: _playerCount,
            itemBuilder: (_, index) {
              final assigned = _assignedPlayers.contains(index);
              return Semantics(
                button: !assigned,
                label: 'Player ${index + 1} card',
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: assigned
                      ? null
                      : () => setState(() => _revealedPlayer = index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: assigned
                          ? const Color(0xFFBDEBD3)
                          : const Color(0xFFD6C5FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              assigned
                                  ? Icons.check_circle_rounded
                                  : Icons.style_rounded,
                              color:
                                  assigned ? AppColors.mint : AppColors.primary,
                              size: 34),
                          const SizedBox(height: 8),
                          Text(assigned ? 'Assigned' : 'Player ${index + 1}',
                              style: const TextStyle(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _revealRole(int player) {
    final role = _roles![player];
    final impostor = role == 'Imposter';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Text('Player ${player + 1}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 18)),
        const SizedBox(height: 12),
        Text(impostor ? 'IMPOSTER' : role.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: impostor ? AppColors.coral : AppColors.primary,
                fontSize: 42,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        Text(
            impostor
                ? 'Blend in. Do not reveal that you are the Impostor.'
                : 'Remember the prompt. Do not show anyone else.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.inkMuted, height: 1.4)),
        const Spacer(),
        PrimaryButton(
          label: 'Hide & pass the phone',
          icon: Icons.visibility_off_rounded,
          onPressed: () => setState(() {
            _assignedPlayers.add(player);
            _revealedPlayer = null;
          }),
        ),
      ],
    );
  }

  Widget _complete() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.groups_rounded, color: AppColors.mint, size: 62),
          const SizedBox(height: 16),
          const Text('Everyone has a role',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 26,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text(
              'Take turns saying one word or a short clue related to the secret word. Prove you know it without making it obvious; the Impostor listens and tries to blend in. After everyone gives a clue, discuss and vote.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.inkMuted, height: 1.45)),
          const SizedBox(height: 28),
          PrimaryButton(
              label: 'Play again',
              icon: Icons.refresh_rounded,
              onPressed: _play),
        ],
      );
}
