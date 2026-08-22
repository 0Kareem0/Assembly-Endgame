import { useState } from "react";
import { getLeaderboardData } from "../utils/storage";

export default function LeaderboardModal({ isOpen, onClose }) {
  const [data, setData] = useState(() => getLeaderboardData());

  if (!isOpen) return null;

  const { scores, stats } = data;
  const winRate = stats.gamesPlayed > 0 ? Math.round((stats.wins / stats.gamesPlayed) * 100) : 0;

  const handleClear = () => {
    if (window.confirm("Are you sure you want to reset your leaderboard stats?")) {
      localStorage.removeItem("hangman_leaderboard_scores_v1");
      localStorage.removeItem("hangman_leaderboard_stats_v1");
      setData(getLeaderboardData());
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-md animate-pop">
      <div className="w-full max-w-lg bg-slate-900 border border-slate-800 rounded-3xl p-5 sm:p-7 shadow-2xl shadow-cyan-950/50 flex flex-col max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="flex justify-between items-center pb-4 border-b border-slate-800">
          <div className="flex items-center gap-2">
            <span className="text-2xl">🏆</span>
            <h2 className="text-xl sm:text-2xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-amber-300 via-yellow-200 to-amber-400">
              Hall of Fame & Stats
            </h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-slate-800 hover:bg-slate-700 text-slate-400 hover:text-white flex items-center justify-center transition cursor-pointer"
            aria-label="Close leaderboard"
          >
            ✕
          </button>
        </div>

        {/* Player Stats Grid */}
        <div className="grid grid-cols-4 gap-2 my-5 text-center">
          <div className="bg-slate-950/70 border border-slate-800/80 rounded-2xl p-2.5">
            <div className="text-lg sm:text-xl font-extrabold text-cyan-400">{stats.gamesPlayed}</div>
            <div className="text-[10px] sm:text-xs text-slate-400 font-medium">Played</div>
          </div>
          <div className="bg-slate-950/70 border border-slate-800/80 rounded-2xl p-2.5">
            <div className="text-lg sm:text-xl font-extrabold text-emerald-400">{winRate}%</div>
            <div className="text-[10px] sm:text-xs text-slate-400 font-medium">Win Rate</div>
          </div>
          <div className="bg-slate-950/70 border border-slate-800/80 rounded-2xl p-2.5">
            <div className="text-lg sm:text-xl font-extrabold text-amber-400">🔥 {stats.currentStreak}</div>
            <div className="text-[10px] sm:text-xs text-slate-400 font-medium">Streak</div>
          </div>
          <div className="bg-slate-950/70 border border-slate-800/80 rounded-2xl p-2.5">
            <div className="text-lg sm:text-xl font-extrabold text-purple-400">⚡ {stats.maxStreak}</div>
            <div className="text-[10px] sm:text-xs text-slate-400 font-medium">Best Streak</div>
          </div>
        </div>

        {/* High Scores Table */}
        <div className="flex-1 overflow-y-auto my-2">
          <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400 mb-2 px-1">
            Top High Scores
          </h3>
          {scores.length === 0 ? (
            <div className="text-center py-8 text-slate-500 text-sm bg-slate-950/50 rounded-2xl border border-slate-800/50">
              No high scores recorded yet. Win games quickly to climb the rank! 🚀
            </div>
          ) : (
            <div className="bg-slate-950/70 rounded-2xl border border-slate-800 overflow-hidden">
              <table className="w-full text-left text-xs sm:text-sm">
                <thead className="bg-slate-800/60 text-slate-400 text-[10px] uppercase font-bold tracking-wider">
                  <tr>
                    <th className="py-2.5 px-3">#</th>
                    <th className="py-2.5 px-3">Player</th>
                    <th className="py-2.5 px-3 text-right">Score</th>
                    <th className="py-2.5 px-3 text-right">Time</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/60 text-slate-300">
                  {scores.map((entry, idx) => (
                    <tr key={entry.id || idx} className="hover:bg-slate-800/40 transition">
                      <td className="py-2.5 px-3 font-mono font-bold">
                        {idx === 0 ? "🥇" : idx === 1 ? "🥈" : idx === 2 ? "🥉" : `${idx + 1}`}
                      </td>
                      <td className="py-2.5 px-3 font-semibold text-white max-w-[120px] truncate">
                        {entry.name || "Anonymous Hero"}
                      </td>
                      <td className="py-2.5 px-3 text-right font-mono font-bold text-amber-300">
                        {entry.score} pts
                      </td>
                      <td className="py-2.5 px-3 text-right font-mono text-slate-400 text-xs">
                        {entry.timeTaken}s
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Footer Actions */}
        <div className="mt-5 pt-3 border-t border-slate-800 flex justify-between items-center">
          <button
            onClick={handleClear}
            className="text-xs text-rose-400/80 hover:text-rose-300 hover:underline transition cursor-pointer"
          >
            Reset Stats
          </button>
          <button
            onClick={onClose}
            className="bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold text-sm py-2 px-6 rounded-xl transition cursor-pointer"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}
