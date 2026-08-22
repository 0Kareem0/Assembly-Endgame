const LOCAL_STORAGE_SCORES_KEY = "hangman_leaderboard_scores_v1";
const LOCAL_STORAGE_STATS_KEY = "hangman_leaderboard_stats_v1";
const LOCAL_STORAGE_NAME_KEY = "hangman_player_name_v1";
const LOCAL_STORAGE_AVATAR_KEY = "hangman_player_avatar_v1";
const LOCAL_STORAGE_PROFILE_KEY = "hangman_player_profile_v1";
const LOCAL_STORAGE_SETTINGS_KEY = "hangman_player_settings_v1";

export const AVATARS = [
  { id: "hero", icon: "🤠", title: "Cowboy Hero" },
  { id: "cyber", icon: "🤖", title: "Cyber Bot" },
  { id: "ninja", icon: "🥷", title: "Shadow Ninja" },
  { id: "wizard", icon: "🧙‍♂️", title: "Arcane Wizard" },
  { id: "astronaut", icon: "👨‍🚀", title: "Space Ranger" },
  { id: "cat", icon: "🐱", title: "Cyber Cat" }
];

export const ACHIEVEMENTS = [
  { id: "first_win", title: "First Escape", desc: "Rescued the hero for the first time", icon: "🐣" },
  { id: "streak_3", title: "On Fire", desc: "Reached a 3-game win streak", icon: "🔥" },
  { id: "streak_5", title: "Unstoppable", desc: "Reached a 5-game win streak", icon: "⚡" },
  { id: "speed_demon", title: "Speed Demon", desc: "Rescued the hero in under 20 seconds", icon: "⏱️" },
  { id: "flawless", title: "Flawless Hero", desc: "Rescued with 0 wrong guesses", icon: "🛡️" },
  { id: "high_score_1000", title: "High Roller", desc: "Scored over 1,000 points in a round", icon: "👑" }
];

export function getPlayerName() {
  try {
    return localStorage.getItem(LOCAL_STORAGE_NAME_KEY) || "Player 1";
  } catch {
    return "Player 1";
  }
}

export function setPlayerName(name) {
  try {
    const trimmed = name.trim() || "Player 1";
    localStorage.setItem(LOCAL_STORAGE_NAME_KEY, trimmed);

    const { scores } = getLeaderboardData();
    if (scores.length > 0) {
      scores[0].name = trimmed;
      localStorage.setItem(LOCAL_STORAGE_SCORES_KEY, JSON.stringify(scores));
    }
  } catch {
    // Ignore error
  }
}

export function getPlayerAvatar() {
  try {
    return localStorage.getItem(LOCAL_STORAGE_AVATAR_KEY) || "🤠";
  } catch {
    return "🤠";
  }
}

export function setPlayerAvatar(avatarIcon) {
  try {
    localStorage.setItem(LOCAL_STORAGE_AVATAR_KEY, avatarIcon);
  } catch {
    // Ignore error
  }
}

export function getProfileData() {
  try {
    const raw = localStorage.getItem(LOCAL_STORAGE_PROFILE_KEY);
    return raw
      ? JSON.parse(raw)
      : { xp: 0, level: 1, unlockedAchievements: [] };
  } catch {
    return { xp: 0, level: 1, unlockedAchievements: [] };
  }
}

export function getLeaderboardData() {
  try {
    const scoresRaw = localStorage.getItem(LOCAL_STORAGE_SCORES_KEY);
    const statsRaw = localStorage.getItem(LOCAL_STORAGE_STATS_KEY);
    return {
      scores: scoresRaw ? JSON.parse(scoresRaw) : [],
      stats: statsRaw
        ? JSON.parse(statsRaw)
        : { gamesPlayed: 0, wins: 0, currentStreak: 0, maxStreak: 0, bestTime: null },
    };
  } catch {
    return {
      scores: [],
      stats: { gamesPlayed: 0, wins: 0, currentStreak: 0, maxStreak: 0, bestTime: null },
    };
  }
}

export function getSettings() {
  try {
    const raw = localStorage.getItem(LOCAL_STORAGE_SETTINGS_KEY);
    return raw
      ? JSON.parse(raw)
      : { screenShake: true, particleDensity: "high", musicMuted: false, sfxMuted: false };
  } catch {
    return { screenShake: true, particleDensity: "high", musicMuted: false, sfxMuted: false };
  }
}

