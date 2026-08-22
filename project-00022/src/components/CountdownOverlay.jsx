import { useState, useEffect } from "react";
import { playSound } from "../utils/sound";

export default function CountdownOverlay({ onComplete }) {
  const [count, setCount] = useState(3);

  useEffect(() => {
    if (count > 0) {
      playSound("count");
      const timer = setTimeout(() => {
        setCount((prev) => prev - 1);
      }, 850);
      return () => clearTimeout(timer);
    } else {
      playSound("go");
      const timer = setTimeout(() => {
        onComplete();
      }, 500);
      return () => clearTimeout(timer);
    }
  }, [count, onComplete]);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/85 backdrop-blur-xl animate-pop select-none">
      <div className="text-center">
        {count > 0 ? (
          <div key={count} className="animate-pop flex flex-col items-center">
            <div className="text-8xl sm:text-9xl font-black text-transparent bg-clip-text bg-gradient-to-r from-amber-300 via-yellow-200 to-cyan-300 drop-shadow-[0_0_35px_rgba(245,158,11,0.5)]">
              {count}
            </div>
            <div className="text-sm font-extrabold uppercase tracking-widest text-slate-400 mt-4">
              Get Ready...
            </div>
          </div>
        ) : (
          <div className="animate-pop flex flex-col items-center">
            <div className="text-7xl sm:text-9xl font-black text-transparent bg-clip-text bg-gradient-to-r from-emerald-400 via-teal-300 to-cyan-400 drop-shadow-[0_0_40px_rgba(16,185,129,0.7)]">
              GO!
            </div>
            <div className="text-sm font-extrabold uppercase tracking-widest text-emerald-300 mt-4">
              Timer Started!
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
