import { playSound } from "../utils/sound";

export default function GameOverModal({
  gameWon,
  currentWord,
  lastScore,
  timeTaken,
  resultMeta,
  onPlayAgain,
  onMainMenu,
}) {
  const handlePlayAgain = () => {
    playSound("click");
    onPlayAgain();
  };

  const handleMainMenu = () => {
    playSound("click");
    onMainMenu();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/85 backdrop-blur-md animate-pop select-none">
      <div className="w-full max-w-sm bg-slate-900 border border-slate-800 rounded-3xl p-6 shadow-2xl shadow-cyan-950/60 flex flex-col items-center text-center">
        {/* Outcome Header Banner */}
        <div
          className={`w-16 h-16 rounded-3xl flex items-center justify-center text-3xl mb-3 shadow-xl ${
            gameWon
              ? "bg-emerald-950 border border-emerald-500/50 text-emerald-400 shadow-emerald-500/30 animate-glow"
              : "bg-rose-950 border border-rose-500/50 text-rose-400 shadow-rose-500/30"
          }`}
        >
          {gameWon ? "🎉" : "💀"}
        </div>

        <h2 className="text-2xl sm:text-3xl font-black tracking-tight text-white">
          {gameWon ? "HERO RESCUED!" : "GAME OVER"}
        </h2>

        <p className="text-xs text-slate-400 mt-1">
          {gameWon
            ? "Outstanding speed and word precision!"
            : `The mystery word was "${currentWord.toUpperCase()}".`}
        </p>

        {/* High Score Alert */}
        {resultMeta?.isNewHighScore && (
          <div className="mt-3 px-3 py-1 bg-amber-500/20 border border-amber-400/50 text-amber-300 rounded-full text-xs font-black tracking-wider animate-bounce">
            👑 NEW HIGH SCORE RECORD!
          </div>
        )}

        {/* Level Up Alert */}
        {resultMeta?.isLevelUp && (
          <div className="mt-2 px-3 py-1 bg-cyan-500/20 border border-cyan-400/50 text-cyan-300 rounded-full text-xs font-black tracking-wider animate-pulse">
            ⚡ LEVEL UP! NOW LEVEL {resultMeta.profile?.level}!
          </div>
        )}

        {/* Score & XP Breakdown Grid */}
        <div className="w-full grid grid-cols-2 gap-2.5 my-5">
          <div className="bg-slate-950/80 border border-slate-800 rounded-2xl p-3">
            <div className="text-[10px] uppercase font-bold text-slate-400">Score Earned</div>
            <div className="text-lg font-black text-amber-300">{gameWon ? `${lastScore} pts` : "0 pts"}</div>
          </div>
          <div className="bg-slate-950/80 border border-slate-800 rounded-2xl p-3">
            <div className="text-[10px] uppercase font-bold text-slate-400">Time Taken</div>
            <div className="text-lg font-black text-cyan-300">{timeTaken}s</div>
          </div>
          <div className="bg-slate-950/80 border border-slate-800 rounded-2xl p-3 col-span-2 flex justify-between items-center px-4">
            <div className="text-xs font-bold text-slate-300">XP Gained</div>
            <div className="text-base font-black text-emerald-400">+{resultMeta?.gainedXp || 0} XP</div>
          </div>
        </div>

        {/* Unlocked Achievements */}
        {resultMeta?.newAchievementsUnlocked?.length > 0 && (
          <div className="w-full mb-4 p-3 bg-amber-950/40 border border-amber-500/30 rounded-2xl text-left">
            <div className="text-[10px] uppercase font-bold text-amber-400 mb-1">
              🏆 New Achievement Unlocked!
            </div>
            <div className="text-xs font-extrabold text-white">
              {resultMeta.newAchievementsUnlocked.join(", ")}
            </div>
          </div>
        )}

        {/* Actions */}
        <div className="w-full flex flex-col gap-2.5">
          <button
            onClick={handlePlayAgain}
            className="w-full bg-gradient-to-r from-cyan-400 via-blue-500 to-indigo-600 hover:from-cyan-300 hover:to-indigo-500 text-slate-950 font-black text-base py-3.5 px-6 rounded-2xl shadow-lg shadow-cyan-500/25 transition hover:scale-105 active:scale-95 cursor-pointer"
          >
            PLAY AGAIN 🔄
          </button>
          <button
            onClick={handleMainMenu}
            className="w-full bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold text-sm py-3 px-6 rounded-2xl transition cursor-pointer"
          >
            🏠 Main Menu
          </button>
        </div>
      </div>
    </div>
  );
}
