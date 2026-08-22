import 'dart:math';

class AvatarItem {
  final String id;
  final String icon;
  final String title;

  const AvatarItem({required this.id, required this.icon, required this.title});
}

class AchievementItem {
  final String id;
  final String title;
  final String desc;
  final String icon;

  const AchievementItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.icon,
  });
}

class WordData {
  static const List<AvatarItem> avatars = [
    AvatarItem(id: "hero", icon: "🤠", title: "Cowboy Hero"),
    AvatarItem(id: "cyber", icon: "🤖", title: "Cyber Bot"),
    AvatarItem(id: "ninja", icon: "🥷", title: "Shadow Ninja"),
    AvatarItem(id: "wizard", icon: "🧙‍♂️", title: "Arcane Wizard"),
    AvatarItem(id: "astronaut", icon: "👨‍🚀", title: "Space Ranger"),
    AvatarItem(id: "cat", icon: "🐱", title: "Cyber Cat"),
  ];

  static const List<AchievementItem> achievements = [
    AchievementItem(id: "first_win", title: "First Escape", desc: "Rescued the hero for the first time", icon: "🐣"),
    AchievementItem(id: "streak_3", title: "On Fire", desc: "Reached a 3-game win streak", icon: "🔥"),
    AchievementItem(id: "streak_5", title: "Unstoppable", desc: "Reached a 5-game win streak", icon: "⚡"),
    AchievementItem(id: "speed_demon", title: "Speed Demon", desc: "Rescued the hero in under 20 seconds", icon: "⏱️"),
    AchievementItem(id: "flawless", title: "Flawless Hero", desc: "Rescued with 0 wrong guesses", icon: "🛡️"),
    AchievementItem(id: "high_score_1000", title: "High Roller", desc: "Scored over 1,000 points in a round", icon: "👑"),
  ];

  static const Map<String, List<String>> categories = {
    'General': [
      'airplane', 'anchor', 'balloon', 'bridge', 'castle', 'compass', 'crystal', 'diamond', 'dragon', 'eclipse',
      'feather', 'galaxy', 'glacier', 'island', 'jungle', 'lantern', 'magnet', 'mountain', 'ocean', 'pyramid',
      'rainbow', 'rocket', 'shadow', 'silence', 'starlight', 'thunder', 'treasure', 'universe', 'volcano', 'whisper'
    ],
    'Tech': [
      'algorithm', 'backend', 'compiler', 'database', 'developer', 'encryption', 'framework', 'frontend', 'hardware',
      'internet', 'javascript', 'keyboard', 'language', 'memory', 'network', 'operating', 'protocol', 'quantum',
      'recursion', 'software', 'terminal', 'typescript', 'variable', 'virtual', 'webmaster'
    ],
    'PopCulture': [
      'avatar', 'batman', 'cyberpunk', 'gandalf', 'godzilla', 'hogwarts', 'inception', 'jedi', 'matrix',
      'nintendo', 'olympus', 'pokemon', 'sherlock', 'skyrim', 'spiderman', 'starwars', 'superman', 'titan', 'wolverine'
    ],
    'Animals': [
      'cheetah', 'dolphin', 'eagle', 'elephant', 'falcon', 'flamingo', 'giraffe', 'gorilla', 'kangaroo',
      'leopard', 'octopus', 'panther', 'peacock', 'penguin', 'scorpion', 'squirrel', 'tiger', 'walrus'
    ],
  };

  static String getRandomWord(String category) {
    final list = categories[category] ?? categories['General']!;
    final random = Random();
    return list[random.nextInt(list.length)].toLowerCase();
  }

  static int calculateScore({
    required int timeTaken,
    required int wrongGuessCount,
    int maxAttempts = 8,
    required int wordLength,
    int streak = 0,
  }) {
    final basePoints = wordLength * 150;
    final timeBonus = max(0, (60 - timeTaken) * 10);
    final livesBonus = (maxAttempts - wrongGuessCount) * 100;
    final streakMultiplier = 1 + (streak * 0.2);

    final total = ((basePoints + timeBonus + livesBonus) * streakMultiplier).round();
    return max(100, total);
  }

  static String getFarewellText(int wrongGuessCount) {
    const options = [
      "Be careful! The platform is slipping!",
      "Oh no! The rope is tightening!",
      "Watch out! Danger level rising!",
      "Hold tight! Only a few chances left!",
      "Warning! The trapdoor is unlocking!",
      "Stay sharp! Danger is near!"
    ];
    if (wrongGuessCount <= 0) return options[0];
    return options[(wrongGuessCount - 1) % options.length];
  }
}
