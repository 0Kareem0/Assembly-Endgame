import 'dart:math';

class WordData {
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
    ]
  };

  static String getRandomWord(String category) {
    final list = categories[category] ?? categories['General']!;
    final random = Random();
    return list[random.nextInt(list.length)].toLowerCase();
  }

  static int calculateScore({
    required int timeTaken,
    required int wrongGuessCount,
    required int maxAttempts,
    required int wordLength,
    required int streak,
  }) {
    final basePoints = wordLength * 150;
    final timeBonus = max(0, (60 - timeTaken) * 10);
    final livesBonus = (maxAttempts - wrongGuessCount) * 100;
    final streakMultiplier = 1.0 + (streak * 0.2);

    final total = ((basePoints + timeBonus + livesBonus) * streakMultiplier).round();
    return max(100, total);
  }

  static String getFarewellText(int wrongCount) {
    const options = [
      "Be careful! The platform is slipping!",
      "Oh no! The rope is tightening!",
      "Watch out! Danger level rising!",
      "Hold tight! Only a few chances left!",
      "Warning! The trapdoor is unlocking!",
      "Stay sharp! Danger is near!"
    ];
    return options[(wrongCount - 1) % options.length];
  }
}
