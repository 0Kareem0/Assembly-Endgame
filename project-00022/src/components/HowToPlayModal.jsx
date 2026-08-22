import { playSound } from "../utils/sound";

export default function HowToPlayModal({ isOpen, onClose, onStartGame }) {
  if (!isOpen) return null;

  const handleClose = () => {
    playSound("click");
    onClose();
  };

  const handleStart = () => {
    playSound("click");
    onClose();
    if (onStartGame) onStartGame();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/85 backdrop-blur-md animate-pop select-none">
      <div className="w-full max-w-lg bg-slate-900 border border-slate-800 rounded-3xl p-5 sm:p-7 shadow-2xl shadow-cyan-950/50 flex flex-col max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="flex justify-between items-center pb-3 border-b border-slate-800">
          <div className="flex items-center gap-2">
            <span className="text-2xl">📖</span>
            <h2 className="text-xl sm:text-2xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-cyan-300 via-amber-200 to-indigo-300">
              How To Play
            </h2>
          </div>
          <button
            onClick={handleClose}
            className="w-8 h-8 rounded-full bg-slate-800 hover:bg-slate-700 text-slate-400 hover:text-white flex items-center justify-center transition cursor-pointer"
          >
            ✕
          </button>
        </div>

        {/* Visual Cards */}
        <div className="space-y-4 my-4">
          {/* Card 1: Objective */}
          <div className="bg-slate-950/80 border border-slate-800 rounded-2xl p-4 flex gap-3.5 items-start">
            <div className="text-3xl p-2 rounded-xl bg-cyan-950/80 border border-cyan-500/30">🎯</div>
            <div>
              <h3 className="text-sm font-bold text-cyan-300">The Objective</h3>
              <p className="text-xs text-slate-300 mt-1 leading-relaxed">
                Guess the mystery word one letter at a time to rescue the hero before the trapdoor opens!
              </p>
            </div>
          </div>

          {/* Card 2: Timer & Countdown */}
          <div className="bg-slate-950/80 border border-slate-800 rounded-2xl p-4 flex gap-3.5 items-start">
            <div className="text-3xl p-2 rounded-xl bg-amber-950/80 border border-amber-500/30">⏱️</div>
            <div>
              <h3 className="text-sm font-bold text-amber-300">Timer & Start Mechanics</h3>
              <p className="text-xs text-slate-300 mt-1 leading-relaxed">
                The timer is <strong>paused by default</strong>. It only starts after you click <strong>Start Game</strong> and complete the <strong>3-2-1 GO!</strong> countdown sequence.
              </p>
            </div>
          </div>

          {/* Card 3: Scoring & Streaks */}
          <div className="bg-slate-950/80 border border-slate-800 rounded-2xl p-4 flex gap-3.5 items-start">
            <div className="text-3xl p-2 rounded-xl bg-emerald-950/80 border border-emerald-500/30">⚡</div>
            <div>
              <h3 className="text-sm font-bold text-emerald-300">Scoring & Multipliers</h3>
              <p className="text-xs text-slate-300 mt-1 leading-relaxed">
                Earn bonus points for solving words quickly and keeping your <strong>Win Streak 🔥</strong> alive! Every consecutive win adds a 20% score multiplier.
              </p>
            </div>
          </div>

          {/* Card 4: Controls */}
          <div className="bg-slate-950/80 border border-slate-800 rounded-2xl p-4 flex gap-3.5 items-start">
            <div className="text-3xl p-2 rounded-xl bg-purple-950/80 border border-purple-500/30">⌨️</div>
            <div>
              <h3 className="text-sm font-bold text-purple-300">Controls</h3>
              <p className="text-xs text-slate-300 mt-1 leading-relaxed">
                Tap keys on the virtual keyboard or type directly using your physical desktop/laptop keyboard (<kbd className="px-1 bg-slate-800 border rounded">A-Z</kbd>).
              </p>
            </div>
          </div>
        </div>

        {/* Footer Actions */}
        <div className="pt-3 border-t border-slate-800 flex justify-between items-center">
          <button
            onClick={handleClose}
            className="text-xs text-slate-400 hover:text-white transition cursor-pointer"
          >
            Close Guide
          </button>
          <button
            onClick={handleStart}
            className="bg-gradient-to-r from-cyan-400 to-blue-500 hover:from-cyan-300 hover:to-blue-400 text-slate-950 font-extrabold text-xs py-2.5 px-6 rounded-xl transition cursor-pointer shadow"
          >
            START GAME NOW 🎮
          </button>
        </div>
      </div>
    </div>
  );
}
