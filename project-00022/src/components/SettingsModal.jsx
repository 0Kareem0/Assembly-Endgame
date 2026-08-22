import { playSound } from "../utils/sound";

export default function SettingsModal({
  isOpen,
  onClose,
  musicMuted,
  sfxMuted,
  onToggleMusic,
  onToggleSfx,
  screenShake,
  onToggleScreenShake,
}) {
  if (!isOpen) return null;

  const handleClose = () => {
    playSound("click");
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/85 backdrop-blur-md animate-pop select-none">
      <div className="w-full max-w-sm bg-slate-900 border border-slate-800 rounded-3xl p-5 sm:p-7 shadow-2xl shadow-cyan-950/50 flex flex-col">
        {/* Header */}
        <div className="flex justify-between items-center pb-3 border-b border-slate-800">
          <div className="flex items-center gap-2">
            <span className="text-2xl">⚙️</span>
            <h2 className="text-xl font-extrabold text-white">Settings</h2>
          </div>
          <button
            onClick={handleClose}
            className="w-8 h-8 rounded-full bg-slate-800 hover:bg-slate-700 text-slate-400 hover:text-white flex items-center justify-center transition cursor-pointer"
          >
            ✕
          </button>
        </div>

        {/* Options */}
        <div className="space-y-3 my-5">
          {/* Background Ambient Music */}
          <div className="flex justify-between items-center p-3.5 bg-slate-950/80 border border-slate-800 rounded-2xl">
            <div className="flex items-center gap-3">
              <span className="text-xl">{musicMuted ? "🔇" : "🎵"}</span>
              <div>
                <div className="text-xs font-bold text-white">Ambient Music</div>
                <div className="text-[10px] text-slate-400">Synthesized background audio</div>
              </div>
            </div>
            <button
              onClick={() => {
                playSound("click");
                onToggleMusic();
              }}
              className={`px-3 py-1 rounded-xl text-xs font-extrabold transition cursor-pointer ${
                musicMuted
                  ? "bg-slate-800 text-slate-400 border border-slate-700"
                  : "bg-cyan-500 text-slate-950 shadow-md shadow-cyan-500/20"
              }`}
            >
              {musicMuted ? "OFF" : "ON"}
            </button>
          </div>

          {/* Sound Effects */}
          <div className="flex justify-between items-center p-3.5 bg-slate-950/80 border border-slate-800 rounded-2xl">
            <div className="flex items-center gap-3">
              <span className="text-xl">{sfxMuted ? "🔕" : "🔊"}</span>
              <div>
                <div className="text-xs font-bold text-white">Sound Effects (SFX)</div>
                <div className="text-[10px] text-slate-400">Click & gameplay feedback</div>
              </div>
            </div>
            <button
              onClick={() => {
                playSound("click");
                onToggleSfx();
              }}
              className={`px-3 py-1 rounded-xl text-xs font-extrabold transition cursor-pointer ${
                sfxMuted
                  ? "bg-slate-800 text-slate-400 border border-slate-700"
                  : "bg-cyan-500 text-slate-950 shadow-md shadow-cyan-500/20"
              }`}
            >
              {sfxMuted ? "OFF" : "ON"}
            </button>
          </div>

          {/* Screen Shake */}
          <div className="flex justify-between items-center p-3.5 bg-slate-950/80 border border-slate-800 rounded-2xl">
            <div className="flex items-center gap-3">
              <span className="text-xl">📳</span>
              <div>
                <div className="text-xs font-bold text-white">Screen Shake FX</div>
                <div className="text-[10px] text-slate-400">Impact shake on wrong moves</div>
              </div>
            </div>
            <button
              onClick={() => {
                playSound("click");
                onToggleScreenShake();
              }}
              className={`px-3 py-1 rounded-xl text-xs font-extrabold transition cursor-pointer ${
                !screenShake
                  ? "bg-slate-800 text-slate-400 border border-slate-700"
                  : "bg-amber-400 text-slate-950 shadow-md shadow-amber-400/20"
              }`}
            >
              {screenShake ? "ON" : "OFF"}
            </button>
          </div>
        </div>

        {/* Footer */}
        <div className="pt-3 border-t border-slate-800 flex justify-end">
          <button
            onClick={handleClose}
            className="bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold text-xs py-2.5 px-6 rounded-xl transition cursor-pointer"
          >
            Done
          </button>
        </div>
      </div>
    </div>
  );
}
