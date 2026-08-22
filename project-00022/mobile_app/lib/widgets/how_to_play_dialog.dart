import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class HowToPlayDialogWidget extends StatelessWidget {
  final VoidCallback onStartGame;

  const HowToPlayDialogWidget({super.key, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text("📖 ", style: TextStyle(fontSize: 20)),
                      Text(
                        "How To Play",
                        style: TextStyle(
                          color: Color(0xFFFDE68A),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: Colors.white10),
              const SizedBox(height: 8),

              // Card 1: Objective
              _buildGuideCard(
                icon: "🎯",
                iconBg: const Color(0xFF0284C7),
                title: "The Objective",
                titleColor: const Color(0xFF38BDF8),
                body: "Guess the mystery word one letter at a time to rescue the hero before the trapdoor opens!",
              ),
              const SizedBox(height: 8),

              // Card 2: Timer Rules
              _buildGuideCard(
                icon: "⏱️",
                iconBg: const Color(0xFFB45309),
                title: "Timer & Start Mechanics",
                titleColor: const Color(0xFFFCD34D),
                body: "The timer is paused by default. It only starts after you click Start Game and finish the 3-2-1 GO! countdown.",
              ),
              const SizedBox(height: 8),

              // Card 3: Scoring & Multipliers
              _buildGuideCard(
                icon: "⚡",
                iconBg: const Color(0xFF047857),
                title: "Scoring & Multipliers",
                titleColor: const Color(0xFF6EE7B7),
                body: "Earn bonus points for solving words quickly and keeping your Win Streak 🔥 alive! Each win adds a +20% score bonus.",
              ),
              const SizedBox(height: 8),

              // Card 4: Controls
              _buildGuideCard(
                icon: "⌨️",
                iconBg: const Color(0xFF6B21A8),
                title: "Controls",
                titleColor: const Color(0xFFD8B4FE),
                body: "Tap keys on the virtual onscreen keyboard or type directly using your device keyboard.",
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      SoundService.play('click');
                      Navigator.of(context).pop();
                      onStartGame();
                    },
                    child: const Text("START GAME 🎮", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard({
    required String icon,
    required Color iconBg,
    required String title,
    required Color titleColor,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: titleColor, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(body, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
