// api/create-deal-project.js
// Minimal, safe handler with CORS, JSON parsing, validation, and optional webhook forward

module.exports = async (req, res) => {
  // --- CORS (adjust origin for prod) ---
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type,Authorization');
  if (req.method === 'OPTIONS') return res.status(204).end();

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed. Use POST.' });
  }

  try {
    // --- Parse JSON body ---
    const chunks = [];
    for await (const c of req) chunks.push(c);
    const raw = Buffer.concat(chunks).toString('utf8');
    const body = raw ? JSON.parse(raw) : {};

    // --- Basic validation (tweak as needed) ---
    const { dealName, contactName, contactEmail, amount } = body;
    if (!dealName || !contactName || !contactEmail) {
      return res.status(400).json({
        error: 'Missing required fields',
        required: ['dealName', 'contactName', 'contactEmail'],
      });
    }

    // --- Optional: forward to a webhook / external service ---
    // Set this in Vercel → Settings → Environment Variables
    const { WEBHOOK_URL } = process.env;

    if (WEBHOOK_URL) {
      const upstream = await fetch(WEBHOOK_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });

      const contentType = upstream.headers.get('content-type') || '';
      const status = upstream.status;

      if (contentType.includes('application/json')) {
        const data = await upstream.json();
        return res.status(status).json({ ok: status < 400, upstream: data });
      } else {
        const buf = Buffer.from(await upstream.arrayBuffer());
        res.status(status);
        res.setHeader('Content-Type', contentType || 'application/octet-stream');
        return res.end(buf);
      }
    }

    // --- Local success response (no webhook configured) ---
    return res.status(200).json({
      ok: true,
      message: 'Deal received (no WEBHOOK_URL configured)',
      deal: { dealName, contactName, contactEmail, amount: amount ?? null },
      ts: Date.now(),
    });
  } catch (err) {
    console.error('create-deal-project failed:', err);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};
