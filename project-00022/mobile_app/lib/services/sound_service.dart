import 'package:flutter/services.dart';

class SoundService {
  static bool _isMuted = false;

  static bool get isMuted => _isMuted;

  static void toggleMute() {
    _isMuted = !_isMuted;
  }

  static void play(String type) {
    if (_isMuted) return;

    // Haptic feedback for tactile feel on mobile devices
    if (type == 'correct') {
      HapticFeedback.lightImpact();
    } else if (type == 'wrong') {
      HapticFeedback.mediumImpact();
    } else if (type == 'win') {
      HapticFeedback.heavyImpact();
    } else if (type == 'loss') {
      HapticFeedback.vibrate();
    }
  }
}
