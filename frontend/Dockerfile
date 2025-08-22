# ---- build (Node) ----
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
# If your Angular project lives in a subfolder, cd into it before the build
RUN npm run build -- --configuration=production

# Angular 15+: dist/<project-name>/ contains the compiled site.
# If your dist path differs, adjust the COPY below.
# ---- runtime (nginx) ----
FROM nginx:1.27-alpine
# remove default site
RUN rm -rf /usr/share/nginx/html/*
# copy built static files
COPY --from=build /app/dist/ /usr/share/nginx/html/
# health check & port
EXPOSE 80
