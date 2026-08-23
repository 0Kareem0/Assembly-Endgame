import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../widgets/particle_canvas.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _bgmVol = AudioService.bgmVolume;
  double _sfxVol = AudioService.sfxVolume;
  bool _bgmMuted = AudioService.bgmMuted;
  bool _sfxMuted = AudioService.sfxMuted;
  bool _screenShake = true;
  String _difficulty = 'Medium';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await StorageService.getSettings();
    if (mounted) {
      setState(() {
        _screenShake = settings.screenShake;
      });
    }
  }

  void _saveSettings() {
    final updated = GameSettings(
      musicMuted: _bgmMuted,
      sfxMuted: _sfxMuted,
      screenShake: _screenShake,
    );
    StorageService.saveSettings(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const ParticleCanvasWidget(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              AudioService.playSfx('click');
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Settings",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // BGM Volume Slider
                            const Text("BACKGROUND MUSIC", style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(_bgmMuted ? Icons.volume_off : Icons.volume_up, color: AppColors.cyanPrimary),
                                  onPressed: () {
                                    AudioService.toggleBgmMute();
                                    setState(() {
                                      _bgmMuted = AudioService.bgmMuted;
                                    });
                                    _saveSettings();
                                  },
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _bgmMuted ? 0.0 : _bgmVol,
                                    activeColor: AppColors.cyanPrimary,
                                    inactiveColor: AppColors.card,
                                    onChanged: (val) {
                                      setState(() {
                                        _bgmVol = val;
                                        _bgmMuted = false;
                                      });
                                      AudioService.setBgmVolume(val);
                                      _saveSettings();
                                    },
                                  ),
                                ),
                                Text("${(_bgmMuted ? 0 : (_bgmVol * 100)).round()}%", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),

                            const Divider(color: Colors.white10, height: 32),

                            // SFX Volume Slider
                            const Text("SOUND EFFECTS (SFX)", style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(_sfxMuted ? Icons.volume_off : Icons.volume_up, color: AppColors.amberAccent),
                                  onPressed: () {
                                    AudioService.toggleSfxMute();
                                    setState(() {
                                      _sfxMuted = AudioService.sfxMuted;
                                    });
                                    _saveSettings();
                                  },
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _sfxMuted ? 0.0 : _sfxVol,
                                    activeColor: AppColors.amberAccent,
                                    inactiveColor: AppColors.card,
                                    onChanged: (val) {
                                      setState(() {
                                        _sfxVol = val;
                                        _sfxMuted = false;
                                      });
                                      AudioService.setSfxVolume(val);
                                      _saveSettings();
                                    },
                                  ),
                                ),
                                Text("${(_sfxMuted ? 0 : (_sfxVol * 100)).round()}%", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),

                            const Divider(color: Colors.white10, height: 32),

                            // Screen Shake Toggle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Screen Shake FX", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                    Text("Impact shake on wrong moves", style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                  ],
                                ),
                                Switch(
                                  value: _screenShake,
                                  activeColor: AppColors.amberAccent,
                                  onChanged: (val) {
                                    AudioService.playSfx('click');
                                    setState(() {
                                      _screenShake = val;
                                    });
                                    _saveSettings();
                                  },
                                ),
                              ],
                            ),

                            const Divider(color: Colors.white10, height: 32),

                            // Difficulty Selector
                            const Text("GAME DIFFICULTY", style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                            const SizedBox(height: 10),

                            Row(
                              children: ['Easy', 'Medium', 'Hard'].map((diff) {
                                final isSelected = _difficulty == diff;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    child: ChoiceChip(
                                      label: Center(child: Text(diff)),
                                      selected: isSelected,
                                      selectedColor: AppColors.cyanPrimary,
                                      backgroundColor: AppColors.card,
                                      labelStyle: TextStyle(
                                        color: isSelected ? AppColors.surface : AppColors.textMuted,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onSelected: (_) {
                                        AudioService.playSfx('click');
                                        setState(() {
                                          _difficulty = diff;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
