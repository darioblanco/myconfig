// Claude plan limits, styled like the Codex desktop widget. Reads the numbers the Claude Code
// status line saves (~/.claude/statusline.sh); nothing leaves the Mac. Move it with `top`/`left`.
export const command = 'cat "$HOME/.cache/claude-limits.json" 2>/dev/null';
export const refreshFrequency = 60 * 1000;

export const className = `
  top: 40px;
  left: 40px;
  width: 170px;
  padding: 14px 16px;
  border-radius: 22px;
  background: rgba(36, 36, 38, 0.92);
  box-shadow: 0 6px 18px rgba(0, 0, 0, 0.3);
  color: #f2f2f7;
  font: 13px -apple-system, BlinkMacSystemFont, sans-serif;
  .title { display: flex; align-items: center; gap: 8px; font-size: 17px; margin-bottom: 10px; }
  .row { display: flex; justify-content: space-between; align-items: baseline; margin-top: 6px; }
  .label { color: #a1a1a6; }
  .value { font-size: 18px; font-weight: 600; }
  .bar { height: 5px; border-radius: 3px; background: #48484a; margin-top: 4px; overflow: hidden; }
  .fill { height: 100%; border-radius: 3px; background: #d97757; }
  .foot { color: #8e8e93; font-size: 11px; margin-top: 8px; }
`;

const until = (epoch) => {
  const s = epoch - Date.now() / 1000;
  if (!epoch || s <= 0) return "now";
  if (s >= 86400) return `${Math.round(s / 86400)} days`;
  if (s >= 3600) return `${Math.round(s / 3600)} h`;
  return `${Math.max(1, Math.round(s / 60))} min`;
};

const ago = (epoch) => {
  const m = Math.round((Date.now() / 1000 - epoch) / 60);
  return m < 1 ? "just now" : m < 60 ? `${m} min ago` : `${Math.round(m / 60)} h ago`;
};

const Row = ({ label, left }) => (
  <div>
    <div className="row">
      <span className="label">{label}</span>
      <span className="value">{left}% left</span>
    </div>
    <div className="bar"><div className="fill" style={{ width: `${left}%` }} /></div>
  </div>
);

export const render = ({ output }) => {
  let d;
  try { d = JSON.parse(output); } catch { d = null; }
  return (
    <div>
      <div className="title">✻ Claude</div>
      {d ? (
        <div>
          <Row label="5 hours" left={d.five_hour_left} />
          <Row label="Weekly" left={d.seven_day_left} />
          <div className="foot">
            Resets in {until(d.seven_day_resets_at)} · updated {ago(d.updated_at)}
          </div>
        </div>
      ) : (
        <div className="foot">Open a Claude Code session to load your limits.</div>
      )}
    </div>
  );
};
