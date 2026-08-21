import { useState, useEffect, useCallback } from "react";
import { languages } from "./languages";
import { getFarewellText, getRandomWord } from "./utils.js";
import Confetti from "react-confetti";

export default function App() {
  const [currentWord, setCurrentWord] = useState(() => getRandomWord());
  const [guessedLetters, setGuessedLetters] = useState([]);

  const wrongGuessCount = guessedLetters.filter(
    (letter) => !currentWord.includes(letter)
  ).length;

  const maxAttempts = languages.length - 1; // 8 attempts
  const attemptsRemaining = maxAttempts - wrongGuessCount;
  const gameLost = wrongGuessCount >= maxAttempts;
  const gameWon = currentWord
    .split("")
    .every((letter) => guessedLetters.includes(letter));
  const gameOver = gameLost || gameWon;

  const lastGuessedLetter = guessedLetters[guessedLetters.length - 1];
  const isLastGuessIncorrect =
    lastGuessedLetter && !currentWord.includes(lastGuessedLetter);

  function reGame() {
    setCurrentWord(getRandomWord());
    setGuessedLetters([]);
  }

  const handleGuessedLetters = useCallback(
    (letter) => {
      if (gameOver) return;
      setGuessedLetters((prevLetters) =>
        prevLetters.includes(letter) ? prevLetters : [...prevLetters, letter]
      );
    },
    [gameOver]
  );

  // Physical keyboard support (Desktop / Laptop)
  useEffect(() => {
    function handleKeyDown(e) {
      if (e.key === "Enter" || e.key === " ") {
        if (gameOver) {
          reGame();
        }
        return;
      }
      if (gameOver) return;
      const key = e.key.toLowerCase();
      if (key >= "a" && key <= "z" && key.length === 1) {
        handleGuessedLetters(key);
      }
    }
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [gameOver, handleGuessedLetters]);

  // Render language badges
  const languagesEle = languages.map((lang, i) => {
    const langIsLost = i < wrongGuessCount;
    const styles = {
      backgroundColor: langIsLost ? "#1e293b" : lang.backgroundColor,
      color: langIsLost ? "#64748b" : lang.color,
    };

    return (
      <span
        key={lang.name}
        style={styles}
        title={langIsLost ? `${lang.name} has been destroyed!` : `${lang.name} is safe`}
        className={`lang-chip px-2.5 py-1 sm:px-3 sm:py-1.5 text-xs font-bold rounded-full whitespace-nowrap border border-white/10 shadow-sm transition-all duration-300 select-none ${
          langIsLost ? "lost" : "hover:scale-105 hover:brightness-110"
        }`}
      >
        {lang.name}
      </span>
    );
  });

  // Render word reveal boxes
  const letterElements = currentWord.split("").map((letter, i) => {
    const shouldRevealLetter = gameLost || guessedLetters.includes(letter);
    const isGuessedCorrectly = guessedLetters.includes(letter);
    const isMissedLetter = gameLost && !isGuessedCorrectly;

    return (
      <span
        key={i}
        className={`w-9 h-11 sm:w-12 sm:h-14 md:w-14 md:h-16 flex items-center justify-center font-mono-code text-xl sm:text-2xl md:text-3xl font-extrabold rounded-xl border-2 transition-all shadow-md ${
          isMissedLetter
            ? "border-rose-500 bg-rose-950/80 text-rose-400 animate-pulse"
            : isGuessedCorrectly
            ? "border-emerald-500 bg-emerald-950/80 text-emerald-400 shadow-emerald-500/20 animate-pop"
            : "border-slate-700/80 bg-slate-900/90 text-transparent shadow-inner"
        }`}
      >
        {shouldRevealLetter ? letter.toUpperCase() : ""}
      </span>
    );
  });

  // QWERTY keyboard rows for perfect mobile & desktop layout
  const keyboardRows = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
    ["z", "x", "c", "v", "b", "n", "m"],
  ];

  const renderKeyButton = (letter) => {
    const isGuessed = guessedLetters.includes(letter);
    const isCorrect = isGuessed && currentWord.includes(letter);
    const isWrong = isGuessed && !currentWord.includes(letter);

    let keyStyle =
      "bg-[#FCBA29] hover:bg-yellow-300 active:scale-95 text-slate-950 shadow-yellow-500/20 font-bold";
    if (isCorrect) {
      keyStyle =
        "bg-emerald-500 text-slate-950 font-extrabold shadow-emerald-500/30 border-emerald-400";
    } else if (isWrong) {
      keyStyle =
        "bg-slate-850 text-slate-600 border border-slate-800/80 line-through opacity-40 cursor-not-allowed";
    }

    return (
      <button
        key={letter}
        disabled={isGuessed || gameOver}
        aria-label={`Letter ${letter}`}
        onClick={() => handleGuessedLetters(letter)}
        className={`min-w-[28px] sm:min-w-[36px] md:min-w-[42px] h-10 sm:h-11 flex-1 max-w-[44px] rounded-lg text-xs sm:text-sm md:text-base transition-all duration-150 shadow-md flex items-center justify-center uppercase select-none ${keyStyle} ${
          gameOver ? "opacity-60 cursor-not-allowed pointer-events-none" : "cursor-pointer"
        }`}
      >
        {letter}
      </button>
    );
  };

  // Defense Health Status Bar Color
  const healthPercent = Math.max(0, (attemptsRemaining / maxAttempts) * 100);
  let healthBarColor = "bg-emerald-500 shadow-emerald-500/50";
  if (attemptsRemaining <= 2) {
    healthBarColor = "bg-rose-500 shadow-rose-500/50 animate-pulse";
  } else if (attemptsRemaining <= 4) {
    healthBarColor = "bg-amber-500 shadow-amber-500/50";
  }

  return (
    <main className="min-h-screen flex flex-col items-center justify-center p-3 sm:p-6 select-none w-full max-w-2xl mx-auto">
      {gameWon && <Confetti recycle={false} numberOfPieces={350} />}

      <div className="w-full bg-slate-950/85 backdrop-blur-xl border border-slate-800/90 rounded-3xl p-4 sm:p-8 shadow-2xl shadow-cyan-950/30 flex flex-col items-center">
        {/* Header Section */}
        <header className="text-center w-full mb-4">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-cyan-950/80 border border-cyan-500/30 text-cyan-400 text-xs font-semibold uppercase tracking-wider mb-2">
            <span className="w-2 h-2 rounded-full bg-cyan-400 animate-ping" />
            Cyber Defense Edition
          </div>
          <h1 className="text-2xl sm:text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-amber-200 via-cyan-200 to-indigo-200 tracking-tight">
            Assembly Endgame
          </h1>
          <p className="text-slate-400 text-xs sm:text-sm mt-1 max-w-md mx-auto leading-relaxed">
            Guess the word in under 8 attempts to keep the programming world safe from Assembly!
          </p>

          {/* Defense Health Meter */}
          <div className="w-full max-w-xs mx-auto mt-4 bg-slate-900/90 border border-slate-800 rounded-xl p-2.5">
            <div className="flex justify-between items-center text-xs font-bold text-slate-300 mb-1.5 px-1">
              <span>🛡️ Defense Shields</span>
              <span className={attemptsRemaining <= 2 ? "text-rose-400 animate-pulse" : "text-cyan-400"}>
                {attemptsRemaining} / {maxAttempts} Safe
              </span>
            </div>
            <div className="w-full bg-slate-950 rounded-full h-2 overflow-hidden p-0.5 border border-slate-800">
              <div
                className={`h-full rounded-full transition-all duration-500 ${healthBarColor}`}
                style={{ width: `${healthPercent}%` }}
              />
            </div>
          </div>
        </header>

        {/* Dynamic Status Section */}
        <section className="w-full max-w-md min-h-[72px] flex items-center justify-center my-2">
          {gameWon && (
            <div className="w-full animate-pop bg-gradient-to-r from-emerald-900/90 to-teal-900/90 border-2 border-emerald-400/80 text-emerald-100 rounded-2xl p-3.5 text-center shadow-lg shadow-emerald-950">
              <h2 className="text-lg font-bold flex items-center justify-center gap-2 text-emerald-300">
                🎉 Victory Achieved!
              </h2>
              <p className="text-xs text-emerald-200/90 mt-0.5">
                Well done! The dev ecosystem lives to see another day!
              </p>
            </div>
          )}

          {gameLost && (
            <div className="w-full animate-shake bg-gradient-to-r from-rose-950/90 to-red-900/90 border-2 border-rose-500/80 text-rose-100 rounded-2xl p-3.5 text-center shadow-lg shadow-rose-950">
              <h2 className="text-lg font-bold flex items-center justify-center gap-2 text-rose-300">
                💀 Game Over!
              </h2>
              <p className="text-xs text-rose-200/90 mt-0.5">
                You lose! Better start learning Assembly 😭
              </p>
            </div>
          )}

          {!gameOver && isLastGuessIncorrect && (
            <div className="w-full animate-pop bg-purple-950/80 border-2 border-dashed border-purple-400/60 text-purple-200 rounded-2xl p-3 text-center shadow-md flex items-center justify-center gap-2">
              <span className="text-lg">🕯️</span>
              <span className="italic text-xs sm:text-sm font-medium">
                {getFarewellText(languages[wrongGuessCount - 1].name)}
              </span>
            </div>
          )}

          {!gameOver && !isLastGuessIncorrect && (
            <div className="w-full bg-slate-900/60 border border-slate-800/60 text-slate-400 rounded-2xl p-2.5 text-center text-xs italic">
              Type or tap letters to test your code defense...
            </div>
          )}
        </section>

        {/* Programming Languages Chips */}
        <section className="flex flex-wrap justify-center gap-1.5 sm:gap-2 my-3 max-w-md mx-auto w-full">
          {languagesEle}
        </section>

        {/* Word Mystery Tiles */}
        <section className="flex justify-center flex-wrap gap-1.5 sm:gap-2 my-4 max-w-full px-1">
          {letterElements}
        </section>

        {/* Interactive Virtual Keyboard */}
        <section className="w-full max-w-md mx-auto mt-2 flex flex-col gap-1.5 sm:gap-2 px-1">
          {keyboardRows.map((row, rowIndex) => (
            <div key={rowIndex} className="flex justify-center gap-1 sm:gap-1.5 w-full">
              {row.map((letter) => renderKeyButton(letter))}
            </div>
          ))}
        </section>

        {/* New Game Button */}
        {gameOver && (
          <section className="mt-6 w-full flex justify-center animate-pop">
            <button
              onClick={reGame}
              className="bg-gradient-to-r from-cyan-400 to-blue-500 hover:from-cyan-300 hover:to-blue-400 text-slate-950 font-extrabold text-sm sm:text-base py-3 px-8 rounded-2xl shadow-lg shadow-cyan-500/25 transition-all duration-200 hover:scale-105 active:scale-95 flex items-center gap-2 cursor-pointer border border-cyan-300/50"
            >
              <span>New Game</span>
              <span className="text-xs font-normal opacity-80">(Press Enter ↵)</span>
            </button>
          </section>
        )}
      </div>
    </main>
  );
}