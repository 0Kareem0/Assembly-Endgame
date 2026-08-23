import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class CyberButton extends StatelessWidget {
  final String label;
  final String? icon;
  final String? subtitle;
  final Color? subtitleColor;
  final bool isPrimary;
  final VoidCallback onTap;

  const CyberButton({
    super.key,
    required this.label,
    this.icon,
    this.subtitle,
    this.subtitleColor,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF38BDF8),
            foregroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            shadowColor: const Color(0xFF38BDF8).withValues(alpha: 0.4),
          ),
          onPressed: () {
            AudioService.playSfx('click');
            onTap();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Text(icon!, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AudioService.playSfx('click');
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Text(icon!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: subtitleColor ?? const Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
