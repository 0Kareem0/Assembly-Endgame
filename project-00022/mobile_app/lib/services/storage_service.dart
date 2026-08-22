import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreEntry {
  final int id;
  final String name;
  final int score;
  final int timeTaken;
  final int streak;
  final String date;

  ScoreEntry({
    required this.id,
    required this.name,
    required this.score,
    required this.timeTaken,
    required this.streak,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'score': score,
        'timeTaken': timeTaken,
        'streak': streak,
        'date': date,
      };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
        id: json['id'] ?? 0,
        name: json['name'] ?? 'Player 1',
        score: json['score'] ?? 0,
        timeTaken: json['timeTaken'] ?? 0,
        streak: json['streak'] ?? 0,
        date: json['date'] ?? '',
      );
}

class GameStats {
  final int gamesPlayed;
  final int wins;
  final int currentStreak;
  final int maxStreak;
  final int? bestTime;

  GameStats({
    required this.gamesPlayed,
    required this.wins,
    required this.currentStreak,
    required this.maxStreak,
    this.bestTime,
  });

  int get winRate => gamesPlayed > 0 ? ((wins / gamesPlayed) * 100).round() : 0;

  Map<String, dynamic> toJson() => {
        'gamesPlayed': gamesPlayed,
        'wins': wins,
        'currentStreak': currentStreak,
        'maxStreak': maxStreak,
        'bestTime': bestTime,
      };

  factory GameStats.fromJson(Map<String, dynamic> json) => GameStats(
        gamesPlayed: json['gamesPlayed'] ?? 0,
        wins: json['wins'] ?? 0,
        currentStreak: json['currentStreak'] ?? 0,
        maxStreak: json['maxStreak'] ?? 0,
        bestTime: json['bestTime'],
      );
}

class StorageService {
  static const String _keyScores = 'hangman_scores_v1';
  static const String _keyStats = 'hangman_stats_v1';
  static const String _keyName = 'hangman_player_name_v1';

  static Future<String> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName) ?? 'Player 1';
  }

  static Future<void> setPlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = name.trim().isEmpty ? 'Player 1' : name.trim();
    await prefs.setString(_keyName, trimmed);

    // Update latest score name if present
    final scores = await getScores();
    if (scores.isNotEmpty) {
      scores[0] = ScoreEntry(
        id: scores[0].id,
        name: trimmed,
        score: scores[0].score,
        timeTaken: scores[0].timeTaken,
        streak: scores[0].streak,
        date: scores[0].date,
      );
      final raw = jsonEncode(scores.map((e) => e.toJson()).toList());
      await prefs.setString(_keyScores, raw);
    }
  }

  static Future<List<ScoreEntry>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyScores);
    if (raw == null) return [];
    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => ScoreEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<GameStats> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyStats);
    if (raw == null) {
      return GameStats(gamesPlayed: 0, wins: 0, currentStreak: 0, maxStreak: 0);
    }
    try {
      return GameStats.fromJson(jsonDecode(raw));
    } catch (_) {
      return GameStats(gamesPlayed: 0, wins: 0, currentStreak: 0, maxStreak: 0);
    }
  }

  static Future<GameStats> saveGameResult({
    required bool won,
    required int score,
    required int timeTaken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStats = await getStats();
    final playerName = await getPlayerName();

    final gamesPlayed = currentStats.gamesPlayed + 1;
    final wins = won ? currentStats.wins + 1 : currentStats.wins;
    final currentStreak = won ? currentStats.currentStreak + 1 : 0;
    final maxStreak = currentStreak > currentStats.maxStreak ? currentStreak : currentStats.maxStreak;
    int? bestTime = currentStats.bestTime;
    if (won && (bestTime == null || timeTaken < bestTime)) {
      bestTime = timeTaken;
    }

    final newStats = GameStats(
      gamesPlayed: gamesPlayed,
      wins: wins,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      bestTime: bestTime,
    );

    await prefs.setString(_keyStats, jsonEncode(newStats.toJson()));

    if (won && score > 0) {
      final scores = await getScores();
      final now = DateTime.now();
      final dateStr = "${now.month}/${now.day}/${now.year}";

      scores.add(ScoreEntry(
        id: now.millisecondsSinceEpoch,
        name: playerName,
        score: score,
        timeTaken: timeTaken,
        streak: currentStreak,
        date: dateStr,
      ));

      scores.sort((a, b) => b.score.compareTo(a.score));
      final topScores = scores.take(10).toList();
      await prefs.setString(_keyScores, jsonEncode(topScores.map((e) => e.toJson()).toList()));
    }

    return newStats;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyScores);
    await prefs.remove(_keyStats);
  }
}
