const LOCAL_STORAGE_SCORES_KEY = "hangman_leaderboard_scores_v1";
const LOCAL_STORAGE_STATS_KEY = "hangman_leaderboard_stats_v1";
const LOCAL_STORAGE_NAME_KEY = "hangman_player_name_v1";

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

    // Also update name in scores list for the latest entry if any
    const { scores, stats } = getLeaderboardData();
    if (scores.length > 0) {
      scores[0].name = trimmed;
      localStorage.setItem(LOCAL_STORAGE_SCORES_KEY, JSON.stringify(scores));
    }
    return { scores, stats };
  } catch {
    return null;
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

export function saveGameResult({ won, score, timeTaken, playerName }) {
  try {
    const name = playerName || getPlayerName();
    const { scores, stats } = getLeaderboardData();

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

    let updatedScores = [...scores];
    if (won && score > 0) {
      updatedScores.push({
        id: Date.now(),
        name,
        score,
        timeTaken,
        streak: currentStreak,
        date: new Date().toLocaleDateString(),
      });
      // Sort high scores descending
      updatedScores.sort((a, b) => b.score - a.score);
      updatedScores = updatedScores.slice(0, 10);
    }

    localStorage.setItem(LOCAL_STORAGE_SCORES_KEY, JSON.stringify(updatedScores));
    localStorage.setItem(LOCAL_STORAGE_STATS_KEY, JSON.stringify(updatedStats));

    return { scores: updatedScores, stats: updatedStats };
  } catch {
    return null;
  }
}

export function clearLeaderboardData() {
  try {
    localStorage.removeItem(LOCAL_STORAGE_SCORES_KEY);
    localStorage.removeItem(LOCAL_STORAGE_STATS_KEY);
  } catch {
    // Ignore error
  }
}
