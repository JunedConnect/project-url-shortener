from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse, HTMLResponse, JSONResponse
from urllib.parse import urlparse
import hashlib, time
from ddb import put_mapping, get_mapping, increment_hits # I removed the .ddb and replaced it with ddb since there was a path issue as python could not locate the ddb.py file

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def home_page():
    return """
    <!DOCTYPE html>
    <html lang=\"en\">
    <head>
        <meta charset=\"UTF-8\" />
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
        <title>URL Shortener</title>
        <style>
            :root { --green-primary: #0b7a3b; --green-dark: #085c2c; --green-light: #11a053; --green-text: #0b7a3b; --green-border: #11a053; }
            html, body { height: 100%; margin: 0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; color: var(--green-text); background: #ffffff; }
            body { display: flex; align-items: center; justify-content: center; }
            .container { width: 100%; max-width: 720px; padding: 24px; }
            .card { background: #ffffff; border: 2px solid var(--green-border); border-radius: 16px; box-shadow: 0 4px 20px rgba(11,122,59,0.1); padding: 28px; }
            h1 { margin: 0 0 8px 0; font-size: 28px; font-weight: 700; letter-spacing: 0.2px; color: var(--green-primary); }
            p.sub { margin: 0 0 24px 0; color: var(--green-dark); }
            .row { display: flex; gap: 12px; }
            input[type=url] { flex: 1; padding: 14px 16px; border-radius: 12px; border: 2px solid var(--green-border); background: #ffffff; color: var(--green-text); font-size: 16px; outline: none; transition: border 0.2s, box-shadow 0.2s; }
            input[type=url]::placeholder { color: rgba(11,122,59,0.6); }
            input[type=url]:focus { border-color: var(--green-primary); box-shadow: 0 0 0 4px rgba(17,160,83,0.25); }
            button { padding: 14px 18px; border-radius: 12px; border: none; background: var(--green-light); color: #ffffff; font-weight: 700; cursor: pointer; transition: transform 0.05s ease, filter 0.2s ease; }
            button:hover { filter: brightness(1.05); }
            button:active { transform: translateY(1px); }
            .result { margin-top: 20px; padding: 14px 16px; background: rgba(17,160,83,0.1); border-radius: 12px; border: 1px solid var(--green-border); display: none; color: var(--green-text); }
            .error { margin-top: 12px; color: #dc3545; display: none; }
            a.short { color: var(--green-primary); font-weight: 700; text-decoration: underline; }
            .footer { margin-top: 20px; opacity: 0.7; font-size: 13px; }
        </style>
    </head>
    <body>
        <div class=\"container\">
            <div class=\"card\">
                <h1>URL Shortener</h1>
                <p class=\"sub\">Paste a URL, get a short link you can click.</p>
                <div class=\"row\">
                    <input id=\"urlInput\" type=\"url\" placeholder=\"https://example.com/very/long/link\" />
                    <button id=\"shortenBtn\">Shorten</button>
                </div>
                <div id=\"error\" class=\"error\"></div>
                <div id=\"result\" class=\"result\"></div>
            </div>
        </div>
        <script>
            const input = document.getElementById('urlInput');
            const btn = document.getElementById('shortenBtn');
            const result = document.getElementById('result');
            const errorBox = document.getElementById('error');

            async function shorten() {
                // Prevent multiple simultaneous requests
                if (btn.disabled) return;
                errorBox.style.display = 'none';
                result.style.display = 'none';
                const url = input.value.trim();
                if (!url) {
                    errorBox.textContent = 'Please enter a URL';
                    errorBox.style.display = 'block';
                    return;
                }
                try {
                    // Loading state
                    btn.disabled = true;
                    btn.textContent = 'Shortening…';
                    const res = await fetch('/shorten', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ url }),
                        cache: 'no-store'
                    });
                    if (!res.ok) {
                        const msg = await res.text();
                        throw new Error(msg || 'Failed to shorten URL');
                    }
                    const data = await res.json();
                    const origin = window.location.origin;
                    const shortUrl = origin + '/' + data.short;
                    result.innerHTML = 'Short URL: <a class="short" href="' + shortUrl + '" target="_blank" rel="noopener">' + shortUrl + '</a>';
                    result.style.display = 'block';
                } catch (e) {
                    errorBox.textContent = e.message || 'Something went wrong';
                    errorBox.style.display = 'block';
                } finally {
                    btn.disabled = false;
                    btn.textContent = 'Shorten';
                }
            }

            btn.addEventListener('click', shorten);
            input.addEventListener('keydown', (e) => { if (e.key === 'Enter') shorten(); });
        </script>
    </body>
    </html>
    """

