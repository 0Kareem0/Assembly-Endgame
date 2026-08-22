export const wordCategories = {
  General: [
    "airplane", "anchor", "balloon", "bridge", "castle", "compass", "crystal", "diamond", "dragon", "eclipse",
    "feather", "galaxy", "glacier", "island", "jungle", "lantern", "magnet", "mountain", "ocean", "pyramid",
    "rainbow", "rocket", "shadow", "silence", "starlight", "thunder", "treasure", "universe", "volcano", "whisper"
  ],
  Tech: [
    "algorithm", "backend", "compiler", "database", "developer", "encryption", "framework", "frontend", "hardware",
    "internet", "javascript", "keyboard", "language", "memory", "network", "operating", "protocol", "quantum",
    "recursion", "software", "terminal", "typescript", "variable", "virtual", "webmaster"
  ],
  PopCulture: [
    "avatar", "batman", "cyberpunk", "gandalf", "godzilla", "hogwarts", "inception", "jedi", "matrix",
    "nintendo", "olympus", "pokemon", "sherlock", "skyrim", "spiderman", "starwars", "superman", "titan", "wolverine"
  ],
  Animals: [
    "cheetah", "dolphin", "eagle", "elephant", "falcon", "flamingo", "giraffe", "gorilla", "kangaroo",
    "leopard", "octopus", "panther", "peacock", "penguin", "scorpion", "squirrel", "tiger", "walrus"
  ]
};

export function getRandomWord(category = "General") {
  const selectedList = wordCategories[category] || wordCategories.General;
  const randomIndex = Math.floor(Math.random() * selectedList.length);
  return selectedList[randomIndex].toLowerCase();
}

export function calculateScore({ timeTaken = 0, wrongGuessCount = 0, maxAttempts = 8, wordLength = 5, streak = 0 }) {
  const basePoints = wordLength * 150;
  const timeBonus = Math.max(0, (60 - timeTaken) * 10);
  const livesBonus = (maxAttempts - wrongGuessCount) * 100;
  const streakMultiplier = 1 + streak * 0.2; // 20% bonus per streak level

  const total = Math.round((basePoints + timeBonus + livesBonus) * streakMultiplier);
  return Math.max(100, total);
}

export function getFarewellText(attemptNumber = 1) {
  const options = [
    "Be careful! The platform is slipping!",
    "Oh no! The rope is tightening!",
    "Watch out! Danger level rising!",
    "Hold tight! Only a few chances left!",
    "Warning! The trapdoor is unlocking!",
    "Stay sharp! Danger is near!"
  ];
  return options[(attemptNumber - 1) % options.length] || options[0];
}