import { playSound } from "../utils/sound";

export default function IntroSplash({ onEnter }) {
  const handleStart = () => {
    playSound("click");
    onEnter();
  };

  return (
    <div className="fixed inset-0 z-50 flex flex-col items-center justify-center p-4 bg-slate-950/95 backdrop-blur-2xl animate-pop text-center select-none">
      <div className="max-w-md w-full bg-slate-900/80 border border-slate-800 rounded-3xl p-8 sm:p-12 shadow-2xl shadow-cyan-950/50 flex flex-col items-center">
        {/* Animated Glowing Logo Icon */}
        <div className="w-24 h-24 sm:w-28 sm:h-28 rounded-3xl bg-gradient-to-tr from-cyan-500 via-amber-400 to-purple-600 p-1 shadow-2xl shadow-cyan-500/40 animate-glow mb-6 flex items-center justify-center">
          <div className="w-full h-full bg-slate-950 rounded-[22px] flex items-center justify-center text-4xl sm:text-5xl">
            🪢
          </div>
        </div>

        {/* Title & Tagline */}
        <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-cyan-950/80 border border-cyan-500/40 text-cyan-300 text-xs font-extrabold uppercase tracking-widest mb-3">
          <span className="w-2 h-2 rounded-full bg-cyan-400 animate-ping" />
          Indie Word Escape
        </div>

        <h1 className="text-3xl sm:text-5xl font-black text-transparent bg-clip-text bg-gradient-to-r from-amber-200 via-cyan-200 to-purple-200 tracking-tight">
          Hangman Escape
        </h1>

        <p className="text-slate-400 text-xs sm:text-sm mt-2 leading-relaxed max-w-xs">
          Step into the trapdoor arena. Solve mystery words to rescue the hero before time runs out!
        </p>

        {/* Enter Button */}
        <button
          onClick={handleStart}
          className="mt-8 w-full bg-gradient-to-r from-cyan-400 via-blue-500 to-indigo-600 hover:from-cyan-300 hover:to-indigo-500 text-slate-950 font-black text-base py-4 px-8 rounded-2xl shadow-xl shadow-cyan-500/30 transition-all duration-300 hover:scale-105 active:scale-95 flex items-center justify-center gap-3 cursor-pointer border border-cyan-300/40"
        >
          <span>ENTER GAME ARENA</span>
          <span className="text-lg">➔</span>
        </button>

        <span className="text-[10px] text-slate-500 uppercase tracking-widest mt-4 font-mono">
          Press anywhere to start • V2.0
        </span>
      </div>
    </div>
  );
}
