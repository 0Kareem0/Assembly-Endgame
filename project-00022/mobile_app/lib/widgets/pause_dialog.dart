import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class PauseDialogWidget extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onOpenSettings;
  final VoidCallback onMainMenu;

  const PauseDialogWidget({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onOpenSettings,
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF060913),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
              ),
              alignment: Alignment.center,
              child: const Text("⏸️", style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 12),
            const Text(
              "GAME PAUSED",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              "Take a breather, the stickman is waiting!",
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
            const SizedBox(height: 20),

            // Resume
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
                  onResume();
                },
                child: const Text("▶ RESUME GAME", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
              ),
            ),
            const SizedBox(height: 8),

            // Restart
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  SoundService.play('click');
                  onRestart();
                },
                child: const Text("🔄 Restart Round", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            // Settings
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  SoundService.play('click');
                  onOpenSettings();
                },
                child: const Text("⚙️ Audio & Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            // Quit
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: () {
                  SoundService.play('click');
                  onMainMenu();
                },
                child: const Text("🏠 Quit to Main Menu", style: TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
