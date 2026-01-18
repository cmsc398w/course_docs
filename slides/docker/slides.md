---
theme: default
title: Docker - CMSC398W
info: |
  ## Docker Presentation
  Introduction to Docker, containers, images, and Docker Compose
class: text-center
highlighter: shiki
drawings:
  persist: false
transition: slide-left
mdc: true
---

# CMSC398W

## Docker

---
layout: default
---

# Review Question

<div class="text-lg">

In a smart home system project, the software currently controls lighting, thermostats, and security cameras. We're now adding support for smart kitchen appliances, which requires integrating with new APIs, updating the UI, and adding new automation rules. These changes are significant and could affect existing functionality.

**Question:** How would you use **Continuous Integration (CI)** to manage and validate these updates during development? What specific components would be included in your CI pipeline, and how would it help maintain reliability and speed up development?

</div>

---
layout: section
---

# Docker Architecture

---
layout: default
---

# What is Docker?

<div class="grid grid-cols-2 gap-4">

<div>

## The Problem

Apps often break on other machines due to missing dependencies

**Example:** Pac-Man needs specific Python + Pygame versions

## Options for Sharing

1. Share app and ask users to install dependencies
2. Package app with dependencies
3. Ship a pre-configured machine (overkill)

</div>

<div>

## Docker = Modern Solution

**Docker = Clean, modern version of option 2**

- Packages app + dependencies into a portable unit (**container**)
- Works the same on any computer, server, or cloud
- Removes "it works on my machine" issues

<div class="mt-6 p-4 bg-blue-500 bg-opacity-10 rounded">

By isolating your app in a container, Docker makes it easier to deploy, scale, and manage apps across different environments.

</div>

</div>

</div>

<!--
Imagine you're building a game – let's say Pac-Man. You're using Python 3.11 and Pygame 2.3, and it runs perfectly on your machine.
Now, you send this game to your friend or a customer, and they get errors like "Module not found" or "Incompatible library version."
Why? Because their environment is different. They might have Python 3.8 or no Pygame at all. This is a super common issue in software development.

Docker provides a clean, modern take on packaging.
It lets you package your app + all its dependencies into a unit called a container. That container behaves exactly the same no matter where you run it.
You can think of it like giving someone a zip file that runs itself – no setup, no installation headaches.
-->

---
layout: default
---

# What are Containers?

<div class="grid grid-cols-2 gap-6">

<div>

## Definition

Self-contained environments for apps

**Include:** code, runtime, libraries, configs

## Properties

- **Isolated** – no interference between containers
- **Portable** – runs across dev, cloud, CI/CD, etc.
- **Efficient** – shares host OS kernel

</div>

<div>

## Key Insight

<div class="p-4 bg-yellow-500 bg-opacity-10 rounded mb-4">

Containers often include parts of an OS but reuse host kernel

**Not full virtual machines** – but can achieve similar isolation for many use cases

</div>

## Example Commands

```bash
# Build container
docker build -t flask-container-demo .

# Run container
docker run -d -p 8080:5000 \
  --name my-flask-app flask-container-demo

# See running containers
docker ps

# View logs
docker logs my-flask-app

# Stop container
docker stop my-flask-app
```

</div>

</div>

<!--
Containers have three main properties:
- Self-contained: they have everything the app needs
- Isolated: they don't mess with other containers or the host system
- Portable: once built, you can run them anywhere Docker is available

Containers are NOT just mini virtual machines. While VMs include a full operating system including their own kernel, containers reuse the host OS kernel. This makes them much faster to start and less resource-hungry.
-->

---
layout: default
---

# What is an Image?

<div class="grid grid-cols-2 gap-6">

<div>

## Definition

A Docker image is a **snapshot** that includes:

- Application code and libraries and dependencies
- Runtime (e.g. Python, Node.js)
- Configuration files and environment setup

## Key Analogy

<div class="p-4 bg-green-500 bg-opacity-10 rounded">

**An image is to a container what an executable is to a process**

Just like multiple processes can run from one binary, multiple containers can run from one image

</div>

</div>

<div>

## Key Properties

- **Immutability** – once built, the image doesn't change
- **Layered structure** – each change adds a new layer (cached for efficiency)
- **Efficiency** – layers can be reused across images

## Example Commands

```bash
# Build image
docker build -t flask-image-demo .

# Run multiple containers from same image
docker run -d -p 5001:5000 \
  --name container1 flask-image-demo
docker run -d -p 5002:5000 \
  --name container2 flask-image-demo

# View images
docker images

# See image layers
docker history flask-image-demo
```

</div>

</div>

