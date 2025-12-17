import React from "react"
import { languages } from "./languages"

export default function App() {
const languagesEle = languages.map(lang => {
  const styles = {
    backgroundColor: lang.backgroundColor,
    color: lang.color,
  };

  return (
    <span
      key={lang.name}
      style={styles}
      className="px-3 py-1.5 text-xs font-semibold rounded-full whitespace-nowrap transition hover:brightness-110"
    >
      {lang.name}
    </span>
  );
});

  return <main className="flex flex-col items-center "  >
    <header>
      <h1 className=" text-center text-[#F9F4DA] text-lg ">Assembly Endgame</h1>
    <p className=" text-center text-sm text-[#8E8E8E] max-w-[350px]">Guess the word in under 8 attempts to keep the programming world safe from Assembly!</p>
    </header>
    <section className="text-center border-s-[#10A95B] bg-[#10A95B] rounded-sm text-xl text-center text-[#F9F4DA] mt-5 w-[352px] h-14 ">you win! <br /> well done🎉</section>
<section className="flex flex-wrap justify-center gap-2 pt-8 mt-6 max-w-md mx-auto">
  {languagesEle}
</section>
  </main>
 
}