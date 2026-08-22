import 'package:flutter/material.dart';

class QwertyKeyboard extends StatelessWidget {
  final Set<String> guessedLetters;
  final String currentWord;
  final bool gameOver;
  final Function(String) onLetterPressed;

  const QwertyKeyboard({
    super.key,
    required this.guessedLetters,
    required this.currentWord,
    required this.gameOver,
    required this.onLetterPressed,
  });

  static const List<List<String>> _rows = [
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((letter) {
              final isGuessed = guessedLetters.contains(letter);
              final isCorrect = isGuessed && currentWord.contains(letter);
              final isWrong = isGuessed && !currentWord.contains(letter);

              Color bgColor = const Color(0xFFFCBA29);
              Color textColor = const Color(0xFF0F172A);
              double opacity = 1.0;

              if (isCorrect) {
                bgColor = const Color(0xFF10B981);
                textColor = Colors.white;
              } else if (isWrong) {
                bgColor = const Color(0xFF1E293B);
                textColor = const Color(0xFF64748B);
                opacity = 0.4;
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: Opacity(
                    opacity: gameOver && !isGuessed ? 0.6 : opacity,
                    child: Material(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      elevation: isGuessed ? 0 : 3,
                      child: InkWell(
                        onTap: isGuessed || gameOver
                            ? null
                            : () => onLetterPressed(letter),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 42,
                          alignment: Alignment.center,
                          child: Text(
                            letter.toUpperCase(),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              decoration: isWrong
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
