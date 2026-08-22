import 'dart:async';
import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class CountdownOverlayWidget extends StatefulWidget {
  final VoidCallback onComplete;

  const CountdownOverlayWidget({super.key, required this.onComplete});

  @override
  State<CountdownOverlayWidget> createState() => _CountdownOverlayWidgetState();
}

class _CountdownOverlayWidgetState extends State<CountdownOverlayWidget> {
  int _count = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    SoundService.play('count');
    _timer = Timer.periodic(const Duration(milliseconds: 850), (t) {
      if (_count > 1) {
        setState(() {
          _count--;
        });
        SoundService.play('count');
      } else if (_count == 1) {
        setState(() {
          _count = 0; // GO!
        });
        SoundService.play('go');
      } else {
        _timer?.cancel();
        widget.onComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF060913).withValues(alpha: 0.9),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _count > 0
            ? Column(
                key: ValueKey(_count),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$_count",
                    style: const TextStyle(
                      color: Color(0xFFFDE68A),
                      fontSize: 100,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    "GET READY...",
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              )
            : const Column(
                key: ValueKey(0),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "GO!",
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 90,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "TIMER STARTED!",
                    style: TextStyle(
                      color: Color(0xFF6EE7B7),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
