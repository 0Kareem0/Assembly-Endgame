import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  static double _bgmVolume = 0.5;
  static double _sfxVolume = 0.8;
  static bool _bgmMuted = false;
  static bool _sfxMuted = false;

  static double get bgmVolume => _bgmVolume;
  static double get sfxVolume => _sfxVolume;
  static bool get bgmMuted => _bgmMuted;
  static bool get sfxMuted => _sfxMuted;

  static Future<void> init() async {
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(_bgmMuted ? 0.0 : _bgmVolume);
    await _sfxPlayer.setVolume(_sfxMuted ? 0.0 : _sfxVolume);
  }

  static void setBgmVolume(double volume) {
    _bgmVolume = volume.clamp(0.0, 1.0);
    if (!_bgmMuted) {
      _bgmPlayer.setVolume(_bgmVolume);
    }
  }

  static void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    if (!_sfxMuted) {
      _sfxPlayer.setVolume(_sfxVolume);
    }
  }

  static void toggleBgmMute() {
    _bgmMuted = !_bgmMuted;
    _bgmPlayer.setVolume(_bgmMuted ? 0.0 : _bgmVolume);
  }

  static void toggleSfxMute() {
    _sfxMuted = !_sfxMuted;
    _sfxPlayer.setVolume(_sfxMuted ? 0.0 : _sfxVolume);
  }

  static Future<void> playBgm(String assetPath) async {
    if (_bgmMuted) return;
    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // Audio playback fallback
    }
  }

  static Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  static void playSfx(String type) {
    if (_sfxMuted) return;

    // Haptics & tactile feel
    if (type == 'click' || type == 'hover') {
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
    }
  }
}
