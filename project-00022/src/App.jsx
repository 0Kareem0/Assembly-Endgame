import {useState} from "react";
import { languages } from "./languages"
import {getFarewellText , getRandomWord} from "./utils.js";

export default function App() {
  const [currentWord, setCurrentWord] = useState(getRandomWord())
    const [guessedLetters, setGuessedLetters] = useState([])
    console.log(guessedLetters)

const wrongGuessCount = guessedLetters.filter(letter => !currentWord.includes(letter)).length
    console.log(wrongGuessCount)

    const gameLost =  wrongGuessCount === languages.length - 1
    const gameWon = currentWord.split("").every(letter => guessedLetters.includes((letter)))
    const gameOver = gameLost || gameWon

    const lastGuessedLetter = guessedLetters[guessedLetters.length - 1]
    const isLastGuessIncorrect = lastGuessedLetter && !currentWord.includes(lastGuessedLetter)
    console.log(isLastGuessIncorrect)

    function handleGuessedLetters(letter) {
        setGuessedLetters(prevLetters =>
            prevLetters.includes(letter) ? [...prevLetters]
                : [...prevLetters, letter])
    }


const languagesEle = languages.map((lang ,i) => {
  const styles = {
    backgroundColor: lang.backgroundColor,
    color: lang.color,
  };

    const langIsLost = i < wrongGuessCount;



    return (
    <span

      key={lang.name}
      style={styles}
      className={`cursor-pointer px-3 py-1.5 
      text-xs font-semibold
       rounded-full
       whitespace-nowrap transition hover:brightness-110 
        ${langIsLost ? "blur-sm lost" : ""}
        `}
    >
      {lang.name}

    </span>
  );
});


  const letterElements = currentWord.split("").map((letter,i) => (

      <span
      className=" w-[40px] h-[40px] bg-[#323232] flex items-center justify-center text-lg border-b  "
          key={i}>
        {guessedLetters.includes(letter)? letter.toUpperCase() : ""}</span>
  ))

  const alphabet = "abcdefghijklmnopqrstuvwxyz"
  const lettersMapping =alphabet.split("").map((letter,i)=>(
      <button
          className={`
   
  w-[35px] h-[35px]
  border border-[#D7D7D7]
  rounded-[3px]
  text-black
  transition-colors duration-200
  ${
              guessedLetters.includes(letter)
                  ? currentWord.includes(letter)
                      ? "bg-green-500"
                      : "bg-red-500"
                  : "bg-[#FCBA29] hover:bg-yellow-400"
              
          }
          ${gameOver ? "opacity-60 cursor-not-allowed pointer-events-none" : ""}
`}

    onClick={() => handleGuessedLetters(letter)}
          key={i}
      >{letter.toUpperCase()}
      </button>
  ))

  return <main className="flex flex-col items-center  "  >
    <header>
      <h1 className=" text-center text-[#F9F4DA] text-lg ">Assembly Endgame</h1>
    <p className=" text-center text-sm text-[#8E8E8E] max-w-[350px]">Guess the word in under 8 attempts to keep the programming world safe from Assembly!</p>
    </header>
      {gameWon ? <section className="text-center border-s-[#10A95B] bg-[#10A95B] rounded-sm text-xl  text-[#F9F4DA] mt-5 w-88 h-14 ">you win! <br /> well done🎉</section> :null}
      {gameLost ? <section className="text-center border-s-[#BA2A2A] bg-[#BA2A2A] rounded-sm text-xl  text-[#F9F4DA] mt-5 w-full ">Game over! <br /> You lose! Better start learning Assembly 😭</section> :null}
      {isLastGuessIncorrect ? <section className="
       mt-5 w-full
      bg-[#7A5EA7]
      text-[#F9F4DA]
      text-xl
      text-center
      rounded-md
      border
      border-dashed
    border-[#323232]
      px-6 py-4
      shadow-md
      italic ">{getFarewellText(languages[wrongGuessCount - 1].name)}</section> : null}
      <section className="flex flex-wrap justify-center gap-2 pt-8 mt-6 max-w-md mx-auto">
  {languagesEle}
</section>

<section className="flex justify-center pt-4 mt-6 max-w-md mx-auto gap-1">
  {letterElements}
</section>

    <section className="flex flex-wrap justify-center gap-2 max-w-[450px] pt-12 cursor-pointer
 ">{lettersMapping}</section>

    <section className="flex justify-center pt-4 mt-6 max-w-md mx-auto" >
        { gameOver ? <button
            className=" text-black bg-[#11B5E5] border border-[#D7D7D7] rounded w-[225px] h-[40px] px-3 py-1.5 block mx-auto cursor-pointer"
        >
            New Game
        </button> : null}
    </section>
  </main>

}