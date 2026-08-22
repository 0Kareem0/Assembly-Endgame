import 'package:flutter/material.dart';

class HangmanCanvas extends StatelessWidget {
  final int wrongGuessCount;
  final int maxAttempts;
  final bool gameWon;
  final bool gameLost;

  const HangmanCanvas({
    super.key,
    required this.wrongGuessCount,
    this.maxAttempts = 8,
    required this.gameWon,
    required this.gameLost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 210,
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 1,
          )
        ],
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(200, 210),
            painter: _HangmanPainter(
              wrongGuessCount: wrongGuessCount,
              maxAttempts: maxAttempts,
              gameWon: gameWon,
              gameLost: gameLost,
            ),
          ),
          Positioned(
            bottom: 6,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "STAGE:",
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        gameWon
                            ? "SAVED! 🎉"
                            : "$wrongGuessCount / $maxAttempts TRAPPED",
                        style: TextStyle(
                          color: gameWon
                              ? const Color(0xFF10B981)
                              : wrongGuessCount >= 6
                                  ? const Color(0xFFEF4444)
                                  : wrongGuessCount >= 3
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF38BDF8),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HangmanPainter extends CustomPainter {
  final int wrongGuessCount;
  final int maxAttempts;
  final bool gameWon;
  final bool gameLost;

  _HangmanPainter({
    required this.wrongGuessCount,
    required this.maxAttempts,
    required this.gameWon,
    required this.gameLost,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final polePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final ropePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final bodyPaint = Paint()
      ..color = gameWon
          ? const Color(0xFF10B981)
          : gameLost
              ? const Color(0xFFEF4444)
              : Colors.white
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Step 1: Base Platform
    if (wrongGuessCount >= 1) {
      canvas.drawLine(const Offset(20, 175), const Offset(180, 175), polePaint);
    }

    // Step 2: Vertical Pole
    if (wrongGuessCount >= 2) {
      canvas.drawLine(const Offset(50, 175), const Offset(50, 20), polePaint);
    }

    // Step 3: Top Horizontal Beam & Diagonal Angle Brace
    if (wrongGuessCount >= 3) {
      canvas.drawLine(const Offset(47, 20), const Offset(140, 20), polePaint);
      canvas.drawLine(const Offset(50, 50), const Offset(80, 20), polePaint);
    }

    // Step 4: Rope / Noose Loop
    if (wrongGuessCount >= 4) {
      canvas.drawLine(const Offset(130, 20), const Offset(130, 50), ropePaint);
    }

    // Step 5: Head & Facial Expression
    if (wrongGuessCount >= 5 || gameWon) {
      final headCenter = const Offset(130, 68);
      const headRadius = 18.0;

      final headFill = Paint()
        ..color = gameWon
            ? const Color(0xFF10B981).withValues(alpha: 0.2)
            : gameLost
                ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                : const Color(0xFF1E293B)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(headCenter, headRadius, headFill);
      canvas.drawCircle(headCenter, headRadius, bodyPaint);

      // Facial Expression
      if (gameWon) {
        // Happy eyes ^ ^
        final eyePaint = Paint()
          ..color = const Color(0xFF10B981)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        final pathLeft = Path()
          ..moveTo(122, 65)
          ..quadraticBezierTo(125, 61, 127, 65);
        final pathRight = Path()
          ..moveTo(133, 65)
          ..quadraticBezierTo(136, 61, 138, 65);
        canvas.drawPath(pathLeft, eyePaint);
        canvas.drawPath(pathRight, eyePaint);

        // Smile
        final smilePath = Path()
          ..moveTo(123, 73)
          ..quadraticBezierTo(130, 80, 137, 73);
        canvas.drawPath(smilePath, eyePaint);
      } else if (gameLost || wrongGuessCount >= maxAttempts) {
        // X-eyes
        final xPaint = Paint()
          ..color = const Color(0xFFEF4444)
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(const Offset(122, 62), const Offset(127, 67), xPaint);
        canvas.drawLine(const Offset(127, 62), const Offset(122, 67), xPaint);
        canvas.drawLine(const Offset(133, 62), const Offset(138, 67), xPaint);
        canvas.drawLine(const Offset(138, 62), const Offset(133, 67), xPaint);

        // Frown
        final frownPath = Path()
          ..moveTo(123, 76)
          ..quadraticBezierTo(130, 70, 137, 76);
        canvas.drawPath(frownPath, xPaint);
      } else if (wrongGuessCount >= 5) {
        // Scared O O eyes
        final eyeFill = Paint()..color = Colors.white;
        canvas.drawCircle(const Offset(125, 64), 2.0, eyeFill);
        canvas.drawCircle(const Offset(135, 64), 2.0, eyeFill);

        // Worried line mouth
        final mouthPaint = Paint()
          ..color = const Color(0xFFF59E0B)
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(const Offset(126, 75), const Offset(134, 75), mouthPaint);
      }
    }

    // Step 6: Body Torso
    if (wrongGuessCount >= 6 || gameWon) {
      canvas.drawLine(const Offset(130, 86), const Offset(130, 130), bodyPaint);
    }

    // Step 7: Arms (Raised in victory if won)
    if (wrongGuessCount >= 7 || gameWon) {
      if (gameWon) {
        // Raised arms in victory!
        canvas.drawLine(const Offset(130, 100), const Offset(112, 78), bodyPaint);
        canvas.drawLine(const Offset(130, 100), const Offset(148, 78), bodyPaint);
      } else {
        // Hanging arms
        canvas.drawLine(const Offset(130, 100), const Offset(110, 122), bodyPaint);
        canvas.drawLine(const Offset(130, 100), const Offset(150, 122), bodyPaint);
      }
    }

    // Step 8: Legs
    if (wrongGuessCount >= 8 || gameWon) {
      canvas.drawLine(const Offset(130, 130), const Offset(112, 162), bodyPaint);
      canvas.drawLine(const Offset(130, 130), const Offset(148, 162), bodyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HangmanPainter oldDelegate) {
    return oldDelegate.wrongGuessCount != wrongGuessCount ||
        oldDelegate.gameWon != gameWon ||
        oldDelegate.gameLost != gameLost;
  }
}
