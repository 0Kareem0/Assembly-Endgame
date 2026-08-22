import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

class MainMenuWidget extends StatelessWidget {
  final VoidCallback onStartGame;
  final VoidCallback onOpenHowToPlay;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenLeaderboard;
  final VoidCallback onOpenSettings;
  final PlayerProfile profile;
  final String avatar;
  final String playerName;
  final VoidCallback onToggleAudio;

  const MainMenuWidget({
    super.key,
    required this.onStartGame,
    required this.onOpenHowToPlay,
    required this.onOpenProfile,
    required this.onOpenLeaderboard,
    required this.onOpenSettings,
    required this.profile,
    required this.avatar,
    required this.playerName,
    required this.onToggleAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
              blurRadius: 24,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Quick Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile Badge
                InkWell(
                  onTap: () {
                    SoundService.play('click');
                    onOpenProfile();
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090D16),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Text(avatar, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playerName,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Lvl ${profile.level}",
                              style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 9, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Audio Button
                IconButton(
                  onPressed: onToggleAudio,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF090D16),
                    side: const BorderSide(color: Colors.white10),
                  ),
                  icon: Icon(
                    SoundService.sfxMuted ? Icons.volume_off : Icons.volume_up,
                    color: SoundService.sfxMuted ? const Color(0xFF64748B) : const Color(0xFF38BDF8),
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Game Title
            const Text(
              "Hangman Escape",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFDE68A),
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Solve mystery words to escape the trapdoor!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
            const SizedBox(height: 24),

            // Action Buttons List
            _buildMenuButton(
              label: "START GAME",
              icon: "🎮",
              isPrimary: true,
              onTap: () {
                SoundService.play('click');
                onStartGame();
              },
            ),
            const SizedBox(height: 10),

            _buildMenuButton(
              label: "How To Play",
              icon: "📖",
              subtitle: "Guide & Rules ➔",
              onTap: () {
                SoundService.play('click');
                onOpenHowToPlay();
              },
            ),
            const SizedBox(height: 10),

            _buildMenuButton(
              label: "Profile & XP",
              icon: "👤",
              subtitle: "Lvl ${profile.level} • ${profile.unlockedAchievements.length} Badges ➔",
              subtitleColor: const Color(0xFF38BDF8),
              onTap: () {
                SoundService.play('click');
                onOpenProfile();
              },
            ),
            const SizedBox(height: 10),

            _buildMenuButton(
              label: "Hall of Fame",
              icon: "🏆",
              subtitle: "High Scores ➔",
              subtitleColor: const Color(0xFFF59E0B),
              onTap: () {
                SoundService.play('click');
                onOpenLeaderboard();
              },
            ),
            const SizedBox(height: 10),

            _buildMenuButton(
              label: "Settings",
              icon: "⚙️",
              subtitle: "Audio & FX ➔",
              onTap: () {
                SoundService.play('click');
                onOpenSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String label,
    required String icon,
    String? subtitle,
    Color? subtitleColor,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF38BDF8),
            foregroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor ?? const Color(0xFF94A3B8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
