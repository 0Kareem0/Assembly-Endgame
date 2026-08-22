import 'package:flutter/material.dart';
import '../models/word_data.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

class ProfileDialogWidget extends StatefulWidget {
  final VoidCallback? onDataChanged;

  const ProfileDialogWidget({super.key, this.onDataChanged});

  @override
  State<ProfileDialogWidget> createState() => _ProfileDialogWidgetState();
}

class _ProfileDialogWidgetState extends State<ProfileDialogWidget> {
  late Future<Map<String, dynamic>> _profileFuture;
  bool _isEditingName = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _profileFuture = Future.wait([
      StorageService.getPlayerName(),
      StorageService.getPlayerAvatar(),
      StorageService.getProfile(),
      StorageService.getStats(),
    ]).then((results) => {
          'name': results[0] as String,
          'avatar': results[1] as String,
          'profile': results[2] as PlayerProfile,
          'stats': results[3] as GameStats,
        });
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                ),
              );
            }

            final playerName = snapshot.data!['name'] as String;
            final currentAvatar = snapshot.data!['avatar'] as String;
            final profile = snapshot.data!['profile'] as PlayerProfile;
            final unlockedSet = Set<String>.from(profile.unlockedAchievements);

            if (!_isEditingName && _nameController.text.isEmpty) {
              _nameController.text = playerName;
            }

            final xpCurrent = profile.xp % 500;
            final xpPercent = ((xpCurrent / 500).clamp(0.0, 1.0));

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("👤 ", style: TextStyle(fontSize: 20)),
                        Text(
                          "Player Profile & Rank",
                          style: TextStyle(
                            color: Color(0xFFFDE68A),
                            fontSize: 17,
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

                // Player Card & Level/XP Bar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                                ),
                                child: Text(currentAvatar, style: const TextStyle(fontSize: 26)),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_isEditingName)
                                    SizedBox(
                                      width: 100,
                                      height: 30,
                                      child: TextField(
                                        controller: _nameController,
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          filled: true,
                                          fillColor: const Color(0xFF1E293B),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                        ),
                                      ),
                                    )
                                  else
                                    Row(
                                      children: [
                                        Text(playerName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Color(0xFF94A3B8), size: 14),
                                          onPressed: () => setState(() => _isEditingName = true),
                                        ),
                                      ],
                                    ),
                                  Text("Level ${profile.level} Master Survivor", style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ],
                          ),
                          if (_isEditingName)
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: Color(0xFF38BDF8)),
                              onPressed: () async {
                                await StorageService.setPlayerName(_nameController.text);
                                setState(() {
                                  _isEditingName = false;
                                  _refreshData();
                                });
                                widget.onDataChanged?.call();
                              },
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("Total XP", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                                Text("${profile.xp} XP", style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 14, fontWeight: FontWeight.w900)),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // XP Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: xpPercent,
                          backgroundColor: const Color(0xFF0F172A),
                          color: const Color(0xFFF59E0B),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("XP Progress", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold)),
                          Text("$xpCurrent / 500 XP to Level ${profile.level + 1}", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Avatar Picker
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("CHOOSE AVATAR", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: WordData.avatars.map((item) {
                    final isSelected = currentAvatar == item.icon;
                    return InkWell(
                      onTap: () async {
                        SoundService.play('click');
                        await StorageService.setPlayerAvatar(item.icon);
                        setState(() => _refreshData());
                        widget.onDataChanged?.call();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0284C7).withValues(alpha: 0.3) : const Color(0xFF090D16),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? const Color(0xFF38BDF8) : Colors.white10),
                        ),
                        child: Text(item.icon, style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // Achievements List
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("ACHIEVEMENTS (${unlockedSet.length} / ${WordData.achievements.length} UNLOCKED)", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                ),
                const SizedBox(height: 6),

                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(6),
                    itemCount: WordData.achievements.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (context, idx) {
                      final ach = WordData.achievements[idx];
                      final isUnlocked = unlockedSet.contains(ach.id);
                      return Opacity(
                        opacity: isUnlocked ? 1.0 : 0.4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          child: Row(
                            children: [
                              Text(ach.icon, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ach.title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text(ach.desc, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9)),
                                  ],
                                ),
                              ),
                              if (isUnlocked)
                                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Footer
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close Profile", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
