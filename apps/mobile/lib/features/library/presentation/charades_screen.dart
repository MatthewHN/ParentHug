import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../data/game_word_bank.dart';

class CharadesScreen extends StatelessWidget {
  const CharadesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Charades')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Text('Ready for Charades?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 28,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                const Text(
                  'Hold the phone on your forehead and let everyone else act it out.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.inkMuted, height: 1.45),
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Start playing',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (_) => const _CharadesRoundScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _CharadesRoundScreen extends StatefulWidget {
  const _CharadesRoundScreen();

  @override
  State<_CharadesRoundScreen> createState() => _CharadesRoundScreenState();
}

class _CharadesRoundScreenState extends State<_CharadesRoundScreen> {
  final _random = Random();
  Timer? _timer;
  var _countdown = 5;
  var _showWord = false;
  late String _word;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _startRound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void _startRound() {
    _timer?.cancel();
    setState(() {
      _word = GameWordBank.words[_random.nextInt(GameWordBank.words.length)];
      _countdown = 5;
      _showWord = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        setState(() {
          _countdown = 0;
          _showWord = true;
        });
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: _showWord ? AppColors.primary : AppColors.cream,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
            child: _showWord ? _wordView() : _countdownView(),
          ),
        ),
      );

  Widget _countdownView() => Column(
        children: [
          const Spacer(),
          const Text('Place it on your forehead',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 30)),
          const SizedBox(height: 18),
          const Text('The word will appear in',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 18)),
          const SizedBox(height: 8),
          Text('$_countdown',
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 100,
                  fontWeight: FontWeight.w900)),
          const Spacer(),
        ],
      );

  Widget _wordView() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Act it out!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(_word.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 84,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style:
                        FilledButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text('Done',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _startRound,
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.yellow),
                    icon:
                        const Icon(Icons.refresh_rounded, color: AppColors.ink),
                    label: const Text('Go again',
                        style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
