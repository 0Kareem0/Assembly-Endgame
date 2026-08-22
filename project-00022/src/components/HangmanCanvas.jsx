export default function HangmanCanvas({ wrongGuessCount, maxAttempts = 8, gameWon = false, gameLost = false }) {
  // Facial expression based on state
  let faceType = "neutral";
  if (gameWon) {
    faceType = "happy";
  } else if (gameLost || wrongGuessCount >= maxAttempts) {
    faceType = "dead";
  } else if (wrongGuessCount >= 5) {
    faceType = "scared";
  }

  return (
    <div className="relative flex flex-col items-center justify-center p-3 my-2 select-none">
      <div className="relative w-48 h-56 sm:w-56 sm:h-64 flex items-center justify-center bg-slate-950/60 rounded-2xl border border-slate-800/80 shadow-inner overflow-hidden">
        <svg
          viewBox="0 0 200 240"
          className="w-full h-full drop-shadow-[0_0_10px_rgba(14,165,233,0.3)]"
          aria-label="Hangman figure illustration"
        >
          {/* Base Stand (Step 1) */}
          {wrongGuessCount >= 1 && (
            <line
              x1="20"
              y1="220"
              x2="180"
              y2="220"
              stroke="#38bdf8"
              strokeWidth="5"
              strokeLinecap="round"
              className="animate-pop"
            />
          )}

          {/* Vertical Pole (Step 2) */}
          {wrongGuessCount >= 2 && (
            <line
              x1="60"
              y1="220"
              x2="60"
              y2="20"
              stroke="#38bdf8"
              strokeWidth="5"
              strokeLinecap="round"
              className="animate-pop"
            />
          )}

          {/* Top Beam & Diagonal Brace (Step 3) */}
          {wrongGuessCount >= 3 && (
            <>
              <line
                x1="57"
                y1="20"
                x2="150"
                y2="20"
                stroke="#38bdf8"
                strokeWidth="5"
                strokeLinecap="round"
                className="animate-pop"
              />
              <line
                x1="60"
                y1="50"
                x2="90"
                y2="20"
                stroke="#38bdf8"
                strokeWidth="4"
                strokeLinecap="round"
              />
            </>
          )}

          {/* Rope & Noose (Step 4) */}
          {wrongGuessCount >= 4 && (
            <line
              x1="140"
              y1="20"
              x2="140"
              y2="55"
              stroke="#f59e0b"
              strokeWidth="4"
              strokeDasharray="4 2"
              className="animate-pop"
            />
          )}

          {/* Head (Step 5) */}
          {(wrongGuessCount >= 5 || gameWon) && (
            <g className="animate-pop">
              {/* Head Circle */}
              <circle
                cx="140"
                cy="75"
                r="20"
                stroke={gameWon ? "#10b981" : gameLost ? "#ef4444" : "#f1f5f9"}
                strokeWidth="4"
                fill={gameWon ? "rgba(16,185,129,0.15)" : gameLost ? "rgba(239,68,68,0.15)" : "rgba(30,41,59,0.8)"}
              />

              {/* Eyes & Face Details */}
              {faceType === "happy" && (
                <>
                  {/* Happy Eyes ^ ^ */}
                  <path d="M 132 72 Q 135 68 138 72" stroke="#10b981" strokeWidth="2.5" fill="none" strokeLinecap="round" />
                  <path d="M 142 72 Q 145 68 148 72" stroke="#10b981" strokeWidth="2.5" fill="none" strokeLinecap="round" />
                  {/* Smile */}
                  <path d="M 133 80 Q 140 87 147 80" stroke="#10b981" strokeWidth="2.5" fill="none" strokeLinecap="round" />
                </>
              )}

              {faceType === "dead" && (
                <>
                  {/* X Eyes */}
                  <line x1="131" y1="67" x2="137" y2="73" stroke="#ef4444" strokeWidth="2.5" strokeLinecap="round" />
                  <line x1="137" y1="67" x2="131" y2="73" stroke="#ef4444" strokeWidth="2.5" strokeLinecap="round" />
                  <line x1="143" y1="67" x2="149" y2="73" stroke="#ef4444" strokeWidth="2.5" strokeLinecap="round" />
                  <line x1="149" y1="67" x2="143" y2="73" stroke="#ef4444" strokeWidth="2.5" strokeLinecap="round" />
                  {/* Frown / Tongue */}
                  <path d="M 134 84 Q 140 78 146 84" stroke="#ef4444" strokeWidth="2.5" fill="none" strokeLinecap="round" />
                </>
              )}

              {faceType === "scared" && (
                <>
                  {/* Scared Wide Eyes O O */}
                  <circle cx="134" cy="71" r="2.5" fill="#f1f5f9" />
                  <circle cx="146" cy="71" r="2.5" fill="#f1f5f9" />
                  {/* Worried Mouth */}
                  <line x1="135" y1="82" x2="145" y2="82" stroke="#f59e0b" strokeWidth="2.5" strokeLinecap="round" />
                </>
              )}

              {faceType === "neutral" && (
                <>
                  <circle cx="134" cy="71" r="2.5" fill="#f1f5f9" />
                  <circle cx="146" cy="71" r="2.5" fill="#f1f5f9" />
                  <line x1="136" y1="81" x2="144" y2="81" stroke="#f1f5f9" strokeWidth="2" strokeLinecap="round" />
                </>
              )}
            </g>
          )}

          {/* Torso / Body (Step 6) */}
          {(wrongGuessCount >= 6 || gameWon) && (
            <line
              x1="140"
              y1="95"
              x2="140"
              y2="150"
              stroke={gameWon ? "#10b981" : gameLost ? "#ef4444" : "#f1f5f9"}
              strokeWidth="4"
              strokeLinecap="round"
              className="animate-pop"
            />
          )}

          {/* Left & Right Arms (Step 7) */}
          {(wrongGuessCount >= 7 || gameWon) && (
            <>
              {gameWon ? (
                // Raised arms in victory!
                <>
                  <line x1="140" y1="110" x2="120" y2="85" stroke="#10b981" strokeWidth="4" strokeLinecap="round" className="animate-pop" />
                  <line x1="140" y1="110" x2="160" y2="85" stroke="#10b981" strokeWidth="4" strokeLinecap="round" className="animate-pop" />
                </>
              ) : (
                // Hanging arms
                <>
                  <line x1="140" y1="110" x2="115" y2="135" stroke={gameLost ? "#ef4444" : "#f1f5f9"} strokeWidth="4" strokeLinecap="round" className="animate-pop" />
                  <line x1="140" y1="110" x2="165" y2="135" stroke={gameLost ? "#ef4444" : "#f1f5f9"} strokeWidth="4" strokeLinecap="round" className="animate-pop" />
                </>
              )}
            </>
          )}

          {/* Left & Right Legs (Step 8 - Full Hang) */}
          {(wrongGuessCount >= 8 || gameWon) && (
            <>
              <line
                x1="140"
                y1="150"
                x2="120"
                y2="195"
                stroke={gameWon ? "#10b981" : "#ef4444"}
                strokeWidth="4"
                strokeLinecap="round"
                className="animate-pop"
              />
              <line
                x1="140"
                y1="150"
                x2="160"
                y2="195"
                stroke={gameWon ? "#10b981" : "#ef4444"}
                strokeWidth="4"
                strokeLinecap="round"
                className="animate-pop"
              />
            </>
          )}
        </svg>

        {/* Danger Level Tag */}
        <div className="absolute bottom-2 left-3 right-3 flex justify-between items-center text-[10px] uppercase tracking-wider font-mono font-bold text-slate-400 bg-slate-900/90 px-2.5 py-1 rounded-lg border border-slate-800">
          <span>Danger Stage:</span>
          <span className={wrongGuessCount >= 6 ? "text-rose-400 font-bold" : wrongGuessCount >= 3 ? "text-amber-400" : "text-emerald-400"}>
            {gameWon ? "SAVED! 🎉" : `${wrongGuessCount} / ${maxAttempts} Trapped`}
          </span>
        </div>
      </div>
    </div>
  );
}
