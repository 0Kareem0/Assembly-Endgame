import { playSound } from "../utils/sound";

export default function DownloadModal({ isOpen, onClose }) {
  if (!isOpen) return null;

  // Official Google Drive download URL for Hangman Escape Android APK
  const googleDriveUrl = "https://drive.google.com/file/d/1MuOA4XXaGnSHq-kOfJPeE9GjGxPcTLbZ/view?usp=drive_link";

  const handleDownload = () => {
    playSound("click");
    window.open(googleDriveUrl, "_blank");
  };

  return (
    <div
      onClick={onClose}
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/90 backdrop-blur-md animate-pop select-none"
    >
      <div
        onClick={(e) => e.stopPropagation()}
        className="max-w-md w-full bg-slate-900 border border-slate-800 rounded-3xl p-6 shadow-2xl shadow-emerald-950/40 relative flex flex-col items-center text-center"
      >
        {/* Close Button */}
        <button
          onClick={() => {
            playSound("click");
            onClose();
          }}
          className="absolute top-4 right-4 w-8 h-8 rounded-full bg-slate-800 hover:bg-slate-700 text-slate-400 hover:text-white flex items-center justify-center text-sm font-bold transition cursor-pointer"
        >
          ✕
        </button>

        {/* Icon & Title */}
        <div className="w-16 h-16 rounded-2xl bg-gradient-to-tr from-emerald-400 to-cyan-500 p-0.5 shadow-xl shadow-emerald-500/30 mb-3 flex items-center justify-center">
          <div className="w-full h-full bg-slate-950 rounded-[14px] flex items-center justify-center text-3xl">
            📱
          </div>
        </div>

        <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-950/80 border border-emerald-500/40 text-emerald-300 text-xs font-black uppercase tracking-wider mb-2">
          <span>✨</span> Official Android App
        </div>

        <h2 className="text-2xl font-black text-white tracking-tight">
          Download Hangman Escape
        </h2>
        <p className="text-slate-400 text-xs mt-1">
          Play offline anytime with full touch haptics & native performance!
        </p>

        {/* File Specs Box */}
        <div className="w-full bg-slate-950 border border-slate-800 rounded-2xl p-4 my-4 text-left font-mono text-xs space-y-2">
          <div className="flex justify-between items-center">
            <span className="text-slate-500">File Name:</span>
            <span className="text-emerald-400 font-bold">Hangman_Escape_v1.0.apk</span>
          </div>
          <div className="flex justify-between items-center">
            <span className="text-slate-500">File Size:</span>
            <span className="text-slate-200 font-bold">50.4 MB</span>
          </div>
          <div className="flex justify-between items-center">
            <span className="text-slate-500">Host Server:</span>
            <span className="text-cyan-400 font-bold">Google Drive</span>
          </div>
          <div className="flex justify-between items-center">
            <span className="text-slate-500">Requirements:</span>
            <span className="text-amber-300 font-bold">Android 7.0+</span>
          </div>
        </div>

        {/* Download Button */}
        <button
          onClick={handleDownload}
          className="w-full bg-gradient-to-r from-emerald-400 via-teal-500 to-cyan-500 hover:from-emerald-300 hover:to-cyan-400 text-slate-950 font-black text-base py-3.5 px-6 rounded-2xl shadow-xl shadow-emerald-500/30 transition-all duration-200 hover:scale-105 active:scale-95 flex items-center justify-center gap-3 cursor-pointer border border-emerald-300/40 mb-3"
        >
          <span className="text-xl">📥</span>
          <span>DOWNLOAD FROM GOOGLE DRIVE</span>
        </button>

        {/* Installation Instructions */}
        <div className="text-[11px] text-slate-400 bg-slate-950/60 rounded-xl p-3 border border-slate-800/80 text-left space-y-1">
          <div className="font-bold text-slate-300 flex items-center gap-1">
            <span>💡</span> How to install APK on Android:
          </div>
          <ol className="list-decimal list-inside space-y-0.5 text-[10.5px]">
            <li>Tap the download button above to open Google Drive.</li>
            <li>Download <code className="text-cyan-300 font-mono">app-release.apk</code>.</li>
            <li>Enable &quot;Install from Unknown Sources&quot; if prompted.</li>
            <li>Open the file and tap <strong>Install</strong>!</li>
          </ol>
        </div>
      </div>
    </div>
  );
}
