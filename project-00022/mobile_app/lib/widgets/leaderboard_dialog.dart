import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LeaderboardDialog extends StatefulWidget {
  final VoidCallback? onDataChanged;

  const LeaderboardDialog({super.key, this.onDataChanged});

  @override
  State<LeaderboardDialog> createState() => _LeaderboardDialogState();
}

class _LeaderboardDialogState extends State<LeaderboardDialog> {
  late Future<Map<String, dynamic>> _dataFuture;
  bool _isEditingName = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _dataFuture = Future.wait([
      StorageService.getScores(),
      StorageService.getStats(),
      StorageService.getPlayerName(),
    ]).then((results) => {
          'scores': results[0] as List<ScoreEntry>,
          'stats': results[1] as GameStats,
          'name': results[2] as String,
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
          future: _dataFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
                ),
              );
            }

            final scores = snapshot.data!['scores'] as List<ScoreEntry>;
            final stats = snapshot.data!['stats'] as GameStats;
            final playerName = snapshot.data!['name'] as String;

            if (!_isEditingName && _nameController.text.isEmpty) {
              _nameController.text = playerName;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("🏆 ", style: TextStyle(fontSize: 22)),
                        Text(
                          "Hall of Fame & Stats",
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

                // Player Hero Tag Editor
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("Hero Tag: ", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                          if (_isEditingName)
                            SizedBox(
                              width: 110,
                              height: 32,
                              child: TextField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  filled: true,
                                  fillColor: const Color(0xFF1E293B),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                ),
                              ),
                            )
                          else
                            Text(
                              playerName,
                              style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          _isEditingName ? Icons.check_circle : Icons.edit,
                          color: const Color(0xFF38BDF8),
                          size: 20,
                        ),
                        onPressed: () async {
                          if (_isEditingName) {
                            await StorageService.setPlayerName(_nameController.text);
                            setState(() {
                              _isEditingName = false;
                              _refreshData();
                            });
                            widget.onDataChanged?.call();
                          } else {
                            setState(() {
                              _isEditingName = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Stats Dashboard Grid
                Row(
                  children: [
                    _buildStatCard("${stats.gamesPlayed}", "Played", const Color(0xFF38BDF8)),
                    _buildStatCard("${stats.winRate}%", "Win Rate", const Color(0xFF10B981)),
                    _buildStatCard("🔥 ${stats.currentStreak}", "Streak", const Color(0xFFF59E0B)),
                    _buildStatCard("⚡ ${stats.maxStreak}", "Best", const Color(0xFFA855F7)),
                  ],
                ),
                const SizedBox(height: 12),

                // Top Scores List
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "TOP HIGH SCORES",
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                ),
                const SizedBox(height: 6),

                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: scores.isEmpty
                      ? const Center(
                          child: Text(
                            "No high scores recorded yet.🚀",
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: scores.length,
                          separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                          itemBuilder: (context, idx) {
                            final score = scores[idx];
                            final rankEmoji = idx == 0 ? "🥇" : idx == 1 ? "🥈" : idx == 2 ? "🥉" : "#${idx + 1}";
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(rankEmoji, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(width: 8),
                                      Text(score.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("${score.score} pts", style: const TextStyle(color: Color(0xFFFDE68A), fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(width: 10),
                                      Text("${score.timeTaken}s", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 14),

                // Footer Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await StorageService.clearAll();
                        setState(() {
                          _refreshData();
                        });
                        widget.onDataChanged?.call();
                      },
                      child: const Text("Reset Stats", style: TextStyle(color: Color(0xFFF43F5E), fontSize: 12)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF090D16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