<!--
Every time you modify an image – say by adding a file or installing a package – Docker adds a new layer. These layers are cached and reused when possible, which makes builds faster and more efficient.

Think of Docker images as the foundation for containers. They're reusable, shareable, and make it incredibly easy to spin up consistent environments.
-->

---
layout: default
---

# What is a Registry?

<div class="grid grid-cols-2 gap-6">

<div>

## Definition

A **registry** is a centralized place to store and share container images, like a library for Docker images

There are both **public** and **private** registries

## Registry vs. Repository

- **Registry:** Central storage system for images (e.g., Docker Hub)
- **Repository:** A collection of related images within a registry, grouped by project/application
  - Example: `python:3.9`, `python:3.10` in Docker Hub

</div>

<div>

## Popular Registries

- **Docker Hub** (default)
- GitHub Container Registry
- Google Artifact Registry
- Amazon ECR
- Private registries

## Example Commands

```bash
# Pull image from registry
docker pull python:3.11-slim

# Build image
docker build -t my-flask-app .

# Tag for registry
docker tag my-flask-app username/my-flask-app

# Push to registry
docker push username/my-flask-app

# Run from registry
docker run -p 5800:5000 my-flask-app
```

</div>

</div>

<!--
Any time you run docker pull or docker push, you're interacting with a registry behind the scenes.

Registries are critical in real-world DevOps workflows:
- Developers pull base images from registries to build their apps
- CI/CD pipelines push new images to registries after each build or release
- Deployments in staging or production often pull directly from registries

You can think of a registry like GitHub, and a repository like a Git repo inside it.
-->

---
layout: center
class: text-center
---

# Multiple Choice Question

<div class="text-left max-w-3xl mx-auto text-lg">

Your team builds a Flask app and wants everyone to run it the same way on their laptops and in CI. What is the correct workflow using Docker concepts?

<v-clicks>

<div class="p-3 my-2 border-2 border-gray-300 rounded">
A. Each developer runs the app locally, and Docker syncs their changes into a shared container
</div>

<div class="p-3 my-2 border-2 border-green-500 rounded bg-green-500 bg-opacity-10">
✓ B. You build a Docker image for the app, push it to a registry, and teammates run containers from that image
</div>

<div class="p-3 my-2 border-2 border-gray-300 rounded">
C. You upload your Dockerfile directly to the registry, and it auto-runs the app for everyone
</div>

<div class="p-3 my-2 border-2 border-gray-300 rounded">
D. You create one container on your machine and share the container file with teammates to run it
</div>

</v-clicks>

</div>

<!--
Correct answer: B

The proper workflow is to build an image, push it to a registry (like Docker Hub), and have teammates pull and run containers from that image.
-->

---
layout: default
---

# What is Docker Compose?

<div class="grid grid-cols-2 gap-6">

<div>

## Definition

Docker Compose is a tool for defining and running **multi-container** Docker applications using a single YAML configuration

## Key Concepts

- **Declarative Configuration** – define everything in YAML
- **Multi-container Applications** – manage multiple services
- **Service Definition** – specify images, ports, volumes, etc.

</div>

<div>

## Benefits

- Simplifies Multi-container Environments
- Automatic networking between services
- Consistency across development and production

## Example Commands

```bash
# Build and start all services
docker-compose up --build

# Run in background
docker-compose up -d

# Stop and clean up
docker-compose down

# View logs from all services
docker-compose logs

# See running services
docker-compose ps
```

</div>

</div>

<!--
In real-world apps, you probably have:
- A frontend (React)
- A backend (Flask API)
- A database (PostgreSQL)

Docker Compose lets you define your entire multi-container application in a single YAML file. Then you just run docker-compose up, and Docker does the rest – it spins up all the containers, sets up the network, handles dependencies, and more.

Services can automatically talk to each other by name. For example, if your Flask API needs to talk to the database, it can just connect to postgres:5432.
-->

---
layout: center
---

# Docker Architecture Diagram

<div class="flex justify-center">

```mermaid
graph TB
    Client[Docker Client<br/>docker build, pull, run]
    Daemon[Docker Daemon<br/>dockerd]
    Registry[Registry<br/>Docker Hub]
    Images[Images]
    Containers[Containers]
    
    Client -->|Docker API| Daemon
    Daemon -->|pull/push| Registry
    Daemon -->|manages| Images
    Daemon -->|creates/runs| Containers
    Images -->|instantiate| Containers
    
    style Client fill:#3b82f6,color:#fff
    style Daemon fill:#10b981,color:#fff
    style Registry fill:#f59e0b,color:#fff
    style Images fill:#8b5cf6,color:#fff
    style Containers fill:#ec4899,color:#fff
```

</div>

