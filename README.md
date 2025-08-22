# WOTR Atlas — Getting Started

This repo is set up to run in **three modes** from the same codebase:

- **Dev-Code**: Backend + Frontend in your IDE; **DB + Caddy** in Docker
- **Dev-Stack**: Everything in Docker locally
- **Prod**: Docker on a Linux server behind Caddy (HTTPS, domain)

Caddy fronts the app so you can always visit `http://localhost` (or your domain in prod).  
API requests go to `/api/*` and are reverse-proxied to the backend.

---

## Prerequisites

- **Docker Desktop** (or Docker Engine on Linux)
- **Node.js** 20+ (for Angular dev)
- **Java 21** (for backend dev)
- **IntelliJ IDEA** (recommended) or your favorite editor

> Windows users: run terminal commands in **PowerShell** unless noted.

---

## Repo Layout (high level)

```
backend/                          # Spring Boot API
frontend/                         # Angular app
Caddyfile                         # Base Caddy config (Dev-Stack, Prod)
Caddyfile.dev                     # Dev-Code Caddy config (for Angular dev server)
docker-compose.yml                # Core stack (do not modify)
docker-compose.override.yml       # Dev overrides (envs/volumes for Caddy dev)
.env.example                      # Template you copy into mode-specific env files
```

---

## 0) One-time Setup

### Copy env templates (per mode)

**macOS/Linux (or Git Bash/WSL):**
```bash
cp .env.example dev-code.env
cp .env.example dev-stack.env
cp .env.example prod.env
```

**Windows PowerShell:**
```powershell
Copy-Item .env.example dev-code.env
Copy-Item .env.example dev-stack.env
Copy-Item .env.example prod.env
```

### Fill in the env files

Open each of `dev-code.env`, `dev-stack.env`, and `prod.env` and set values.

**What’s in `.env.example` (safe to commit):**
```env
# Postgres (used by docker compose)
POSTGRES_USER=wotr
POSTGRES_PASSWORD=change_me_strong
POSTGRES_DB=wotr-atlas

# Caddy (TLS cert email for prod)
ACME_EMAIL=you@wotr-atlas.com

# Dev-Code only: how Caddy reaches your IDE apps
SITE=:80
BACKEND_UPSTREAM=host.docker.internal:8080
FRONTEND_UPSTREAM=host.docker.internal:4200

# If you are not using SSO yet, set a JWT secret per environment (see notes below)
JWT_SECRET=
```

> **Do not commit** your filled `.env` files. Only commit `.env.example`.

### Backend dev profile: set a JWT secret

For dev we use an HMAC secret (HS256) so you don’t need an external IdP.

Edit `backend/src/main/resources/application-dev.properties` and set:

```properties
# at least 32 bytes; long random string recommended
jwt.secret=<paste a random secret here>
```

Generate a secret:

- **Windows PowerShell**
  ```powershell
  $b = New-Object byte[] 48
  [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($b)
  [Convert]::ToBase64String($b)
  ```
- **macOS/Linux**
  ```bash
  openssl rand -base64 48
  ```

> In **prod**, prefer SSO (OIDC) with Microsoft Entra ID (Azure AD). If you must ship before SSO, use **RS256** with a public key in the app and keep the private key outside the repo/server (see “Auth Strategy” below).

---

## 1) Dev-Code (IDE FE+BE; DB + Caddy in Docker)

**Start DB + Caddy**
```powershell
docker compose --env-file dev-code.env up -d --no-deps db caddy
```

**Start Frontend (Angular)**
```powershell
cd frontend
npm install
# This script runs the Angular dev server on 0.0.0.0:4200
# Our Caddyfile.dev spoofs Host so no extra flags are needed.
npm run start:caddy
```

