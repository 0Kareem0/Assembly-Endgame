import { playSound } from "../utils/sound";

export default function PauseOverlay({ onResume, onRestart, onOpenSettings, onMainMenu }) {
  const handleAction = (callback) => {
    playSound("click");
    callback();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/85 backdrop-blur-md animate-pop select-none">
      <div className="w-full max-w-sm bg-slate-900 border border-slate-800 rounded-3xl p-6 shadow-2xl shadow-cyan-950/60 flex flex-col items-center text-center">
        <div className="w-14 h-14 rounded-2xl bg-cyan-950/80 border border-cyan-500/40 text-cyan-400 flex items-center justify-center text-2xl mb-3">
          ⏸️
        </div>
        <h2 className="text-2xl font-black text-white tracking-tight">GAME PAUSED</h2>
        <p className="text-slate-400 text-xs mt-1 mb-6">Take a breather, the stickman is waiting!</p>

        <div className="w-full flex flex-col gap-3">
          <button
            onClick={() => handleAction(onResume)}
            className="w-full bg-gradient-to-r from-cyan-400 to-blue-500 hover:from-cyan-300 hover:to-blue-400 text-slate-950 font-black text-base py-3.5 px-6 rounded-2xl shadow-lg shadow-cyan-500/20 transition hover:scale-105 cursor-pointer"
          >
            ▶ RESUME GAME
          </button>
          <button
            onClick={() => handleAction(onRestart)}
            className="w-full bg-slate-800 hover:bg-slate-700 text-white font-bold text-sm py-3 px-6 rounded-2xl transition cursor-pointer"
          >
            🔄 Restart Round
          </button>
          <button
            onClick={() => handleAction(onOpenSettings)}
            className="w-full bg-slate-800 hover:bg-slate-700 text-white font-bold text-sm py-3 px-6 rounded-2xl transition cursor-pointer"
          >
            ⚙️ Audio & Settings
          </button>
          <button
            onClick={() => handleAction(onMainMenu)}
            className="w-full bg-rose-950/40 hover:bg-rose-900/60 border border-rose-800/60 text-rose-300 font-bold text-sm py-3 px-6 rounded-2xl transition cursor-pointer"
          >
            🏠 Quit to Main Menu
          </button>
        </div>
      </div>
    </div>
  );
}
