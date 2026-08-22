import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

class GameOverDialogWidget extends StatelessWidget {
  final bool gameWon;
  final String currentWord;
  final int lastScore;
  final int timeTaken;
  final ResultMeta? resultMeta;
  final VoidCallback onPlayAgain;
  final VoidCallback onMainMenu;

  const GameOverDialogWidget({
    super.key,
    required this.gameWon,
    required this.currentWord,
    required this.lastScore,
    required this.timeTaken,
    this.resultMeta,
    required this.onPlayAgain,
    required this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Banner
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: gameWon ? const Color(0xFF064E3B) : const Color(0xFF881337),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gameWon ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
              ),
              alignment: Alignment.center,
              child: Text(gameWon ? "🎉" : "💀", style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: 12),

            Text(
              gameWon ? "HERO RESCUED!" : "GAME OVER",
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              gameWon ? "Outstanding speed and word precision!" : "The mystery word was \"${currentWord.toUpperCase()}\".",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
            const SizedBox(height: 12),

            // High score alert
            if (resultMeta?.isNewHighScore == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFB45309).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: const Text(
                  "👑 NEW HIGH SCORE RECORD!",
                  style: TextStyle(color: Color(0xFFFCD34D), fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),

            // Level up alert
            if (resultMeta?.isLevelUp == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF38BDF8)),
                ),
                child: Text(
                  "⚡ LEVEL UP! NOW LEVEL ${resultMeta?.profile.level}!",
                  style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090D16),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        const Text("SCORE", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold)),
                        Text(gameWon ? "$lastScore" : "0", style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090D16),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        const Text("TIME", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold)),
                        Text("${timeTaken}s", style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("XP Gained", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text("+${resultMeta?.gainedXp ?? 0} XP", style: const TextStyle(color: Color(0xFF10B981), fontSize: 14, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  SoundService.play('click');
                  Navigator.of(context).pop();
                  onPlayAgain();
                },
                child: const Text("PLAY AGAIN 🔄", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: () {
                  SoundService.play('click');
                  Navigator.of(context).pop();
                  onMainMenu();
                },
                child: const Text("🏠 Main Menu", style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
