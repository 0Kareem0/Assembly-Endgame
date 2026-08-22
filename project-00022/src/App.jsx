import { useState, useEffect, useCallback } from "react";
import Confetti from "react-confetti";
import HangmanCanvas from "./components/HangmanCanvas";
import LeaderboardModal from "./components/LeaderboardModal";
import { getLeaderboardData, saveGameResult } from "./utils/storage";
import { wordCategories, getRandomWord, calculateScore, getFarewellText } from "./utils";
import { playSound, getMuted, setMuted } from "./utils/sound";

export default function App() {
  const [category, setCategory] = useState("General");
  const [currentWord, setCurrentWord] = useState(() => getRandomWord("General"));
  const [guessedLetters, setGuessedLetters] = useState([]);
  const [timeTaken, setTimeTaken] = useState(0);
  const [isLeaderboardOpen, setIsLeaderboardOpen] = useState(false);
  const [muted, setMutedState] = useState(getMuted());
  const [lastScore, setLastScore] = useState(0);
  const [currentStreak, setCurrentStreak] = useState(() => getLeaderboardData().stats.currentStreak || 0);

  const maxAttempts = 8;
  const wrongGuessCount = guessedLetters.filter(
    (letter) => !currentWord.includes(letter)
  ).length;

  const attemptsRemaining = maxAttempts - wrongGuessCount;
  const gameLost = wrongGuessCount >= maxAttempts;
  const gameWon =
    currentWord.length > 0 &&
    currentWord.split("").every((letter) => guessedLetters.includes(letter));
  const gameOver = gameLost || gameWon;

  const lastGuessedLetter = guessedLetters[guessedLetters.length - 1];
  const isLastGuessIncorrect =
    lastGuessedLetter && !currentWord.includes(lastGuessedLetter);

  // Timer effect
  useEffect(() => {
    if (gameOver) return;
    const interval = setInterval(() => {
      setTimeTaken((prev) => prev + 1);
    }, 1000);
    return () => clearInterval(interval);
  }, [gameOver]);

  // Handle Game Over sound & leaderboard registration
  useEffect(() => {
    if (gameWon) {
      playSound("win");
      const score = calculateScore({
        timeTaken,
        wrongGuessCount,
        maxAttempts,
        wordLength: currentWord.length,
        streak: currentStreak,
      });
      setLastScore(score);
      const updated = saveGameResult({
        won: true,
        score,
        timeTaken,
        playerName: "Player",
      });
      if (updated && updated.stats) {
        setCurrentStreak(updated.stats.currentStreak);
      }
    } else if (gameLost) {
      playSound("loss");
      const updated = saveGameResult({
        won: false,
        score: 0,
        timeTaken,
        playerName: "Player",
      });
      if (updated && updated.stats) {
        setCurrentStreak(0);
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gameWon, gameLost]);

  // New Game reset
  const reGame = useCallback((newCategory = category) => {
    setCategory(newCategory);
    setCurrentWord(getRandomWord(newCategory));
    setGuessedLetters([]);
    setTimeTaken(0);
    setLastScore(0);
  }, [category]);

  // Handle Letter Guesses
  const handleGuessedLetters = useCallback(
    (letter) => {
      if (gameOver) return;
      if (guessedLetters.includes(letter)) return;

      const isCorrect = currentWord.includes(letter);
      if (isCorrect) {
        playSound("correct");
      } else {
        playSound("wrong");
      }

      setGuessedLetters((prev) => [...prev, letter]);
    },
    [gameOver, guessedLetters, currentWord]
  );

  // Physical Keyboard Support
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
  }, [gameOver, handleGuessedLetters, reGame]);

  // Toggle Mute
  const toggleMute = () => {
    const nextMute = !muted;
    setMuted(nextMute);
    setMutedState(nextMute);
  };

  // Letter Reveal Boxes
  const letterElements = currentWord.split("").map((letter, i) => {
    const shouldRevealLetter = gameLost || guessedLetters.includes(letter);
    const isGuessedCorrectly = guessedLetters.includes(letter);
    const isMissedLetter = gameLost && !isGuessedCorrectly;

    return (
      <span
        key={i}
        className={`w-9 h-11 sm:w-11 sm:h-13 md:w-13 md:h-15 flex items-center justify-center font-mono-code text-xl sm:text-2xl font-extrabold rounded-xl border-2 transition-all shadow-md ${
          isMissedLetter
            ? "border-rose-500 bg-rose-950/80 text-rose-400 animate-pulse"
            : isGuessedCorrectly
            ? "border-emerald-500 bg-emerald-950/80 text-emerald-300 shadow-emerald-500/20 animate-pop"
            : "border-slate-700/80 bg-slate-900/90 text-transparent shadow-inner"
        }`}
      >
        {shouldRevealLetter ? letter.toUpperCase() : ""}
      </span>
    );
  });

  // QWERTY Virtual Keyboard
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

  return (
    <main className="min-h-screen flex flex-col items-center justify-center p-3 sm:p-6 select-none w-full max-w-2xl mx-auto">
      {gameWon && <Confetti recycle={false} numberOfPieces={400} />}

      <div className="w-full bg-slate-950/85 backdrop-blur-xl border border-slate-800/90 rounded-3xl p-4 sm:p-7 shadow-2xl shadow-cyan-950/30 flex flex-col items-center">
        {/* Top Control Bar */}
        <div className="w-full flex justify-between items-center mb-3">
          {/* Mute Toggle */}
          <button
            onClick={toggleMute}
            className="px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800 text-slate-300 hover:text-white text-xs font-bold flex items-center gap-1.5 transition cursor-pointer"
          >
            {muted ? "🔇 Muted" : "🔊 Sound On"}
          </button>

          {/* Live Timer & Streak */}
          <div className="flex items-center gap-3 text-xs font-bold">
            <span className="bg-slate-900 border border-slate-800 px-3 py-1.5 rounded-xl text-cyan-400 font-mono">
              ⏱️ {timeTaken}s
            </span>
            <span className="bg-amber-950/60 border border-amber-500/40 text-amber-300 px-3 py-1.5 rounded-xl">
              🔥 Streak: {currentStreak}
            </span>
          </div>

          {/* Leaderboard Trigger */}
          <button
            onClick={() => setIsLeaderboardOpen(true)}
            className="px-3 py-1.5 rounded-xl bg-gradient-to-r from-amber-500 to-yellow-500 hover:from-amber-400 hover:to-yellow-400 text-slate-950 text-xs font-extrabold flex items-center gap-1 transition shadow-md shadow-amber-500/20 cursor-pointer"
          >
            🏆 Stats
          </button>
        </div>

        {/* Header Title */}
        <header className="text-center w-full mb-2">
          <h1 className="text-2xl sm:text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-amber-200 via-cyan-200 to-indigo-200 tracking-tight">
            Stickman Hangman
          </h1>
          <p className="text-slate-400 text-xs sm:text-sm mt-1 max-w-md mx-auto">
            Guess the mystery word to save the stickman before the trapdoor drops!
          </p>

          {/* Category Selector Tabs */}
          <div className="flex justify-center flex-wrap gap-1.5 mt-3">
            {Object.keys(wordCategories).map((cat) => (
              <button
                key={cat}
                onClick={() => reGame(cat)}
                className={`px-3 py-1 rounded-full text-xs font-bold transition cursor-pointer border ${
                  category === cat
                    ? "bg-cyan-500 text-slate-950 border-cyan-400 shadow-md shadow-cyan-500/20"
                    : "bg-slate-900/80 text-slate-400 border-slate-800 hover:text-white"
                }`}
              >
                {cat}
              </button>
            ))}
          </div>
        </header>

        {/* Vector Gallows Character Illustration */}
        <HangmanCanvas
          wrongGuessCount={wrongGuessCount}
          maxAttempts={maxAttempts}
          gameWon={gameWon}
          gameLost={gameLost}
        />

        {/* Dynamic Status Section */}
        <section className="w-full max-w-md min-h-[64px] flex items-center justify-center my-1">
          {gameWon && (
            <div className="w-full animate-pop bg-gradient-to-r from-emerald-900/90 to-teal-900/90 border-2 border-emerald-400/80 text-emerald-100 rounded-2xl p-3 text-center shadow-lg shadow-emerald-950">
              <h2 className="text-base sm:text-lg font-bold text-emerald-300">
                🎉 Hero Rescued! Score: {lastScore} pts
              </h2>
              <p className="text-xs text-emerald-200/90 mt-0.5">
                Awesome speed! You saved him in {timeTaken} seconds!
              </p>
            </div>
          )}

          {gameLost && (
            <div className="w-full animate-shake bg-gradient-to-r from-rose-950/90 to-red-900/90 border-2 border-rose-500/80 text-rose-100 rounded-2xl p-3 text-center shadow-lg shadow-rose-950">
              <h2 className="text-base sm:text-lg font-bold text-rose-300">
                💀 Game Over! The word was: <span className="underline uppercase font-mono">{currentWord}</span>
              </h2>
              <p className="text-xs text-rose-200/90 mt-0.5">
                The trapdoor dropped! Don't give up, try another round!
              </p>
            </div>
          )}

          {!gameOver && isLastGuessIncorrect && (
            <div className="w-full animate-pop bg-amber-950/80 border-2 border-dashed border-amber-500/60 text-amber-200 rounded-2xl p-2.5 text-center text-xs font-medium italic flex items-center justify-center gap-2">
              <span>⚠️</span>
              <span>{getFarewellText(wrongGuessCount)}</span>
            </div>
          )}

          {!gameOver && !isLastGuessIncorrect && (
            <div className="w-full bg-slate-900/60 border border-slate-800/60 text-slate-400 rounded-2xl p-2 text-center text-xs italic">
              Tap or type letters to save the stickman... ({attemptsRemaining} attempts left)
            </div>
          )}
        </section>

        {/* Word Mystery Letter Boxes */}
        <section className="flex justify-center flex-wrap gap-1.5 sm:gap-2 my-3 max-w-full px-1">
          {letterElements}
        </section>

        {/* Onscreen Virtual QWERTY Keyboard */}
        <section className="w-full max-w-md mx-auto mt-2 flex flex-col gap-1.5 sm:gap-2 px-1">
          {keyboardRows.map((row, rowIndex) => (
            <div key={rowIndex} className="flex justify-center gap-1 sm:gap-1.5 w-full">
              {row.map((letter) => renderKeyButton(letter))}
            </div>
          ))}
        </section>

        {/* New Game Button */}
        {gameOver && (
          <section className="mt-5 w-full flex justify-center animate-pop">
            <button
              onClick={() => reGame()}
              className="bg-gradient-to-r from-cyan-400 to-blue-500 hover:from-cyan-300 hover:to-blue-400 text-slate-950 font-extrabold text-sm sm:text-base py-3 px-8 rounded-2xl shadow-lg shadow-cyan-500/25 transition-all duration-200 hover:scale-105 active:scale-95 flex items-center gap-2 cursor-pointer border border-cyan-300/50"
            >
              <span>Play Again</span>
              <span className="text-xs font-normal opacity-80">(Press Enter ↵)</span>
            </button>
          </section>
        )}
      </div>

      {/* Leaderboard Modal */}
      <LeaderboardModal
        isOpen={isLeaderboardOpen}
        onClose={() => setIsLeaderboardOpen(false)}
      />
    </main>
  );
}