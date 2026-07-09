export function PhoneMockup() {
  return (
    <div className="phone-wrap">
      <div className="phone-halo">
        <div className="phone">
          <div className="phone-notch" />
          <div className="phone-screen">
            <div className="mock-date">WED · TODAY</div>
            <div className="mock-greeting">Good evening, Alex 👋</div>

            <div className="mock-card mock-sky">
              <div className="label">TODAY&apos;S PARENTHUG</div>
              <div className="big">
                Find 5 minutes to follow Leo&apos;s lead. Let him pick the game.
              </div>
            </div>

            <div className="mock-card mock-warm">
              <div className="label">🚪 BEFORE YOU WALK IN</div>
              <div className="big">
                Leo had a tough afternoon. Start with connection, not correction.
              </div>
            </div>

            <div className="mock-card mock-white">
              <div className="label" style={{ color: "var(--primary)" }}>
                💬 SAY THIS TODAY
              </div>
              <div className="quote">
                “I love being your parent. Even on hard days, I&apos;m so glad
                you&apos;re mine.”
              </div>
            </div>

            <div className="mock-tab">
              <span>☀️</span>
              <div className="mock-hug">🫂</div>
              <span>📋</span>
              <span>📸</span>
              <span>🙂</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
