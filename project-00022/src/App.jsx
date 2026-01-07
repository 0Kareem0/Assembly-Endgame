import {useState} from "react";
import { languages } from "./languages"


export default function App() {
  const [currentWord, setCurrentWord] = useState("react")
    const [guessedLetters, setGuessedLetters] = useState([])
    console.log(guessedLetters)

const wrongGuessCount = guessedLetters.filter(letter => !currentWord.includes(letter)).length
    console.log(wrongGuessCount)



    function handleGuessedLetters(letter) {
        setGuessedLetters(prevLetters =>
            prevLetters.includes(letter) ? [...prevLetters]
                : [...prevLetters, letter])
    }





const languagesEle = languages.map(lang => {
  const styles = {
    backgroundColor: lang.backgroundColor,
    color: lang.color,
  };


  return (
    <span
        className=" relative
    before:content-['💀']
    before:absolute
    before:inset-0
    before:flex
    before:items-center
    before:justify-center
    before:bg-black/70
    before:text-sm"

      key={lang.name}
      style={styles}
      className=" cursor-pointer px-3 py-1.5 text-xs font-semibold rounded-full whitespace-nowrap transition hover:brightness-110"
    >
      {lang.name}

    </span>
  );
});


  const letterElements = currentWord.split("").map((letter,i) => (

      <span
      className=" w-[40px] h-[40px] bg-[#323232] flex items-center justify-center text-lg border-b "
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
`}

    onClick={() => handleGuessedLetters(letter)}
          key={i}
      >{letter.toUpperCase()}
      </button>
  ))

  return <main className="flex flex-col items-center "  >
    <header>
      <h1 className=" text-center text-[#F9F4DA] text-lg ">Assembly Endgame</h1>
    <p className=" text-center text-sm text-[#8E8E8E] max-w-[350px]">Guess the word in under 8 attempts to keep the programming world safe from Assembly!</p>
    </header>
    <section className="text-center border-s-[#10A95B] bg-[#10A95B] rounded-sm text-xl  text-[#F9F4DA] mt-5 w-88 h-14 ">you win! <br /> well done🎉</section>
<section className="flex flex-wrap justify-center gap-2 pt-8 mt-6 max-w-md mx-auto">
  {languagesEle}
</section>

<section className="flex justify-center pt-4 mt-6 max-w-md mx-auto gap-1">
  {letterElements}
</section>

    <section className="flex flex-wrap justify-center gap-2 max-w-[450px] pt-12
 ">{lettersMapping}</section>

    <section className="flex justify-center pt-4 mt-6 max-w-md mx-auto" >
    <button
        className=" text-black bg-[#11B5E5] border border-[#D7D7D7] rounded w-[225px] h-[40px] px-3 py-1.5 block mx-auto cursor-pointer"
    >
      New Game
    </button>
    </section>
  </main>

}