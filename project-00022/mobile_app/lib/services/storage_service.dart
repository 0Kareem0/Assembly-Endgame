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

class PlayerProfile {
  final int xp;
  final int level;
  final List<String> unlockedAchievements;

  PlayerProfile({
    required this.xp,
    required this.level,
    required this.unlockedAchievements,
  });

  Map<String, dynamic> toJson() => {
        'xp': xp,
        'level': level,
        'unlockedAchievements': unlockedAchievements,
      };

  factory PlayerProfile.fromJson(Map<String, dynamic> json) => PlayerProfile(
        xp: json['xp'] ?? 0,
        level: json['level'] ?? 1,
        unlockedAchievements: List<String>.from(json['unlockedAchievements'] ?? []),
      );
}

class GameSettings {
  final bool musicMuted;
  final bool sfxMuted;
  final bool screenShake;

  GameSettings({
    required this.musicMuted,
    required this.sfxMuted,
    required this.screenShake,
  });

  Map<String, dynamic> toJson() => {
        'musicMuted': musicMuted,
        'sfxMuted': sfxMuted,
        'screenShake': screenShake,
      };

  factory GameSettings.fromJson(Map<String, dynamic> json) => GameSettings(
        musicMuted: json['musicMuted'] ?? false,
        sfxMuted: json['sfxMuted'] ?? false,
        screenShake: json['screenShake'] ?? true,
      );
}

class ResultMeta {
  final List<ScoreEntry> scores;
  final GameStats stats;
  final PlayerProfile profile;
  final int gainedXp;
  final bool isLevelUp;
  final bool isNewHighScore;
  final List<String> newAchievementsUnlocked;

  ResultMeta({
    required this.scores,
    required this.stats,
    required this.profile,
    required this.gainedXp,
    required this.isLevelUp,
    required this.isNewHighScore,
    required this.newAchievementsUnlocked,
  });
}

class StorageService {
  static const String _scoresKey = "hangman_leaderboard_scores_v1";
  static const String _statsKey = "hangman_leaderboard_stats_v1";
  static const String _nameKey = "hangman_player_name_v1";
  static const String _avatarKey = "hangman_player_avatar_v1";
  static const String _profileKey = "hangman_player_profile_v1";
  static const String _settingsKey = "hangman_player_settings_v1";

