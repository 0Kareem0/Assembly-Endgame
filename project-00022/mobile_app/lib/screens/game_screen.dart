import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../models/word_data.dart';
import '../services/storage_service.dart';
import '../services/sound_service.dart';
import '../widgets/hangman_canvas.dart';
import '../widgets/qwerty_keyboard.dart';
import '../widgets/leaderboard_dialog.dart';
import '../widgets/intro_splash.dart';
import '../widgets/main_menu.dart';
import '../widgets/countdown_overlay.dart';
import '../widgets/game_hud.dart';
import '../widgets/pause_dialog.dart';
import '../widgets/how_to_play_dialog.dart';
import '../widgets/profile_dialog.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/game_over_dialog.dart';

enum AppGameState { intro, menu, countdown, playing, paused }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AppGameState _gameState = AppGameState.intro;

  String _category = 'General';
  late String _currentWord;
  final Set<String> _guessedLetters = {};
  int _timeTaken = 0;
  Timer? _timer;
  int _lastScore = 0;
  int _currentStreak = 0;

  late ConfettiController _confettiController;
  final FocusNode _focusNode = FocusNode();

  PlayerProfile _profile = PlayerProfile(xp: 0, level: 1, unlockedAchievements: []);
  String _avatar = "🤠";
  String _playerName = "Player 1";
  ResultMeta? _resultMeta;

  static const int _maxAttempts = 8;

  int get _wrongGuessCount =>
      _guessedLetters.where((letter) => !_currentWord.contains(letter)).length;

  bool get _gameLost => _wrongGuessCount >= _maxAttempts;
  bool get _gameWon =>
      _currentWord.isNotEmpty &&
      _currentWord.split('').every((letter) => _guessedLetters.contains(letter));
  bool get _gameOver => _gameLost || _gameWon;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _loadProfileData();
    _prepareNewWord('General');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final p = await StorageService.getProfile();
    final a = await StorageService.getPlayerAvatar();
    final n = await StorageService.getPlayerName();
    final s = await StorageService.getStats();

    if (mounted) {
      setState(() {
        _profile = p;
        _avatar = a;
        _playerName = n;
        _currentStreak = s.currentStreak;
      });
    }
  }

  void _prepareNewWord([String? newCategory]) {
    if (newCategory != null) {
      _category = newCategory;
    }
    setState(() {
      _currentWord = WordData.getRandomWord(_category);
      _guessedLetters.clear();
      _timeTaken = 0;
      _lastScore = 0;
    });
  }

  void _handleStartGame([String? newCategory]) {
    _prepareNewWord(newCategory);
    setState(() {
      _gameState = AppGameState.countdown;
    });
  }

  void _startLiveTimer() {
    _timer?.cancel();
    _timeTaken = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameState == AppGameState.playing && !_gameOver) {
        setState(() {
          _timeTaken++;
        });
      }
    });
  }

  void _handleLetterPressed(String letter) {
    if (_gameState != AppGameState.playing || _gameOver || _guessedLetters.contains(letter)) return;

    final isCorrect = _currentWord.contains(letter);

    setState(() {
      _guessedLetters.add(letter);
    });

    if (isCorrect) {
      SoundService.play('correct');
    } else {
      SoundService.play('wrong');
    }

    if (_gameWon) {
      _timer?.cancel();
      SoundService.play('win');
      _confettiController.play();

      final score = WordData.calculateScore(
        timeTaken: _timeTaken,
        wrongGuessCount: _wrongGuessCount,
        maxAttempts: _maxAttempts,
        wordLength: _currentWord.length,
        streak: _currentStreak,
      );

      _lastScore = score;
      StorageService.saveGameResult(
        won: true,
        score: score,
        timeTaken: _timeTaken,
        wrongGuessCount: _wrongGuessCount,
      ).then((res) {
        if (mounted) {
          setState(() {
            _resultMeta = res;
            _currentStreak = res.stats.currentStreak;
          });
          _loadProfileData();
          _showGameOverDialog();
        }
      });
    } else if (_gameLost) {
      _timer?.cancel();
      SoundService.play('loss');

      StorageService.saveGameResult(
        won: false,
        score: 0,
        timeTaken: _timeTaken,
        wrongGuessCount: _wrongGuessCount,
      ).then((res) {
        if (mounted) {
          setState(() {
            _resultMeta = res;
            _currentStreak = 0;
          });
          _loadProfileData();
          _showGameOverDialog();
        }
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialogWidget(
        gameWon: _gameWon,
        currentWord: _currentWord,
        lastScore: _lastScore,
        timeTaken: _timeTaken,
        resultMeta: _resultMeta,
        onPlayAgain: () => _handleStartGame(),
        onMainMenu: () => setState(() => _gameState = AppGameState.menu),
      ),
    );
  }

  void _openHowToPlay() {
    showDialog(
      context: context,
      builder: (context) => HowToPlayDialogWidget(
        onStartGame: () => _handleStartGame(),
      ),
    );
  }

  void _openProfile() {
    showDialog(
      context: context,
      builder: (context) => ProfileDialogWidget(
        onDataChanged: _loadProfileData,
      ),
    );
  }

  void _openLeaderboard() {
    showDialog(
      context: context,
      builder: (context) => LeaderboardDialog(
        onDataChanged: _loadProfileData,
      ),
    );
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) => SettingsDialogWidget(
        onSettingsChanged: () => setState(() {}),
      ),
    );
  }

  void _showPauseDialog() {
    setState(() => _gameState = AppGameState.paused);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PauseDialogWidget(
        onResume: () {
          Navigator.of(context).pop();
          setState(() => _gameState = AppGameState.playing);
        },
        onRestart: () {
          Navigator.of(context).pop();
          _handleStartGame();
        },
        onOpenSettings: () {
          Navigator.of(context).pop();
          _openSettings();
        },
        onMainMenu: () {
          Navigator.of(context).pop();
          setState(() => _gameState = AppGameState.menu);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey.keyLabel.toLowerCase();
          if (key == 'escape') {
            if (_gameState == AppGameState.playing) _showPauseDialog();
          } else if (key == 'enter' || key == 'space') {
            if (_gameOver) _handleStartGame();
          } else if (key.length == 1 && RegExp(r'[a-z]').hasMatch(key)) {
            _handleLetterPressed(key);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF060913),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            SafeArea(
              child: _buildBodyContent(),
            ),

            if (_gameState == AppGameState.countdown)
              CountdownOverlayWidget(
                onComplete: () {
                  setState(() => _gameState = AppGameState.playing);
                  _startLiveTimer();
                },
              ),

            // Confetti
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_gameState == AppGameState.intro) {
      return IntroSplash(
        onEnter: () => setState(() => _gameState = AppGameState.menu),
      );
    }

    if (_gameState == AppGameState.menu) {
      return MainMenuWidget(
        onStartGame: () => _handleStartGame(),
        onOpenHowToPlay: _openHowToPlay,
        onOpenProfile: _openProfile,
        onOpenLeaderboard: _openLeaderboard,
        onOpenSettings: _openSettings,
        profile: _profile,
        avatar: _avatar,
        playerName: _playerName,
        onToggleAudio: () {
          SoundService.toggleSfx();
          setState(() {});
        },
      );
    }

    // GAMEPLAY (playing or paused)
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Game HUD
          GameHUDWidget(
            timeTaken: _timeTaken,
            currentStreak: _currentStreak,
            onPause: _showPauseDialog,
            onToggleAudio: () {
              SoundService.toggleSfx();
              setState(() {});
            },
          ),

          const SizedBox(height: 6),

          // Header Title
          const Text(
            "Hangman Escape",
            style: TextStyle(
              color: Color(0xFFFDE68A),
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const Text(
            "Guess the word to save the stickman!",
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
          ),

          const SizedBox(height: 6),

          // Category Selector Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: WordData.categories.keys.map((cat) {
                final isSelected = _category == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFF38BDF8),
                    backgroundColor: const Color(0xFF0F172A),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      SoundService.play('click');
                      _handleStartGame(cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 6),

          // Gallows Canvas
          HangmanCanvas(
            wrongGuessCount: _wrongGuessCount,
            maxAttempts: _maxAttempts,
            gameWon: _gameWon,
            gameLost: _gameLost,
          ),

          const SizedBox(height: 6),

          // Dynamic Status Card
          _buildStatusCard(),

          const SizedBox(height: 6),

          // Mystery Word Letter Boxes
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_currentWord.length, (i) {
                final letter = _currentWord[i];
                final isRevealed = _gameLost || _guessedLetters.contains(letter);
                final isGuessedCorrectly = _guessedLetters.contains(letter);
                final isMissed = _gameLost && !isGuessedCorrectly;

                return Container(
                  width: 34,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(
                    color: isMissed
                        ? const Color(0xFF881337)
                        : isGuessedCorrectly
                            ? const Color(0xFF064E3B)
                            : const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isMissed
                          ? const Color(0xFFEF4444)
                          : isGuessedCorrectly
                              ? const Color(0xFF10B981)
                              : Colors.white10,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isRevealed ? letter.toUpperCase() : '',
                    style: TextStyle(
                      color: isMissed
                          ? const Color(0xFFFCA5A5)
                          : isGuessedCorrectly
                              ? const Color(0xFF6EE7B7)
                              : Colors.transparent,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // QWERTY Virtual Keyboard
          QwertyKeyboard(
            guessedLetters: _guessedLetters,
            currentWord: _currentWord,
            gameOver: _gameOver,
            onLetterPressed: _handleLetterPressed,
          ),

          if (_gameOver)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => _handleStartGame(),
                icon: const Icon(Icons.refresh, fontWeight: FontWeight.bold),
                label: const Text(
                  "Play Again",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    if (_gameWon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF064E3B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF10B981)),
        ),
        child: Column(
          children: [
            Text("🎉 Hero Rescued! Score: $_lastScore pts", style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 14, fontWeight: FontWeight.bold)),
            Text("Awesome speed! Saved in ${_timeTaken}s", style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      );
    }

    if (_gameLost) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF881337),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEF4444)),
        ),
        child: Column(
          children: [
            Text("💀 Game Over! Word: ${_currentWord.toUpperCase()}", style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 14, fontWeight: FontWeight.bold)),
            const Text("The trapdoor dropped! Try another round!", style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      );
    }

    final lastLetter = _guessedLetters.isEmpty ? null : _guessedLetters.last;
    final isLastWrong = lastLetter != null && !_currentWord.contains(lastLetter);

    if (isLastWrong) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF451A03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF59E0B)),
        ),
        child: Text(
          "⚠️ ${WordData.getFarewellText(_wrongGuessCount)}",
          style: const TextStyle(color: Color(0xFFFCD34D), fontSize: 11, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "Tap or type letters to save the stickman... (${_maxAttempts - _wrongGuessCount} attempts left)",
        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontStyle: FontStyle.italic),
      ),
    );
  }
}