@app.get("/healthz", response_class=HTMLResponse)
def health():
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Health Check</title>
        <style>
            :root { --green-primary: #0b7a3b; --green-dark: #085c2c; --green-light: #11a053; --green-text: #0b7a3b; --green-border: #11a053; }
            html, body { height: 100%; margin: 0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; color: var(--green-text); background: #ffffff; }
            body { display: flex; align-items: center; justify-content: center; }
            .container { width: 100%; max-width: 720px; padding: 24px; }
            .card { background: #ffffff; border: 2px solid var(--green-border); border-radius: 16px; box-shadow: 0 4px 20px rgba(11,122,59,0.1); padding: 28px; text-align: center; }
            h1 { margin: 0 0 8px 0; font-size: 28px; font-weight: 700; letter-spacing: 0.2px; color: var(--green-primary); }
            .status { font-size: 18px; color: var(--green-light); font-weight: 600; margin: 20px 0; }
            .timestamp { font-size: 14px; color: var(--green-dark); opacity: 0.8; }
            .icon { font-size: 48px; margin-bottom: 16px; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <div class="icon">✅</div>
                <h1>Health Check</h1>
                <div class="status">Service is healthy</div>
                <div class="timestamp">Timestamp: """ + str(int(time.time())) + """</div>
            </div>
        </div>
    </body>
    </html>
    """

@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()
    url = body.get("url")
    if not url:
        raise HTTPException(400, "url required")
    if not url.startswith(("http://", "https://")):
        url = "https://" + url
    # Disallow shortening URLs on this same host (to avoid loops/conflicts)
    try:
        parsed = urlparse(url)
        target_host = (parsed.netloc or "").split(":")[0].strip().lower()
        request_host = (req.headers.get("x-forwarded-host") or req.headers.get("host") or "").split(",")[0].strip().lower()
        if request_host and target_host and request_host == target_host:
            raise HTTPException(400, "cannot shorten a URL on the same host")
    except Exception:
        # If parsing errors occur, continue to connectivity check which will likely produce a helpful error
        pass

    # Skipping live reachability verification per request
    short = hashlib.sha256(url.encode()).hexdigest()[:8]
    now = int(time.time())
    ttl_seconds = body.get("ttl_seconds")
    ttl_epoch = None
    if isinstance(ttl_seconds, (int, float)):
        ttl_seconds = int(ttl_seconds)
        ttl_seconds = max(60, min(31536000, ttl_seconds))
        ttl_epoch = now + ttl_seconds
    else:
        # Default TTL: 24 hours
        ttl_epoch = now + 86400
    put_mapping(short, url, created_at=now, ttl=ttl_epoch)
    return JSONResponse({"short": short, "url": url, "created_at": now, "ttl": ttl_epoch}, headers={"Cache-Control": "no-store"})

@app.get("/{short_id}")
def resolve(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(404, "not found")
    dest = item.get("url", "")
    if not dest.startswith(("http://", "https://")):
        dest = "https://" + dest
    try:
        increment_hits(short_id)
    except Exception:
        pass
    return RedirectResponse(dest, status_code=302, headers={"Cache-Control": "no-store"})

@app.post("/bulk-shorten")
async def bulk_shorten(req: Request):
    body = await req.json()
    urls = body.get("urls")
    if not isinstance(urls, list) or not urls:
        raise HTTPException(400, "urls must be a non-empty array")
    ttl_seconds = body.get("ttl_seconds")
    now = int(time.time())
    client_ip = None
    out = []
    request_host = (req.headers.get("x-forwarded-host") or req.headers.get("host") or "").split(",")[0].strip().lower()
    for original in urls:
        if not isinstance(original, str) or not original.strip():
            out.append({"url": original, "error": "invalid url"})
            continue
        url = original.strip()
        if not url.startswith(("http://", "https://")):
            url = "https://" + url
        try:
            parsed = urlparse(url)
            target_host = (parsed.netloc or "").split(":")[0].strip().lower()
            if request_host and target_host and request_host == target_host:
                out.append({"url": original, "error": "same host not allowed"})
                continue
        except Exception:
            pass
        short = hashlib.sha256(url.encode()).hexdigest()[:8]
        if isinstance(ttl_seconds, (int, float)):
            t = int(ttl_seconds)
            t = max(60, min(31536000, t))
            ttl_epoch = now + t
        else:
            # Default TTL: 24 hours
            ttl_epoch = now + 86400
        put_mapping(short, url, created_at=now, ttl=ttl_epoch)
        out.append({"url": url, "short": short, "created_at": now, "ttl": ttl_epoch})
    return JSONResponse({"results": out}, headers={"Cache-Control": "no-store"})

@app.get("/stats/{short_id}")
def stats(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(404, "not found")
    return {
        "id": item.get("id"),
        "url": item.get("url"),
        "created_at": item.get("created_at"),
        # creator_ip removed per request
        "ttl": item.get("ttl"),
        "hits": item.get("hits", 0),
    }
