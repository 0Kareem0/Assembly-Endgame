import { playSound } from "../utils/sound";

export default function MainMenu({
  onStartGame,
  onOpenHowToPlay,
  onOpenProfile,
  onOpenLeaderboard,
  onOpenSettings,
  musicMuted,
  sfxMuted,
  onToggleMusic,
  onToggleSfx,
  profile,
  avatar,
  playerName,
}) {
  const handleAction = (callback) => {
    playSound("click");
    callback();
  };

  return (
    <div className="w-full max-w-md bg-slate-950/85 backdrop-blur-xl border border-slate-800/90 rounded-3xl p-6 sm:p-8 shadow-2xl shadow-cyan-950/40 flex flex-col items-center select-none animate-pop my-auto">
      {/* Top Quick Bar */}
      <div className="w-full flex justify-between items-center mb-6">
        {/* Profile Badge */}
        <button
          onClick={() => handleAction(onOpenProfile)}
          className="flex items-center gap-2 px-3 py-1.5 rounded-2xl bg-slate-900 border border-slate-800 hover:border-cyan-500/50 transition cursor-pointer"
        >
          <span className="text-xl">{avatar}</span>
          <div className="text-left">
            <div className="text-xs font-bold text-white max-w-[100px] truncate">{playerName}</div>
            <div className="text-[10px] text-cyan-400 font-extrabold">Lvl {profile.level}</div>
          </div>
        </button>

        {/* Sound Toggles */}
        <div className="flex items-center gap-1.5">
          <button
            onClick={onToggleMusic}
            title={musicMuted ? "Unmute Music" : "Mute Music"}
            className="w-9 h-9 rounded-xl bg-slate-900 border border-slate-800 hover:bg-slate-800 text-slate-300 flex items-center justify-center text-sm transition cursor-pointer"
          >
            {musicMuted ? "🔇" : "🎵"}
          </button>
          <button
            onClick={onToggleSfx}
            title={sfxMuted ? "Unmute SFX" : "Mute SFX"}
            className="w-9 h-9 rounded-xl bg-slate-900 border border-slate-800 hover:bg-slate-800 text-slate-300 flex items-center justify-center text-sm transition cursor-pointer"
          >
            {sfxMuted ? "🔕" : "🔊"}
          </button>
        </div>
      </div>

      {/* Main Title Badge */}
      <div className="text-center mb-8">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-cyan-950/80 border border-cyan-500/30 text-cyan-400 text-xs font-bold uppercase tracking-wider mb-2">
          <span className="w-2 h-2 rounded-full bg-amber-400 animate-ping" />
          Ready For Challenge
        </div>
        <h1 className="text-3xl sm:text-5xl font-black text-transparent bg-clip-text bg-gradient-to-r from-amber-200 via-cyan-200 to-indigo-200 tracking-tight">
          Hangman Escape
        </h1>
        <p className="text-slate-400 text-xs sm:text-sm mt-1">
          Solve mystery words to escape the trapdoor!
        </p>
      </div>

      {/* Main Menu Action Buttons */}
      <div className="w-full flex flex-col gap-3">
        {/* START GAME BUTTON */}
        <button
          onClick={() => handleAction(onStartGame)}
          className="w-full bg-gradient-to-r from-cyan-400 via-blue-500 to-indigo-600 hover:from-cyan-300 hover:to-indigo-500 text-slate-950 font-black text-lg py-4 px-6 rounded-2xl shadow-xl shadow-cyan-500/25 transition-all duration-200 hover:scale-105 active:scale-95 flex items-center justify-center gap-3 cursor-pointer border border-cyan-300/40"
        >
          <span className="text-2xl">🎮</span>
          <span>START GAME</span>
        </button>

        {/* HOW TO PLAY */}
        <button
          onClick={() => handleAction(onOpenHowToPlay)}
          className="w-full bg-slate-900 hover:bg-slate-850 border border-slate-800 hover:border-slate-700 text-slate-200 font-bold text-sm py-3.5 px-6 rounded-2xl transition-all duration-200 hover:scale-[1.02] flex items-center justify-between cursor-pointer"
        >
          <div className="flex items-center gap-3">
            <span className="text-xl">📖</span>
            <span>How To Play</span>
          </div>
          <span className="text-slate-500 text-xs">Guide & Rules ➔</span>
        </button>

        {/* PROFILE & ACHIEVEMENTS */}
        <button
          onClick={() => handleAction(onOpenProfile)}
          className="w-full bg-slate-900 hover:bg-slate-850 border border-slate-800 hover:border-slate-700 text-slate-200 font-bold text-sm py-3.5 px-6 rounded-2xl transition-all duration-200 hover:scale-[1.02] flex items-center justify-between cursor-pointer"
        >
          <div className="flex items-center gap-3">
            <span className="text-xl">👤</span>
            <span>Profile & XP</span>
          </div>
          <span className="text-cyan-400 text-xs font-bold">Lvl {profile.level} • {profile.unlockedAchievements?.length || 0} Badges ➔</span>
        </button>

        {/* LEADERBOARD */}
        <button
          onClick={() => handleAction(onOpenLeaderboard)}
          className="w-full bg-slate-900 hover:bg-slate-850 border border-slate-800 hover:border-slate-700 text-slate-200 font-bold text-sm py-3.5 px-6 rounded-2xl transition-all duration-200 hover:scale-[1.02] flex items-center justify-between cursor-pointer"
        >
          <div className="flex items-center gap-3">
            <span className="text-xl">🏆</span>
            <span>Hall of Fame</span>
          </div>
          <span className="text-amber-400 text-xs font-bold">High Scores ➔</span>
        </button>

        {/* SETTINGS */}
        <button
          onClick={() => handleAction(onOpenSettings)}
          className="w-full bg-slate-900 hover:bg-slate-850 border border-slate-800 hover:border-slate-700 text-slate-200 font-bold text-sm py-3.5 px-6 rounded-2xl transition-all duration-200 hover:scale-[1.02] flex items-center justify-between cursor-pointer"
        >
          <div className="flex items-center gap-3">
            <span className="text-xl">⚙️</span>
            <span>Settings</span>
          </div>
          <span className="text-slate-500 text-xs">Audio & FX ➔</span>
        </button>
      </div>

      {/* Footer copyright / info */}
      <div className="mt-8 text-[11px] text-slate-500 font-mono text-center">
        Hangman Escape v2.0 • Cyber Edition
      </div>
    </div>
  );
}
