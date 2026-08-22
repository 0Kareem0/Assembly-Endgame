import { playSound } from "../utils/sound";

export default function GameHUD({
  timeTaken,
  currentStreak,
  onPause,
  musicMuted,
  sfxMuted,
  onToggleMusic,
  onToggleSfx,
}) {
  const handleAction = (callback) => {
    playSound("click");
    callback();
  };

  return (
    <div className="w-full flex justify-between items-center mb-3 select-none">
      {/* Pause & Audio Controls */}
      <div className="flex items-center gap-1.5">
        <button
          onClick={() => handleAction(onPause)}
          className="px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800 hover:border-cyan-500/50 text-white font-extrabold text-xs flex items-center gap-1.5 transition cursor-pointer shadow"
          title="Pause Game"
        >
          <span>⏸️</span>
          <span className="hidden sm:inline">Pause</span>
        </button>
        <button
          onClick={onToggleMusic}
          className="h-8 px-2.5 rounded-xl bg-slate-900 border border-slate-800 text-slate-300 flex items-center justify-center gap-1 text-xs transition cursor-pointer"
          title={musicMuted ? "Unmute Ambient Soundtrack" : "Mute Ambient Soundtrack"}
        >
          <span>{musicMuted ? "🔇" : "🎵"}</span>
          {!musicMuted && (
            <div className="flex items-end gap-0.5 h-3">
              <span className="w-0.5 bg-cyan-400 animate-pulse h-full" />
              <span className="w-0.5 bg-amber-400 animate-pulse h-2/3" />
              <span className="w-0.5 bg-purple-400 animate-pulse h-4/5" />
            </div>
          )}
        </button>
        <button
          onClick={onToggleSfx}
          className="w-8 h-8 rounded-xl bg-slate-900 border border-slate-800 text-slate-300 flex items-center justify-center text-xs transition cursor-pointer"
          title={sfxMuted ? "Unmute SFX" : "Mute SFX"}
        >
          {sfxMuted ? "🔕" : "🔊"}
        </button>
      </div>

      {/* Live Timer & Streak */}
      <div className="flex items-center gap-2 sm:gap-3 text-xs font-bold">
        <span className="bg-slate-900 border border-slate-800 px-3 py-1.5 rounded-xl text-cyan-400 font-mono flex items-center gap-1 shadow">
          <span>⏱️</span>
          <span>{timeTaken}s</span>
        </span>
        <span className="bg-amber-950/70 border border-amber-500/40 text-amber-300 px-3 py-1.5 rounded-xl flex items-center gap-1 shadow">
          <span>🔥</span>
          <span>Streak: {currentStreak}</span>
        </span>
      </div>
    </div>
  );
}
