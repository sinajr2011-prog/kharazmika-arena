/**
 * Kharazmika competition client
 * Usage: KharazmikaXP.award(15, 'Linear solved', 'equation')
 */
(function (global) {
  const API = 'competition.php';

  async function req(action, body) {
    const opts = {
      method: body ? 'POST' : 'GET',
      credentials: 'same-origin',
      headers: body ? { 'Content-Type': 'application/json' } : undefined,
      body: body ? JSON.stringify(Object.assign({ action }, body)) : undefined,
    };
    const url = body ? API : `${API}?action=${encodeURIComponent(action)}`;
    const res = await fetch(url, opts);
    return res.json();
  }

  function toast(msg, type) {
    let el = document.getElementById('kh-xp-toast');
    if (!el) {
      el = document.createElement('div');
      el.id = 'kh-xp-toast';
      el.style.cssText =
        'position:fixed;bottom:24px;left:50%;transform:translateX(-50%);z-index:99999;' +
        'padding:12px 20px;border-radius:14px;font-family:Vazirmatn,sans-serif;font-weight:700;' +
        'font-size:0.92rem;box-shadow:0 12px 40px rgba(0,0,0,.35);transition:opacity .3s;opacity:0;pointer-events:none;';
      document.body.appendChild(el);
    }
    el.style.background =
      type === 'badge'
        ? 'linear-gradient(135deg,#8b5cf6,#22d3ee)'
        : 'linear-gradient(135deg,#0f1b2d,#14243a)';
    el.style.color = '#eef7ff';
    el.style.border = '1px solid rgba(34,211,238,.35)';
    el.textContent = msg;
    el.style.opacity = '1';
    clearTimeout(el._t);
    el._t = setTimeout(() => {
      el.style.opacity = '0';
    }, 2800);
  }

  const KharazmikaXP = {
    async status() {
      return req('status');
    },
    async me() {
      return req('me');
    },
    async award(amount, reason, source) {
      try {
        const data = await req('award', {
          amount: amount || 1,
          reason: reason || 'activity',
          source: source || 'app',
        });
        if (!data.ok) {
          if (data.error === 'login_required') return { needLogin: true };
          return data;
        }
        const d = data.data || {};
        if (d.blocked) {
          toast(d.message || 'Slow down');
          return d;
        }
        if (d.awarded > 0) {
          toast('+' + d.awarded + ' XP — ' + (reason || ''));
        }
        if (d.new_badges && d.new_badges.length) {
          d.new_badges.forEach((b) => toast('Badge: ' + b.title, 'badge'));
        }
        return d;
      } catch (e) {
        console.warn('XP award failed', e);
        return { error: true };
      }
    },
    onEquationSolved(kind) {
      const map = { linear: 5, quadratic: 10, system: 15 };
      const amount = map[kind] || 8;
      const labels = {
        linear: 'Linear equation',
        quadratic: 'Quadratic equation',
        system: 'System of equations',
      };
      return this.award(amount, labels[kind] || 'Equation', 'equation');
    },
  };

  global.KharazmikaXP = KharazmikaXP;
})(window);