<!--
The image shows how Docker works behind the scenes. You run commands like build, pull, and run from the client, and these commands are sent to the Docker daemon. The daemon manages images and uses them to create containers. Images come from a registry like Docker Hub, and the daemon can pull or push images there. Containers are running instances of those images on the Docker host.
-->

---
layout: section
---

# Building Images

---
layout: default
---

# Image Layers

<div class="grid grid-cols-2 gap-6">

<div>

## How Layers Work

Each layer represents a set of **filesystem changes**:
- Additions
- Deletions
- Modifications

## Properties

- Each layer adds specific changes to the filesystem
- Layers are **immutable** and can be reused
- Union Filesystem stacks layers together

</div>

<div>

## Layer Example

```dockerfile
FROM python:3.11-slim          # Layer 1
WORKDIR /app                    # Layer 2
COPY requirements.txt .         # Layer 3
RUN pip install -r requirements.txt  # Layer 4
COPY . .                        # Layer 5
CMD ["python", "app.py"]        # Layer 6
```

## Benefits

- **Caching** – reuse unchanged layers
- **Efficiency** – share layers across images
- **Speed** – faster builds and deploys

</div>

</div>

<!--
Every Docker image is made up of layers. Think of these as a stack of changes.

Here's where it gets really clever – layers are immutable and cached. This means Docker doesn't have to rebuild everything from scratch each time. If you only change your code, it can reuse the earlier Python and Flask layers, which saves a ton of time and storage.

The magic behind this system is called a union filesystem. This allows Docker to stack these layers into what looks like a single filesystem from inside the container.
-->

---
layout: default
---

# Layer Caching Example

<div class="grid grid-cols-2 gap-6">

<div>

## Initial Build

```bash
docker build -t layer-demo .
```

Docker will:
1. Pull the base image → **Layer 1**
2. Set the workdir → **Layer 2**
3. Install Flask → **Layer 3**
4. Copy the code → **Layer 4**
5. Set the run command → **Layer 5**

## Modify Just `app.py`

Change one line in `app.py`:

```python
return "Changed layer test!"
```

</div>

<div>

## Rebuild

```bash
docker build -t layer-demo .
```

Docker will **reuse layers 1–3** and only rebuild layer 4 and 5

## Inspect Layers

```bash
docker history layer-demo
```

<div class="mt-6 p-4 bg-blue-500 bg-opacity-10 rounded">

**Key Insight:** If you modify `requirements.txt`, Docker will invalidate layer 3 and rebuild everything from there onward.

</div>

</div>

</div>

---
layout: default
---

# Dockerfile Basics

<div class="grid grid-cols-2 gap-6">

<div>

## What is a Dockerfile?

A Dockerfile is a **text document** that defines the steps for building a Docker image

- Automates the image-building process
- Creates consistent and reproducible environments
- Customizable for your app's specific needs

## How It Works

1. Docker reads the Dockerfile line by line
2. Each instruction creates a new layer
3. The result is an image ready to run

</div>

<div>

## Common Instructions

- `FROM` – Base image to use
- `WORKDIR` – Set working directory
- `COPY` – Copy files from host to container
- `ADD` – Copy with extraction support
- `RUN` – Execute shell commands
- `ENV` – Set environment variables
- `EXPOSE` – Document ports
- `CMD` – Default command to run
- `ENTRYPOINT` – Configurable entry point

## Benefits

- **Customizable** – define exactly how to set up environment
- **Versionable** – track changes in Git
- **Portable** – same Dockerfile works anywhere

</div>

</div>

<!--
Instead of manually creating a container, installing software inside it, and then saving the result – you write down all those steps in a Dockerfile. This lets you automate the image-building process, which is critical for reproducibility and collaboration.

Every one of these instructions creates a new layer in the image. So you're not just building the app – you're building a structured, layered environment.
-->

---
layout: default
---

# Dockerfile Example

<div class="grid grid-cols-2 gap-6">

<div>

## Step-by-Step Dockerfile

```dockerfile
# Step 1: Base Image
FROM python:3.11-slim

# Step 2: Set Working Directory
WORKDIR /app

# Step 3: Copy Dependency File
COPY requirements.txt .

# Step 4: Install Dependencies
RUN pip install -r requirements.txt

# Step 5: Copy Application Code
COPY . .

# Step 6: Set Default Run Command
CMD ["python", "app.py"]
```

</div>

<div>

## Why Each Step?

<v-clicks>

- **FROM** – Start with minimal Python environment (Layer 1)
- **WORKDIR** – Set `/app` as working directory (Layer 2)
- **COPY requirements.txt** – Copy dependencies early for caching (Layer 3)
- **RUN pip install** – Install libraries (Layer 4, cached unless requirements change)
- **COPY . .** – Copy source code (Layer 5)
- **CMD** – Define runtime command (Layer 6)