  static Future<String> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? "Player 1";
  }

  static Future<void> setPlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = name.trim().isEmpty ? "Player 1" : name.trim();
    await prefs.setString(_nameKey, trimmed);

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
      await prefs.setString(_scoresKey, jsonEncode(scores.map((e) => e.toJson()).toList()));
    }
  }

  static Future<String> getPlayerAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarKey) ?? "🤠";
  }

  static Future<void> setPlayerAvatar(String avatarIcon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, avatarIcon);
  }

  static Future<PlayerProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) {
      return PlayerProfile(xp: 0, level: 1, unlockedAchievements: []);
    }
    try {
      return PlayerProfile.fromJson(jsonDecode(raw));
    } catch (_) {
      return PlayerProfile(xp: 0, level: 1, unlockedAchievements: []);
    }
  }

  static Future<GameSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) {
      return GameSettings(musicMuted: false, sfxMuted: false, screenShake: true);
    }
    try {
      return GameSettings.fromJson(jsonDecode(raw));
    } catch (_) {
      return GameSettings(musicMuted: false, sfxMuted: false, screenShake: true);
    }
  }

  static Future<void> saveSettings(GameSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  static Future<List<ScoreEntry>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_scoresKey);
    if (raw == null) return [];
    try {
      final List list = jsonDecode(raw);
      return list.map((e) => ScoreEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<GameStats> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_statsKey);
    if (raw == null) {
      return GameStats(gamesPlayed: 0, wins: 0, currentStreak: 0, maxStreak: 0);
    }
    try {
      return GameStats.fromJson(jsonDecode(raw));
    } catch (_) {
      return GameStats(gamesPlayed: 0, wins: 0, currentStreak: 0, maxStreak: 0);
    }
  }

  static Future<ResultMeta> saveGameResult({
    required bool won,
    required int score,
    required int timeTaken,
    int wrongGuessCount = 0,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final name = await getPlayerName();
    final scores = await getScores();
    final stats = await getStats();
    final profile = await getProfile();

    final gamesPlayed = stats.gamesPlayed + 1;
    final wins = won ? stats.wins + 1 : stats.wins;
    final currentStreak = won ? stats.currentStreak + 1 : 0;
    final maxStreak = currentStreak > stats.maxStreak ? currentStreak : stats.maxStreak;
    int? bestTime = stats.bestTime;
    if (won && (bestTime == null || timeTaken < bestTime)) {
      bestTime = timeTaken;
    }

    final updatedStats = GameStats(
      gamesPlayed: gamesPlayed,
      wins: wins,
      currentStreak: currentStreak,
      maxStreak: maxStreak,
      bestTime: bestTime,
    );

    // XP calculation: 150 for win + score / 5, 25 for loss
    final gainedXp = won ? 150 + (score ~/ 5) : 25;
    final newXp = profile.xp + gainedXp;
    final newLevel = (newXp ~/ 500) + 1;
    final isLevelUp = newLevel > profile.level;

    final unlocked = Set<String>.from(profile.unlockedAchievements);
    final newAchievementsUnlocked = <String>[];

    if (won && !unlocked.contains("first_win")) {
      unlocked.add("first_win");
      newAchievementsUnlocked.add("first_win");
    }
    if (currentStreak >= 3 && !unlocked.contains("streak_3")) {
      unlocked.add("streak_3");
      newAchievementsUnlocked.add("streak_3");
    }
    if (currentStreak >= 5 && !unlocked.contains("streak_5")) {
      unlocked.add("streak_5");
      newAchievementsUnlocked.add("streak_5");
    }
    if (won && timeTaken <= 20 && !unlocked.contains("speed_demon")) {
      unlocked.add("speed_demon");
      newAchievementsUnlocked.add("speed_demon");
    }
    if (won && wrongGuessCount == 0 && !unlocked.contains("flawless")) {
      unlocked.add("flawless");
      newAchievementsUnlocked.add("flawless");
    }
    if (won && score >= 1000 && !unlocked.contains("high_score_1000")) {
      unlocked.add("high_score_1000");
      newAchievementsUnlocked.add("high_score_1000");
    }

    final updatedProfile = PlayerProfile(
      xp: newXp,
      level: newLevel,
      unlockedAchievements: unlocked.toList(),
    );

    final updatedScores = List<ScoreEntry>.from(scores);
    bool isNewHighScore = false;

    if (won && score > 0) {
      if (scores.isEmpty || score > scores[0].score) {
        isNewHighScore = true;
      }
      final now = DateTime.now();
      final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      updatedScores.add(ScoreEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        score: score,
        timeTaken: timeTaken,
        streak: currentStreak,
        date: dateStr,
      ));

      updatedScores.sort((a, b) => b.score.compareTo(a.score));
      if (updatedScores.length > 10) {
        updatedScores.removeRange(10, updatedScores.length);
      }
    }

    await prefs.setString(_scoresKey, jsonEncode(updatedScores.map((e) => e.toJson()).toList()));
    await prefs.setString(_statsKey, jsonEncode(updatedStats.toJson()));
    await prefs.setString(_profileKey, jsonEncode(updatedProfile.toJson()));

    return ResultMeta(
      scores: updatedScores,
      stats: updatedStats,
      profile: updatedProfile,
      gainedXp: gainedXp,
      isLevelUp: isLevelUp,
      isNewHighScore: isNewHighScore,
      newAchievementsUnlocked: newAchievementsUnlocked,
    );
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoresKey);
    await prefs.remove(_statsKey);
    await prefs.remove(_profileKey);
  }
}
