# - Comment, ignored by docker
# - Docker Directives/instructions will be in UPPER CASE
# FROM -> used for specifying base image
FROM node:22-alpine AS build

# RUN -> run commands
RUN mkdir /lms-app

# WORKDIR ->  set project path
WORKDIR /lms-app

# COPY -> used for copying files from HOST to YOUR CUSTOM IMAGE
COPY . /lms-app

# Prepare Build
RUN npm install
RUN npm run build

# Prepare Deployment
FROM nginx:alpine

# Copy Build Artifacts
COPY --from=build /lms-app/build /usr/share/nginx/html
