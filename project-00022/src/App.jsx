import { useState, useEffect, useCallback } from "react";
import confetti from "canvas-confetti";
import ParticleCanvas from "./components/ParticleCanvas";
import IntroSplash from "./components/IntroSplash";
import MainMenu from "./components/MainMenu";
import CountdownOverlay from "./components/CountdownOverlay";
import GameHUD from "./components/GameHUD";
import PauseOverlay from "./components/PauseOverlay";
import HowToPlayModal from "./components/HowToPlayModal";
import ProfileModal from "./components/ProfileModal";
import SettingsModal from "./components/SettingsModal";
import GameOverModal from "./components/GameOverModal";
import LeaderboardModal from "./components/LeaderboardModal";
import HangmanCanvas from "./components/HangmanCanvas";
import { categories, getFarewellText, calculateScore } from "./utils";
import {
  saveGameResult,
  getLeaderboardData,
  getProfileData,
  getPlayerAvatar,
  getPlayerName,
  getSettings,
  saveSettings,
} from "./utils/storage";
import {
  playSound,
  startAmbientMusic,
  setMusicMuted,
  setSfxMuted,
} from "./utils/sound";

const GameState = {
  INTRO: "INTRO",
  MENU: "MENU",
  COUNTDOWN: "COUNTDOWN",
  PLAYING: "PLAYING",
  PAUSED: "PAUSED",
  GAME_OVER: "GAME_OVER",
};