export function saveSettings(settings) {
  try {
    localStorage.setItem(LOCAL_STORAGE_SETTINGS_KEY, JSON.stringify(settings));
  } catch {}
}

export function saveGameResult({ won, score, timeTaken, wrongGuessCount = 0 }) {
  try {
    const name = getPlayerName();
    const { scores, stats } = getLeaderboardData();
    const profile = getProfileData();

    const gamesPlayed = (stats.gamesPlayed || 0) + 1;
    const wins = won ? (stats.wins || 0) + 1 : stats.wins || 0;
    const currentStreak = won ? (stats.currentStreak || 0) + 1 : 0;
    const maxStreak = Math.max(stats.maxStreak || 0, currentStreak);
    let bestTime = stats.bestTime;
    if (won && (bestTime === null || timeTaken < bestTime)) {
      bestTime = timeTaken;
    }

    const updatedStats = {
      gamesPlayed,
      wins,
      currentStreak,
      maxStreak,
      bestTime,
    };

    // XP calculation: 150 XP for win + score / 5, 25 XP for playing
    const gainedXp = won ? 150 + Math.round(score / 5) : 25;
    let newXp = (profile.xp || 0) + gainedXp;
    let newLevel = Math.floor(newXp / 500) + 1;
    const isLevelUp = newLevel > (profile.level || 1);

    // Achievements Check
    const unlocked = new Set(profile.unlockedAchievements || []);
    const newAchievementsUnlocked = [];

    if (won && !unlocked.has("first_win")) {
      unlocked.add("first_win");
      newAchievementsUnlocked.push("first_win");
    }
    if (currentStreak >= 3 && !unlocked.has("streak_3")) {
      unlocked.add("streak_3");
      newAchievementsUnlocked.push("streak_3");
    }
    if (currentStreak >= 5 && !unlocked.has("streak_5")) {
      unlocked.add("streak_5");
      newAchievementsUnlocked.push("streak_5");
    }
    if (won && timeTaken <= 20 && !unlocked.has("speed_demon")) {
      unlocked.add("speed_demon");
      newAchievementsUnlocked.push("speed_demon");
    }
    if (won && wrongGuessCount === 0 && !unlocked.has("flawless")) {
      unlocked.add("flawless");
      newAchievementsUnlocked.push("flawless");
    }
    if (won && score >= 1000 && !unlocked.has("high_score_1000")) {
      unlocked.add("high_score_1000");
      newAchievementsUnlocked.push("high_score_1000");
    }

    const updatedProfile = {
      xp: newXp,
      level: newLevel,
      unlockedAchievements: Array.from(unlocked),
    };

    let updatedScores = [...scores];
    let isNewHighScore = false;
    if (won && score > 0) {
      if (scores.length === 0 || score > (scores[0]?.score || 0)) {
        isNewHighScore = true;
      }
      updatedScores.push({
        id: Date.now(),
        name,
        score,
        timeTaken,
        streak: currentStreak,
        date: new Date().toLocaleDateString(),
      });
      updatedScores.sort((a, b) => b.score - a.score);
      updatedScores = updatedScores.slice(0, 10);
    }

    localStorage.setItem(LOCAL_STORAGE_SCORES_KEY, JSON.stringify(updatedScores));
    localStorage.setItem(LOCAL_STORAGE_STATS_KEY, JSON.stringify(updatedStats));
    localStorage.setItem(LOCAL_STORAGE_PROFILE_KEY, JSON.stringify(updatedProfile));

    return {
      scores: updatedScores,
      stats: updatedStats,
      profile: updatedProfile,
      gainedXp,
      isLevelUp,
      isNewHighScore,
      newAchievementsUnlocked,
    };
  } catch {
    return null;
  }
}

export function clearLeaderboardData() {
  try {
    localStorage.removeItem(LOCAL_STORAGE_SCORES_KEY);
    localStorage.removeItem(LOCAL_STORAGE_STATS_KEY);
    localStorage.removeItem(LOCAL_STORAGE_PROFILE_KEY);
  } catch {}
}