**Start Backend (Spring Boot)**
- IntelliJ run config `BE: dev`, or:
```powershell
# from backend/
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

**Open the app**
```
http://localhost
```

**Sanity checks**
```powershell
# through Caddy
curl.exe -i http://localhost/api/ping
curl.exe -i http://localhost/actuator/health
```

**Stop (Dev-Code)**
```powershell
docker compose stop caddy db
```

### What Dev-Code does under the hood

- Uses **`Caddyfile.dev`** which forwards:
  - `/api/*` → `host.docker.internal:8080` (backend in your IDE)
  - everything else → `host.docker.internal:4200` (Angular dev server)
  - and rewrites the `Host` header to `localhost:4200` to satisfy Angular dev server

---

## 2) Dev-Stack (everything in Docker locally)

**Start all services**
```powershell
docker compose --env-file dev-stack.env up -d --build
```

- Angular is built and served by the `frontend` container (nginx).
- Caddy uses base `Caddyfile` (no dev header rewrite).

**Open**
```
http://localhost
```

**Stop**
```powershell
docker compose down
```

---

## 3) Production (Linux server)

**Prereqs**
- Ubuntu 22.04+ (or similar)
- Open firewall ports **80** and **443**
- DNS: point `A`/`AAAA` records for `www.wotr-atlas.com` (and root, if desired) to your server IP

**Prepare secrets**
- Edit `prod.env` on the server (do **not** commit). At minimum:
  ```
  POSTGRES_USER=...
  POSTGRES_PASSWORD=...
  POSTGRES_DB=wotr-atlas
  ACME_EMAIL=ops@wotr-atlas.com
  # If not using SSO yet, set JWT_SECRET or (preferably) use RS256 public key validation
  JWT_SECRET=...
  ```
  Save as `prod.env` and restrict perms:
  ```bash
  chmod 600 prod.env
  ```

**Start**
```bash
docker compose --env-file prod.env up -d --build
```

- Caddy will request/renew TLS certs automatically for your domain.
- Visit:
  ```
  https://www.wotr-atlas.com
  ```

---

## Caddy Configs (reference)

**`Caddyfile`** (Dev-Stack + Prod)
```caddy
# In prod, replace :80 with your domain:
# www.wotr-atlas.com {
:80 {
  encode gzip

  @api path /api/* /actuator/*
  handle @api {
    reverse_proxy wotr-backend:8080
  }

  handle {
    reverse_proxy wotr-frontend:80
  }
}
```

**`Caddyfile.dev`** (Dev-Code only: spoofs Host to Angular dev server)
```caddy
{$SITE} {
  encode gzip

  @api path /api/* /actuator/*
  handle @api {
    reverse_proxy {$BACKEND_UPSTREAM}
  }

  handle {
    reverse_proxy {
      to {$FRONTEND_UPSTREAM}
      header_up Host localhost:4200
      header_up X-Forwarded-Host localhost:4200
      header_up X-Forwarded-Proto http
    }
  }
}
```

---

## Auth Strategy (Prod)

**Preferred (Enterprise)**: **SSO with Microsoft Entra ID (OIDC)**
- Angular uses MSAL to get access tokens for your API scope.
- Spring Boot (prod profile) validates JWTs from Entra:
  ```properties
  spring.security.oauth2.resourceserver.jwt.issuer-uri=https://login.microsoftonline.com/<tenant-id>/v2.0
  # optionally: spring.security.oauth2.resourceserver.jwt.jwk-set-uri=...
  ```
- Result: no app-managed secrets; tokens are validated against Entra’s public keys.

**Interim (if SSO not ready)**
- Prefer **RS256**:
  - Generate keys:
    ```bash
    openssl genrsa -out jwt.key 4096
    openssl rsa -in jwt.key -pubout -out jwt.pub
    ```
  - App uses **public** key to validate tokens:
    ```properties
    spring.security.oauth2.resourceserver.jwt.public-key-location=file:/run/secrets/jwt.pub
    ```
  - Keep the **private** key in your issuer service (not in this app or repo).

---

## IntelliJ Run Configs (shared)

We commit shared run configs so everyone has the same buttons.

- **Frontend**: `FE: start:caddy` → runs `npm run start:caddy` in `frontend/`
- **Backend**: `BE: dev` → runs `WotrAtlasApiApplication` with profile `dev`

They live under `.idea/runConfigurations/` and are kept in git.
If yours are missing, create them and check “Share through VCS”.

---

## Troubleshooting

- **Port already in use (8080/4200/80/5432)**  
  Stop stray services:
  ```powershell
  docker compose stop backend frontend caddy db
  ```
  Change IDE ports or stop local servers occupying those ports.

- **`http://localhost` shows 502 in Dev-Code**  
  Ensure Caddy is running:
  ```powershell
  docker ps
  docker logs wotr-caddy --tail=100
  ```
  Ensure Angular dev server is on **0.0.0.0:4200**:
  ```powershell
  cd frontend && npm run start:caddy
  ```
  From inside the Caddy container:
  ```powershell
  docker exec -it wotr-caddy sh -lc "wget -qO- http://127.0.0.1/ | head -n 5"
  ```

- **Auth 401/403 on `/api/*` in dev**  
  Dev profile opens `/api/ping` and `/actuator/health`. If other routes are protected, that’s expected—log in via your dev flow or temporarily open specific endpoints in `SecurityDevConfig`.

- **DB password/auth errors**  
  Ensure `POSTGRES_*` in your chosen `*.env` matches your DB, and that the backend points at the right URL:
  ```
  jdbc:postgresql://127.0.0.1:5432/wotr-atlas
  ```
  (Dev-Stack/Prod containers use `jdbc:postgresql://db:5432/wotr-atlas` via compose envs.)

- **Windows firewall blocks Angular dev server**  
  The first time Angular binds to `0.0.0.0:4200`, allow it on **Private** networks.

---

## Useful Commands

```powershell
# Recreate only Caddy after changing env/Caddyfile
docker compose --env-file dev-code.env up -d --no-deps --force-recreate caddy

# Tail logs
docker logs -f wotr-caddy
docker logs -f wotr-backend
docker logs -f wotr-frontend
docker logs -f wotr-db

# Rebuild a single service
docker compose up -d --build backend
```

---

## Contributing

- Don’t commit secrets. Only commit `.env.example`.
- Keep run configs shareable (use `$PROJECT_DIR$` paths).
- Keep `/api/*` **relative** in the frontend so Caddy can route.

---

## ASCII Flow (cheatsheet)

```
Dev-Code:
Browser → http://localhost → Caddy (Docker)
  ├─ /api/*  → host.docker.internal:8080 (Backend in IDE)
  └─ /*      → host.docker.internal:4200 (Angular dev server)

Dev-Stack:
Browser → http://localhost → Caddy (Docker)
  ├─ /api/*  → wotr-backend:8080
  └─ /*      → wotr-frontend:80

Prod:
Browser → https://www.wotr-atlas.com → Caddy (TLS)
  ├─ /api/*  → wotr-backend:8080
  └─ /*      → wotr-frontend:80
```
