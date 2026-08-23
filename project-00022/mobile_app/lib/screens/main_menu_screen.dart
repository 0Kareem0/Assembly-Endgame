import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/page_transitions.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../widgets/cyber_button.dart';
import '../widgets/particle_canvas.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  PlayerProfile _profile = PlayerProfile(xp: 0, level: 1, unlockedAchievements: []);
  String _avatar = "🤠";
  String _playerName = "Player 1";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await StorageService.getProfile();
    final a = await StorageService.getPlayerAvatar();
    final n = await StorageService.getPlayerName();

    if (mounted) {
      setState(() {
        _profile = p;
        _avatar = a;
        _playerName = n;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          const ParticleCanvasWidget(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 380),
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyanPrimary.withValues(alpha: 0.15),
                        blurRadius: 28,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                Text(_avatar, style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _playerName,
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Level ${_profile.level}",
                                      style: const TextStyle(color: AppColors.cyanPrimary, fontSize: 9, fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              AudioService.toggleSfxMute();
                              setState(() {});
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.card,
                              side: const BorderSide(color: Colors.white10),
                            ),
                            icon: Icon(
                              AudioService.sfxMuted ? Icons.volume_off : Icons.volume_up,
                              color: AudioService.sfxMuted ? AppColors.textSubtle : AppColors.cyanPrimary,
                              size: 18,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Logo & Title
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.cyanPrimary, AppColors.amberAccent, AppColors.purpleAccent],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(17.5),
                          ),
                          alignment: Alignment.center,
                          child: const Text("🪢", style: TextStyle(fontSize: 36)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        "Hangman Escape",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.amberLight,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Solve mystery words to escape the trapdoor!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 24),

                      // Menu Buttons
                      CyberButton(
                        label: "START GAME",
                        icon: "🎮",
                        isPrimary: true,
                        onTap: () {
                          Navigator.of(context).push(
                            FadeScalePageRoute(page: const GameScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),

                      CyberButton(
                        label: "Settings",
                        icon: "⚙️",
                        subtitle: "Audio & FX ➔",
                        onTap: () {
                          Navigator.of(context).push(
                            FadeScalePageRoute(page: const SettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