export default function App() {
  const [gameState, setGameState] = useState(GameState.INTRO);
  const [activeModal, setActiveModal] = useState(null); // 'HOW_TO_PLAY', 'PROFILE', 'SETTINGS', 'LEADERBOARD'

  // Settings
  const [settings, setSettingsState] = useState(() => getSettings());

  // Category & Gameplay
  const [category, setCategory] = useState("General");
  const [currentWord, setCurrentWord] = useState("");
  const [guessedLetters, setGuessedLetters] = useState(new Set());
  const [timeTaken, setTimeTaken] = useState(0);
  const [lastScore, setLastScore] = useState(0);
  const [currentStreak, setCurrentStreak] = useState(() => getLeaderboardData().stats.currentStreak || 0);

  // Profile data
  const [profile, setProfile] = useState(() => getProfileData());
  const [avatar, setAvatar] = useState(() => getPlayerAvatar());
  const [playerName, setPlayerNameState] = useState(() => getPlayerName());

  // Result metadata (XP gained, level up, high score)
  const [resultMeta, setResultMeta] = useState(null);

  // Screen shake on wrong guess
  const [isShaking, setIsShaking] = useState(false);

  const maxAttempts = 8;
  const wrongGuessCount = Array.from(guessedLetters).filter(
    (letter) => !currentWord.includes(letter)
  ).length;

  const gameWon =
    currentWord.length > 0 &&
    currentWord.split("").every((letter) => guessedLetters.has(letter));
  const gameLost = wrongGuessCount >= maxAttempts;

  // Initialize sound settings
  useEffect(() => {
    setMusicMuted(settings.musicMuted);
    setSfxMuted(settings.sfxMuted);
  }, [settings]);

  const refreshProfileAndData = useCallback(() => {
    setProfile(getProfileData());
    setAvatar(getPlayerAvatar());
    setPlayerNameState(getPlayerName());
    setCurrentStreak(getLeaderboardData().stats.currentStreak || 0);
  }, []);

  // Prepare a fresh word state without starting timer
  const prepareNewWord = useCallback((catName) => {
    const list = categories[catName || category] || categories.General;
    const word = list[Math.floor(Math.random() * list.length)];
    setCurrentWord(word);
    setGuessedLetters(new Set());
    setTimeTaken(0);
    setLastScore(0);
  }, [category]);

  // Handle game start trigger: MENU -> COUNTDOWN
  const handleStartGame = (catName) => {
    if (catName) setCategory(catName);
    prepareNewWord(catName);
    setGameState(GameState.COUNTDOWN);
    startAmbientMusic();
  };

  // Timer Tick - ONLY active when gameState === GameState.PLAYING
  useEffect(() => {
    let timer = null;
    if (gameState === GameState.PLAYING && !gameWon && !gameLost) {
      timer = setInterval(() => {
        setTimeTaken((prev) => prev + 1);
      }, 1000);
    }
    return () => {
      if (timer) clearInterval(timer);
    };
  }, [gameState, gameWon, gameLost]);

  // Handle letter guess
  const handleGuess = useCallback(
    (letter) => {
      if (gameState !== GameState.PLAYING || gameWon || gameLost || guessedLetters.has(letter)) {
        return;
      }

      const isCorrect = currentWord.includes(letter);

      setGuessedLetters((prev) => {
        const next = new Set(prev);
        next.add(letter);
        return next;
      });

      if (isCorrect) {
        playSound("correct");
      } else {
        playSound("wrong");
        if (settings.screenShake) {
          setIsShaking(true);
          setTimeout(() => setIsShaking(false), 300);
        }
      }
    },
    [gameState, gameWon, gameLost, guessedLetters, currentWord, settings.screenShake]
  );

  // Keyboard shortcut listener
  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === "Escape") {
        if (gameState === GameState.PLAYING) setGameState(GameState.PAUSED);
        else if (gameState === GameState.PAUSED) setGameState(GameState.PLAYING);
        else if (activeModal) setActiveModal(null);
        return;
      }

      if (gameState !== GameState.PLAYING) return;

      const letter = e.key.toLowerCase();
      if (/^[a-z]$/.test(letter)) {
        handleGuess(letter);
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [gameState, activeModal, handleGuess]);

  // Game Won / Lost trigger effect
  useEffect(() => {
    if (gameState !== GameState.PLAYING) return;

    if (gameWon) {
      playSound("win");
      confetti({ particleCount: 70, spread: 80, origin: { y: 0.6 } });

      const score = calculateScore({
        timeTaken,
        wrongGuessCount,
        maxAttempts,
        wordLength: currentWord.length,
        streak: currentStreak,
      });

      const res = saveGameResult({
        won: true,
        score,
        timeTaken,
        wrongGuessCount,
      });

      queueMicrotask(() => {
        setLastScore(score);
        if (res) {
          setResultMeta(res);
          if (res.newAchievementsUnlocked?.length > 0) {
            playSound("achievement");
          }
        }
        refreshProfileAndData();
        setGameState(GameState.GAME_OVER);
      });
    } else if (gameLost) {
      playSound("loss");

      const res = saveGameResult({
        won: false,
        score: 0,
        timeTaken,
        wrongGuessCount,
      });

      queueMicrotask(() => {
        if (res) setResultMeta(res);
        refreshProfileAndData();
        setGameState(GameState.GAME_OVER);
      });
    }
  }, [gameWon, gameLost, gameState, timeTaken, wrongGuessCount, currentWord, currentStreak, refreshProfileAndData]);

  // Toggle Sound controls
  const handleToggleMusic = () => {
    const next = !settings.musicMuted;
    const updated = { ...settings, musicMuted: next };
    setSettingsState(updated);
    saveSettings(updated);
    setMusicMuted(next);
  };

  const handleToggleSfx = () => {
    const next = !settings.sfxMuted;
    const updated = { ...settings, sfxMuted: next };
    setSettingsState(updated);
    saveSettings(updated);
    setSfxMuted(next);
  };

  const handleToggleScreenShake = () => {
    const updated = { ...settings, screenShake: !settings.screenShake };
    setSettingsState(updated);
    saveSettings(updated);
  };

  // Virtual keyboard layout
  const keyboardRows = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
    ["z", "x", "c", "v", "b", "n", "m"],
  ];

  return (
    <div className="relative min-h-screen bg-slate-950 text-slate-100 flex flex-col items-center justify-center p-3 sm:p-6 overflow-x-hidden font-sans">
      {/* Background Interactive Particle Canvas */}
      <ParticleCanvas isShaking={isShaking} />

      {/* INTRO SPLASH */}
      {gameState === GameState.INTRO && (
        <IntroSplash onEnter={() => setGameState(GameState.MENU)} />
      )}

      {/* MAIN MENU */}
      {gameState === GameState.MENU && (
        <MainMenu
          onStartGame={() => handleStartGame()}
          onOpenHowToPlay={() => setActiveModal("HOW_TO_PLAY")}
          onOpenProfile={() => setActiveModal("PROFILE")}
          onOpenLeaderboard={() => setActiveModal("LEADERBOARD")}
          onOpenSettings={() => setActiveModal("SETTINGS")}
          musicMuted={settings.musicMuted}
          sfxMuted={settings.sfxMuted}
          onToggleMusic={handleToggleMusic}
          onToggleSfx={handleToggleSfx}
          profile={profile}
          avatar={avatar}
          playerName={playerName}
        />
      )}

      {/* COUNTDOWN 3-2-1 */}
      {gameState === GameState.COUNTDOWN && (
        <CountdownOverlay onComplete={() => setGameState(GameState.PLAYING)} />
      )}

      {/* GAMEPLAY ARENA */}
      {(gameState === GameState.PLAYING || gameState === GameState.PAUSED) && (
        <main className="z-10 w-full max-w-lg bg-slate-950/85 backdrop-blur-xl border border-slate-800/90 rounded-3xl p-4 sm:p-6 shadow-2xl shadow-cyan-950/50 flex flex-col items-center animate-pop my-auto">
          {/* Game HUD */}
          <GameHUD
            timeTaken={timeTaken}
            currentStreak={currentStreak}
            onPause={() => setGameState(GameState.PAUSED)}
            musicMuted={settings.musicMuted}
            sfxMuted={settings.sfxMuted}
            onToggleMusic={handleToggleMusic}
            onToggleSfx={handleToggleSfx}
          />

          {/* Category Tabs */}
          <div className="flex gap-1.5 overflow-x-auto max-w-full pb-2 mb-2 no-scrollbar">
            {Object.keys(categories).map((catName) => {
              const isSelected = category === catName;
              return (
                <button
                  key={catName}
                  onClick={() => {
                    playSound("click");
                    setCategory(catName);
                    prepareNewWord(catName);
                  }}
                  className={`px-3 py-1 rounded-xl text-xs font-bold transition whitespace-nowrap cursor-pointer ${
                    isSelected
                      ? "bg-cyan-400 text-slate-950 shadow-md shadow-cyan-400/20"
                      : "bg-slate-900 border border-slate-800 text-slate-400 hover:text-white"
                  }`}
                >
                  {catName}
                </button>
              );
            })}
          </div>

          {/* Stickman Gallows Vector SVG Canvas */}
          <div className="w-full flex justify-center my-2">
            <HangmanCanvas wrongGuessCount={wrongGuessCount} maxAttempts={maxAttempts} />
          </div>

          {/* Dynamic Status / Farewell Hint Banner */}
          <div className="my-2 min-h-[36px] flex items-center justify-center text-center">
            {wrongGuessCount > 0 && !gameWon && !gameLost ? (
              <span className="text-xs font-semibold text-amber-300 bg-amber-950/60 border border-amber-500/30 px-3 py-1 rounded-full animate-pop">
                ⚠️ {getFarewellText(wrongGuessCount)}
              </span>
            ) : (
              <span className="text-xs text-slate-400">
                Guess letters to rescue the hero ({maxAttempts - wrongGuessCount} attempts left)
              </span>
            )}
          </div>

          {/* Word Mystery Letter Boxes */}
          <div className="flex gap-2 justify-center flex-wrap my-4">
            {currentWord.split("").map((letter, idx) => {
              const isGuessed = guessedLetters.has(letter);
              return (
                <div
                  key={idx}
                  className={`w-9 h-12 sm:w-11 sm:h-14 rounded-xl flex items-center justify-center font-black text-xl sm:text-2xl border-2 transition-all duration-300 ${
                    isGuessed
                      ? "bg-emerald-950/80 border-emerald-400 text-emerald-300 shadow-md shadow-emerald-500/20"
                      : "bg-slate-900 border-slate-800 text-transparent"
                  }`}
                >
                  {isGuessed ? letter.toUpperCase() : ""}
                </div>
              );
            })}
          </div>

          {/* QWERTY Virtual Keyboard */}
          <div className="w-full space-y-1.5 mt-2">
            {keyboardRows.map((row, rowIdx) => (
              <div key={rowIdx} className="flex justify-center gap-1 sm:gap-1.5">
                {row.map((letter) => {
                  const isGuessed = guessedLetters.has(letter);
                  const isCorrect = isGuessed && currentWord.includes(letter);
                  const isWrong = isGuessed && !currentWord.includes(letter);

                  let btnStyle =
                    "bg-amber-400 hover:bg-amber-300 text-slate-950 shadow-md shadow-amber-400/20 border-b-2 border-amber-600";
                  if (isCorrect) {
                    btnStyle = "bg-emerald-500 text-slate-950 border-b-2 border-emerald-700 opacity-80";
                  } else if (isWrong) {
                    btnStyle = "bg-slate-900 text-slate-600 border border-slate-800 opacity-40 line-through";
                  }

                  return (
                    <button
                      key={letter}
                      disabled={isGuessed}
                      onClick={() => handleGuess(letter)}
                      className={`flex-1 max-w-[36px] sm:max-w-[42px] h-10 sm:h-11 rounded-xl font-black text-sm sm:text-base uppercase transition-all duration-150 active:scale-95 cursor-pointer ${btnStyle}`}
                    >
                      {letter}
                    </button>
                  );
                })}
              </div>
            ))}
          </div>
        </main>
      )}

      {/* PAUSE OVERLAY */}
      {gameState === GameState.PAUSED && (
        <PauseOverlay
          onResume={() => setGameState(GameState.PLAYING)}
          onRestart={() => handleStartGame()}
          onOpenSettings={() => setActiveModal("SETTINGS")}
          onMainMenu={() => setGameState(GameState.MENU)}
        />
      )}

      {/* GAME OVER MODAL */}
      {gameState === GameState.GAME_OVER && (
        <GameOverModal
          gameWon={gameWon}
          currentWord={currentWord}
          lastScore={lastScore}
          timeTaken={timeTaken}
          resultMeta={resultMeta}
          onPlayAgain={() => handleStartGame()}
          onMainMenu={() => setGameState(GameState.MENU)}
        />
      )}

      {/* MODALS */}
      <HowToPlayModal
        isOpen={activeModal === "HOW_TO_PLAY"}
        onClose={() => setActiveModal(null)}
        onStartGame={() => handleStartGame()}
      />

      <ProfileModal
        isOpen={activeModal === "PROFILE"}
        onClose={() => setActiveModal(null)}
        onDataChange={refreshProfileAndData}
      />

      <SettingsModal
        isOpen={activeModal === "SETTINGS"}
        onClose={() => setActiveModal(null)}
        musicMuted={settings.musicMuted}
        sfxMuted={settings.sfxMuted}
        onToggleMusic={handleToggleMusic}
        onToggleSfx={handleToggleSfx}
        screenShake={settings.screenShake}
        onToggleScreenShake={handleToggleScreenShake}
      />

      <LeaderboardModal
        isOpen={activeModal === "LEADERBOARD"}
        onClose={() => setActiveModal(null)}
        onDataChange={refreshProfileAndData}
      />
    </div>
  );
}