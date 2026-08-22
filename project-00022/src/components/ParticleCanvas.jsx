import { useEffect, useRef } from "react";

export default function ParticleCanvas({ isShaking = false }) {
  const canvasRef = useRef(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    let animationFrameId;
    let width = (canvas.width = window.innerWidth);
    let height = (canvas.height = window.innerHeight);

    const handleResize = () => {
      width = canvas.width = window.innerWidth;
      height = canvas.height = window.innerHeight;
    };
    window.addEventListener("resize", handleResize);

    // Ambient floating particles
    const ambientParticles = Array.from({ length: 50 }, () => ({
      x: Math.random() * width,
      y: Math.random() * height,
      size: Math.random() * 2.5 + 1,
      speedX: (Math.random() - 0.5) * 0.4,
      speedY: -Math.random() * 0.5 - 0.2,
      opacity: Math.random() * 0.6 + 0.2,
      color: Math.random() > 0.5 ? "56, 189, 248" : "245, 158, 11",
    }));

    // Interactive cursor sparks
    const cursorSparks = [];

    const handlePointerMove = (e) => {
      const x = e.clientX || (e.touches && e.touches[0] ? e.touches[0].clientX : 0);
      const y = e.clientY || (e.touches && e.touches[0] ? e.touches[0].clientY : 0);

      if (x > 0 && y > 0) {
        for (let i = 0; i < 2; i++) {
          cursorSparks.push({
            x,
            y,
            size: Math.random() * 3 + 1.5,
            speedX: (Math.random() - 0.5) * 2.5,
            speedY: (Math.random() - 0.5) * 2.5,
            opacity: 1,
            life: 1,
            color: Math.random() > 0.5 ? "56, 189, 248" : "251, 191, 36",
          });
        }
      }
    };

    window.addEventListener("pointermove", handlePointerMove);

    const render = () => {
      ctx.clearRect(0, 0, width, height);

      // Render Ambient Floating Particles
      ambientParticles.forEach((p) => {
        p.x += p.speedX;
        p.y += p.speedY;

        if (p.y < 0) {
          p.y = height;
          p.x = Math.random() * width;
        }
        if (p.x < 0) p.x = width;
        if (p.x > width) p.x = 0;

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(${p.color}, ${p.opacity})`;
        ctx.shadowBlur = 8;
        ctx.shadowColor = `rgba(${p.color}, 0.8)`;
        ctx.fill();
      });

      // Render Cursor Sparks
      for (let i = cursorSparks.length - 1; i >= 0; i--) {
        const s = cursorSparks[i];
        s.x += s.speedX;
        s.y += s.speedY;
        s.life -= 0.04;
        s.size *= 0.95;

        if (s.life <= 0 || s.size <= 0.2) {
          cursorSparks.splice(i, 1);
          continue;
        }

        ctx.beginPath();
        ctx.arc(s.x, s.y, s.size, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(${s.color}, ${s.life})`;
        ctx.shadowBlur = 10;
        ctx.shadowColor = `rgba(${s.color}, 0.9)`;
        ctx.fill();
      }

      animationFrameId = requestAnimationFrame(render);
    };

    render();

    return () => {
      window.removeEventListener("resize", handleResize);
      window.removeEventListener("pointermove", handlePointerMove);
      cancelAnimationFrame(animationFrameId);
    };
  }, []);

  return (
    <canvas
      ref={canvasRef}
      className={`fixed inset-0 pointer-events-none z-0 transition-transform duration-100 ${
        isShaking ? "animate-shake" : ""
      }`}
    />
  );
}
