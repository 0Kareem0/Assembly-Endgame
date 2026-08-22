import 'package:flutter/services.dart';

class SoundService {
  static bool _musicMuted = false;
  static bool _sfxMuted = false;

  static bool get musicMuted => _musicMuted;
  static bool get sfxMuted => _sfxMuted;

  static void setMusicMuted(bool muted) {
    _musicMuted = muted;
  }

  static void setSfxMuted(bool muted) {
    _sfxMuted = muted;
  }

  static void toggleMusic() {
    _musicMuted = !_musicMuted;
  }

  static void toggleSfx() {
    _sfxMuted = !_sfxMuted;
  }

  static void play(String type) {
    if (_sfxMuted) return;

    if (type == 'intro_boom') {
      HapticFeedback.heavyImpact();
    } else if (type == 'click' || type == 'hover') {
      HapticFeedback.selectionClick();
    } else if (type == 'count') {
      HapticFeedback.lightImpact();
    } else if (type == 'go') {
      HapticFeedback.mediumImpact();
    } else if (type == 'correct') {
      HapticFeedback.lightImpact();
    } else if (type == 'wrong') {
      HapticFeedback.heavyImpact();
    } else if (type == 'win') {
      HapticFeedback.heavyImpact();
    } else if (type == 'loss') {
      HapticFeedback.vibrate();
    } else if (type == 'achievement') {
      HapticFeedback.heavyImpact();
    }
  }
}
