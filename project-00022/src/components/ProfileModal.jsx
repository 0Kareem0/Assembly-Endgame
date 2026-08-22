import { useState } from "react";
import {
  AVATARS,
  ACHIEVEMENTS,
  getPlayerName,
  setPlayerName,
  getPlayerAvatar,
  setPlayerAvatar,
  getProfileData,
} from "../utils/storage";
import { playSound } from "../utils/sound";

export default function ProfileModal({ isOpen, onClose, onDataChange }) {
  const [editingName, setEditingName] = useState(false);
  const [nameInput, setNameInput] = useState(() => getPlayerName());
  const [currentAvatar, setCurrentAvatar] = useState(() => getPlayerAvatar());

  if (!isOpen) return null;

  const profile = getProfileData();
  const unlocked = new Set(profile.unlockedAchievements || []);

  const xpCurrent = profile.xp % 500;
  const xpPercent = Math.min(100, Math.round((xpCurrent / 500) * 100));

  const handleSaveName = (e) => {
    e.preventDefault();
    if (nameInput.trim()) {
      setPlayerName(nameInput.trim());
      setEditingName(false);
      playSound("click");
      if (onDataChange) onDataChange();
    }
  };

  const handleSelectAvatar = (icon) => {
    setCurrentAvatar(icon);
    setPlayerAvatar(icon);
    playSound("click");
    if (onDataChange) onDataChange();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/85 backdrop-blur-md animate-pop select-none">
      <div className="w-full max-w-lg bg-slate-900 border border-slate-800 rounded-3xl p-5 sm:p-7 shadow-2xl shadow-cyan-950/50 flex flex-col max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="flex justify-between items-center pb-3 border-b border-slate-800">
          <div className="flex items-center gap-2">
            <span className="text-2xl">👤</span>
            <h2 className="text-xl sm:text-2xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-amber-300 via-cyan-200 to-indigo-300">
              Player Profile & Rank
            </h2>
          </div>
          <button
            onClick={() => {
              playSound("click");
              onClose();
            }}
            className="w-8 h-8 rounded-full bg-slate-800 hover:bg-slate-700 text-slate-400 hover:text-white flex items-center justify-center transition cursor-pointer"
          >
            ✕
          </button>
        </div>

        {/* Profile Card & Level/XP Bar */}
        <div className="my-4 p-4 bg-slate-950/80 border border-slate-800 rounded-2xl flex flex-col gap-3">
          <div className="flex justify-between items-center">
            <div className="flex items-center gap-3">
              <div className="text-4xl p-2.5 bg-slate-900 border border-cyan-500/40 rounded-2xl shadow">
                {currentAvatar}
              </div>
              <div>
                {editingName ? (
                  <form onSubmit={handleSaveName} className="flex gap-2 items-center">
                    <input
                      type="text"
                      maxLength={15}
                      value={nameInput}
                      onChange={(e) => setNameInput(e.target.value)}
                      className="bg-slate-900 border border-cyan-500 rounded-lg px-2.5 py-1 text-xs text-white font-bold focus:outline-none"
                      autoFocus
                    />
                    <button
                      type="submit"
                      className="bg-cyan-500 text-slate-950 font-bold px-2.5 py-1 rounded-lg text-xs hover:bg-cyan-400 transition cursor-pointer"
                    >
                      Save
                    </button>
                  </form>
                ) : (
                  <div className="flex items-center gap-2">
                    <span className="font-extrabold text-white text-base">{getPlayerName()}</span>
                    <button
                      onClick={() => setEditingName(true)}
                      className="text-xs text-slate-400 hover:text-cyan-300 cursor-pointer"
                    >
                      ✏️
                    </button>
                  </div>
                )}
                <div className="text-xs text-cyan-400 font-extrabold mt-0.5">
                  Level {profile.level} Master Survivor
                </div>
              </div>
            </div>

            <div className="text-right">
              <div className="text-xs text-slate-400 font-medium">Total XP</div>
              <div className="text-lg font-black text-amber-300">{profile.xp} XP</div>
            </div>
          </div>

          {/* XP Progress Bar */}
          <div className="w-full bg-slate-900 rounded-full h-3 overflow-hidden p-0.5 border border-slate-800 mt-1">
            <div
              className="h-full rounded-full bg-gradient-to-r from-amber-400 via-cyan-400 to-indigo-500 transition-all duration-500"
              style={{ width: `${xpPercent}%` }}
            />
          </div>
          <div className="flex justify-between text-[10px] font-bold text-slate-400 px-1">
            <span>XP Progress</span>
            <span>{xpCurrent} / 500 XP to Level {profile.level + 1}</span>
          </div>
        </div>

        {/* Avatar Selector */}
        <div className="mb-4">
          <div className="text-xs font-bold uppercase tracking-wider text-slate-400 mb-2 px-1">
            Choose Avatar
          </div>
          <div className="flex justify-between gap-2 bg-slate-950/60 p-2.5 rounded-2xl border border-slate-800">
            {AVATARS.map((item) => (
              <button
                key={item.id}
                onClick={() => handleSelectAvatar(item.icon)}
                className={`p-2 rounded-xl text-2xl transition cursor-pointer border ${
                  currentAvatar === item.icon
                    ? "bg-cyan-950 border-cyan-400 scale-110 shadow-lg shadow-cyan-500/20"
                    : "bg-slate-900/60 border-slate-800 hover:bg-slate-800 opacity-60 hover:opacity-100"
                }`}
                title={item.title}
              >
                {item.icon}
              </button>
            ))}
          </div>
        </div>

        {/* Achievements Grid */}
        <div className="flex-1 overflow-y-auto mb-2">
          <div className="text-xs font-bold uppercase tracking-wider text-slate-400 mb-2 px-1">
            Achievements ({unlocked.size} / {ACHIEVEMENTS.length} Unlocked)
          </div>

          <div className="grid grid-cols-2 gap-2">
            {ACHIEVEMENTS.map((ach) => {
              const isUnlocked = unlocked.has(ach.id);
              return (
                <div
                  key={ach.id}
                  className={`p-3 rounded-2xl border transition flex items-start gap-2.5 ${
                    isUnlocked
                      ? "bg-slate-950/80 border-amber-500/40 shadow-sm"
                      : "bg-slate-950/40 border-slate-800/60 opacity-40 grayscale"
                  }`}
                >
                  <div className="text-2xl p-1.5 rounded-xl bg-slate-900 border border-slate-800">
                    {ach.icon}
                  </div>
                  <div>
                    <div className="text-xs font-extrabold text-white">{ach.title}</div>
                    <div className="text-[10px] text-slate-400 leading-tight mt-0.5">{ach.desc}</div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Footer */}
        <div className="pt-3 border-t border-slate-800 flex justify-end">
          <button
            onClick={() => {
              playSound("click");
              onClose();
            }}
            className="bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold text-xs py-2.5 px-6 rounded-xl transition cursor-pointer"
          >
            Close Profile
          </button>
        </div>
      </div>
    </div>
  );
}
