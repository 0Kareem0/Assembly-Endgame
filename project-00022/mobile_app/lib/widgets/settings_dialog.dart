import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

class SettingsDialogWidget extends StatefulWidget {
  final VoidCallback? onSettingsChanged;

  const SettingsDialogWidget({super.key, this.onSettingsChanged});

  @override
  State<SettingsDialogWidget> createState() => _SettingsDialogWidgetState();
}

class _SettingsDialogWidgetState extends State<SettingsDialogWidget> {
  late Future<GameSettings> _settingsFuture;

  @override
  void initState() {
    super.initState();
    _settingsFuture = StorageService.getSettings();
  }

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
        child: FutureBuilder<GameSettings>(
          future: _settingsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8))),
              );
            }

            final settings = snapshot.data!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("⚙️ ", style: TextStyle(fontSize: 20)),
                        Text("Settings", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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

                // Sound SFX
                _buildSettingTile(
                  icon: SoundService.sfxMuted ? "🔕" : "🔊",
                  title: "Sound Effects (SFX)",
                  subtitle: "Click & gameplay feedback",
                  value: !SoundService.sfxMuted,
                  onChanged: (val) {
                    SoundService.play('click');
                    SoundService.setSfxMuted(!val);
                    final updated = GameSettings(
                      musicMuted: SoundService.musicMuted,
                      sfxMuted: !val,
                      screenShake: settings.screenShake,
                    );
                    StorageService.saveSettings(updated);
                    setState(() {});
                    widget.onSettingsChanged?.call();
                  },
                ),
                const SizedBox(height: 8),

                // Ambient Music
                _buildSettingTile(
                  icon: SoundService.musicMuted ? "🔇" : "🎵",
                  title: "Ambient Music",
                  subtitle: "Synthesized background audio",
                  value: !SoundService.musicMuted,
                  onChanged: (val) {
                    SoundService.play('click');
                    SoundService.setMusicMuted(!val);
                    final updated = GameSettings(
                      musicMuted: !val,
                      sfxMuted: SoundService.sfxMuted,
                      screenShake: settings.screenShake,
                    );
                    StorageService.saveSettings(updated);
                    setState(() {});
                    widget.onSettingsChanged?.call();
                  },
                ),
                const SizedBox(height: 8),

                // Screen Shake
                _buildSettingTile(
                  icon: "📳",
                  title: "Screen Shake FX",
                  subtitle: "Impact shake on wrong moves",
                  value: settings.screenShake,
                  onChanged: (val) {
                    SoundService.play('click');
                    final updated = GameSettings(
                      musicMuted: SoundService.musicMuted,
                      sfxMuted: SoundService.sfxMuted,
                      screenShake: val,
                    );
                    StorageService.saveSettings(updated);
                    setState(() {
                      _settingsFuture = Future.value(updated);
                    });
                    widget.onSettingsChanged?.call();
                  },
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Done", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9)),
                ],
              ),
            ],
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF38BDF8),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
