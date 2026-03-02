# Social Sync Web

A full-stack web app to upload a video once and publish it across multiple social platforms from one dashboard.

## Features

- App-level passphrase authentication
- OAuth connections for YouTube, Instagram, Twitter/X, and TikTok
- Video upload pipeline using Cloudflare R2
- Publish flow with progress tracking
- Posting history and account settings
- Scheduled token refresh for supported platforms

## Tech Stack

- Frontend: React + Vite + React Query + Zustand
- Backend: Node.js + Express
- Data: Supabase
- Storage: Cloudflare R2

## Project Structure

```text
social-sync-web/
├── client/               # React frontend
├── server/               # Express backend
├── supabase-schema.sql   # Database schema
├── .env.example          # Required environment variables
└── DEPLOY.md             # Production deployment guide
```

## Prerequisites

- Node.js 18+
- npm 9+
- Supabase project
- Cloudflare R2 bucket
- OAuth app credentials for each social platform you want to use

## Local Development

1. Copy environment variables:

```bash
cp .env.example .env
```

2. Fill in `.env` values (secrets + platform credentials).

3. Install dependencies:

```bash
npm run install:all
```

4. Start frontend and backend together:

```bash
npm run dev
```

5. Open the app:

- Frontend: `http://localhost:5173`
- Backend health: `http://localhost:3001/api/health`

## Scripts

### Root

- `npm run install:all` - install server and client dependencies
- `npm run dev` - run backend and frontend concurrently

### Server (`server/`)

- `npm run dev` - start with file watching
- `npm start` - start production server

### Client (`client/`)

- `npm run dev` - start Vite dev server
- `npm run build` - production build
- `npm run preview` - preview production build

## Environment Variables

Use `.env.example` as the source of truth for required variables:

- App security (`APP_PASSPHRASE`, `JWT_SECRET`, `SESSION_SECRET`)
- Supabase (`SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`)
- R2 (`R2_ACCOUNT_ID`, bucket + keys)
- OAuth credentials and redirect URIs for each platform
- Runtime config (`PORT`, `FRONTEND_URL`, `NODE_ENV`)

## Deployment

Production deployment instructions are in `DEPLOY.md`:

- Frontend: Vercel
- Backend: Render
- Database: Supabase
- Storage: Cloudflare R2

## Security Notes

- Never commit `.env` or secret keys.
- Keep `SUPABASE_SERVICE_ROLE_KEY` server-side only.
- Use strong generated secrets for JWT/session values.