</v-clicks>

<div v-click class="mt-6 p-4 bg-green-500 bg-opacity-10 rounded">

**Pro Tip:** Copy dependencies before code to leverage layer caching. Code changes often, dependencies don't.

</div>

</div>

</div>

---
layout: center
---

# Complete Dockerfile Reference

<div class="grid grid-cols-3 gap-4 text-sm">

<div>

## Base & Environment

```dockerfile
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production
USER node
```

</div>

<div>

## Files & Dependencies

```dockerfile
COPY package*.json ./
RUN npm ci --only=production
COPY --chown=node:node . .
```

</div>

<div>

## Runtime

```dockerfile
EXPOSE 3000
HEALTHCHECK --interval=30s \
  CMD node healthcheck.js
ENTRYPOINT ["node"]
CMD ["server.js"]
```

</div>

</div>

<div class="mt-8 text-lg">

## Key Differences

- **CMD** – Can be overridden at runtime: `docker run image custom-command`
- **ENTRYPOINT** – Sets the main executable, CMD provides default arguments
- **RUN** – Executes during build (creates layers)
- **CMD** – Executes when container starts (runtime)

</div>

---
layout: default
---

# Building Images

<div class="grid grid-cols-2 gap-6">

<div>

## Build Process

Building a Docker image means executing the instructions in a Dockerfile to create an image

```bash
docker build .
```

The `.` specifies the **build context** (the directory containing the Dockerfile and other files)

## What Happens

1. Docker reads the Dockerfile
2. Executes each instruction step-by-step
3. Creates layers for each instruction
4. Each layer is **cached** for faster builds

</div>

<div>

## Multi-Stage Builds

Separate build and runtime environments to reduce final image size

```dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Runtime stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY package*.json ./
RUN npm ci --only=production
CMD ["node", "dist/server.js"]
```

<div class="mt-4 p-4 bg-purple-500 bg-opacity-10 rounded">

**Benefits:** Smaller images, fewer vulnerabilities, faster deployments

</div>

</div>

</div>

<!--
Multi-stage builds allow you to create one stage for building your app, and then a second stage that copies just the final output into a clean, minimal image.

For example, you could compile a Go or Node.js app in one stage, and then copy just the binary or built files into a slim alpine image for deployment. This helps keep your final image smaller, more secure, and free from unnecessary build dependencies.
-->

---
layout: default
---

# Docker Build Commands

<div class="grid grid-cols-2 gap-6">

<div>

## Basic Build

```bash
# Build from current directory
docker build .

# Build with tag
docker build -t my-app:latest .

# Build with specific Dockerfile
docker build -f Dockerfile.prod -t my-app:prod .

# Build with build arguments
docker build --build-arg VERSION=1.0 -t my-app .
```

## View Build History

```bash
# See all layers in an image
docker history my-app

# See image details
docker inspect my-app
```

</div>

<div>

## Advanced Options

```bash
# No cache (force rebuild all layers)
docker build --no-cache -t my-app .

# Multi-platform build
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t my-app:latest .

# Build and push to registry
docker build -t username/my-app:latest . && \
docker push username/my-app:latest

# Build with progress output
docker build --progress=plain -t my-app .
```

## BuildKit Features

Modern Docker uses **BuildKit** for:
- Parallel builds
- Better caching
- Secrets management
- SSH forwarding

</div>

</div>

---
layout: default
---

# Docker Compose Example

```yaml
version: '3.8'

services:
  # Frontend service
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend
    environment:
      - API_URL=http://backend:5000

  # Backend service
  backend:
    build: ./backend
    ports:
      - "5000:5000"
    depends_on:
      - database
    environment:
      - DATABASE_URL=postgresql://user:password@database:5432/mydb

  # Database service
  database:
    image: postgres:15-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=mydb

volumes:
  postgres_data:
```

---
layout: center
class: text-center
---

# Key Takeaways

<v-clicks>

<div class="text-xl mb-6">

🐳 **Docker** packages apps + dependencies into portable containers

</div>

<div class="text-xl mb-6">

📦 **Images** are immutable blueprints, **Containers** are running instances

</div>

<div class="text-xl mb-6">

🏗️ **Dockerfiles** define how to build images layer by layer

</div>

<div class="text-xl mb-6">

🔗 **Docker Compose** orchestrates multi-container applications

</div>

<div class="text-xl mb-6">

🚀 **Registries** enable sharing and deployment at scale

</div>

</v-clicks>
