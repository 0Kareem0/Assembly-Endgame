import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class GameHUDWidget extends StatelessWidget {
  final int timeTaken;
  final int currentStreak;
  final VoidCallback onPause;
  final VoidCallback onToggleAudio;

  const GameHUDWidget({
    super.key,
    required this.timeTaken,
    required this.currentStreak,
    required this.onPause,
    required this.onToggleAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pause Button & Audio Button
        Row(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                side: const BorderSide(color: Colors.white10),
              ),
              onPressed: () {
                SoundService.play('click');
                onPause();
              },
              icon: const Text("⏸️", style: TextStyle(fontSize: 12)),
              label: const Text("Pause", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: onToggleAudio,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                side: const BorderSide(color: Colors.white10),
              ),
              icon: Icon(
                SoundService.sfxMuted ? Icons.volume_off : Icons.volume_up,
                color: SoundService.sfxMuted ? const Color(0xFF64748B) : const Color(0xFF38BDF8),
                size: 16,
              ),
            ),
          ],
        ),

        // Live Timer & Streak Indicator
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                "⏱️ ${timeTaken}s",
                style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF451A03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              ),
              child: Text(
                "🔥 Streak: $currentStreak",
                style: const TextStyle(color: Color(0xFFFCD34D), fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
