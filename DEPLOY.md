# Social Sync — Deployment Guide

Full stack: **Vercel** (frontend) + **Render** (backend) + **Supabase** (database) + **Cloudflare R2** (video storage)

All services have generous free tiers. No credit card required for any of them.

---

## 1. Supabase (Database)

1. Sign up at [supabase.com](https://supabase.com) → **New Project**
2. Choose a region close to you, set a strong DB password
3. Go to **SQL Editor → New Query**, paste the contents of `supabase-schema.sql`, and run it
4. Go to **Settings → API** and copy:
   - **Project URL** → `SUPABASE_URL`
   - **service_role** key (secret, bottom of page) → `SUPABASE_SERVICE_ROLE_KEY`

---

## 2. Cloudflare R2 (Video Storage)

1. Sign up at [cloudflare.com](https://cloudflare.com) → **R2 Object Storage → Create bucket**
2. Name it `social-sync-uploads` (or anything — update `R2_BUCKET_NAME`)
3. **Enable public access**: Bucket → Settings → Public Access → Allow Access → copy the public URL domain → `R2_PUBLIC_DOMAIN`
4. Go to **R2 → Manage R2 API Tokens → Create API Token**
   - Permissions: **Object Read & Write**
   - Scope: this specific bucket
   - Copy **Access Key ID** → `R2_ACCESS_KEY_ID`
   - Copy **Secret Access Key** → `R2_SECRET_ACCESS_KEY`
5. Your **Account ID** is in the right sidebar of the Cloudflare dashboard → `R2_ACCOUNT_ID`

---

## 3. Render (Backend)

1. Sign up at [render.com](https://render.com) → **New → Web Service**
2. Connect your GitHub repo (push this project first — see Git Setup below)
3. Configure:
   - **Root directory**: `server`
   - **Build command**: `npm install`
   - **Start command**: `node index.js`
   - **Instance type**: Free
4. Add all environment variables from `.env.example` (with real values) under **Environment**
5. After deploy, note your Render URL: `https://your-app.onrender.com`
6. Update all platform redirect URIs in `.env` / Render env vars to use this URL

> ⚠️ **Free tier caveat**: Render free tier spins down after 15 minutes of inactivity.
> First request after sleep takes ~30 seconds to wake up. Upgrade to Starter ($7/mo) for always-on.

---

## 4. Vercel (Frontend)

1. Sign up at [vercel.com](https://vercel.com) → **New Project → Import Git Repository**
2. Configure:
   - **Root directory**: `client`
   - **Build command**: `npm run build`
   - **Output directory**: `dist`
3. Add environment variable:
   - `VITE_API_URL` = `https://your-render-app.onrender.com`
4. Deploy → note your Vercel URL: `https://your-app.vercel.app`
5. Go back to Render → set `FRONTEND_URL` = `https://your-app.vercel.app`
6. Redeploy the Render service so the CORS change takes effect

---

## 5. Git Setup

```bash
cd /path/to/social-sync-web
git init
git add .
git commit -m "Initial commit"
# Create a new repo on GitHub, then:
git remote add origin https://github.com/youruser/social-sync-web.git
git push -u origin main
```

---

## 6. Platform API Credentials

Update the redirect URIs in each developer portal from `localhost` to your Render URL:

| Platform | Portal | Redirect URI |
|---|---|---|
| YouTube | [Google Cloud Console](https://console.cloud.google.com) | `https://your-render.onrender.com/api/auth/youtube/callback` |
| Instagram | [Meta Developers](https://developers.facebook.com) | `https://your-render.onrender.com/api/auth/instagram/callback` |
| Twitter/X | [developer.twitter.com](https://developer.twitter.com) | `https://your-render.onrender.com/api/auth/twitter/callback` |
| TikTok | [developers.tiktok.com](https://developers.tiktok.com) | `https://your-render.onrender.com/api/auth/tiktok/callback` |

---

## 7. Security Checklist

- [ ] `APP_PASSPHRASE` is strong (16+ chars)
- [ ] `JWT_SECRET` is a random 32+ char hex string
- [ ] `SESSION_SECRET` is a random 32+ char hex string
- [ ] `SUPABASE_SERVICE_ROLE_KEY` is **never** exposed to the frontend
- [ ] R2 bucket public access is read-only (uploads are auto-deleted after publishing)
- [ ] Render environment variables are set (not committed to git)
- [ ] `.env` file is in `.gitignore`

---

## Local Development

```bash
# 1. Copy and fill in env
cp .env.example .env
# edit .env — use localhost URLs for all redirect URIs

# 2. Install dependencies
npm run install:all

# 3. Start both servers
npm run dev
```

Open http://localhost:5173

---

## Generate Secrets

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```
Run this twice — once for `JWT_SECRET`, once for `SESSION_SECRET`.
