# Technical Installation Manual

## Introduction

This manual provides detailed instructions for cloning and configuring the system. Our application consists of a frontend mobile application, a backend service, smaller services such as storage and notification plugins, and a gateway service. The backend and gateway are built with Spring Boot and Gradle, while the storage and notification services use NestJS. The frontend is developed using Flutter and Dart. All components, except the mobile frontend, are deployed as a single Docker container. The backend can be installed and run in 2 ways: as a Docker container or as individual modules.

## Prerequisites

Before installing the system, ensure that the following prerequisites are met:

- **Git**: For cloning the repository.
- **Docker**: For running the containerized backend services (depending on your choice of running the backend).
- **Flutter SDK**: For building and running the mobile frontend.
- **Node.js** and **Java JDK 21**: Required for running NestJS services and backend and gateway services (depending on your choice of running the backend).

### Installation of Prerequisites

#### Git

- **Windows**: Download and install Git from [Git for Windows](https://gitforwindows.org/). Follow the installation prompts.
- **macOS**: Install Git using Homebrew with the command: `brew install git`.
- **Linux**: Install Git using your package manager, e.g., `sudo apt-get install git` for Debian-based distributions.

#### Docker

- **Windows/macOS**: Download and install Docker Desktop from [Docker Desktop](https://www.docker.com/products/docker-desktop). Follow the installation prompts.
- **Linux**: Install Docker using your package manager, e.g., `sudo apt-get install docker-ce` for Debian-based distributions. Refer to Docker’s [official documentation](https://docs.docker.com/engine/install/) for detailed instructions.

#### Flutter SDK

- **Windows/macOS/Linux**: Follow the installation instructions on the [Flutter website](https://flutter.dev/docs/get-started/install).

#### Node.js

- **Windows/macOS/Linux**: Download and install Node.js from the [Node.js official website](https://nodejs.org/).

## Installation

### Cloning the Repository

1. Open a terminal or command prompt.
2. Clone the repository using the command:
   ```bash
   git clone https://github.com/COS301-SE-2024/WhatsOn-UP.git

3. Navigate to the project directory:
   ```bash
   cd WhatsOn-UP
   ```

### Running the Docker Container

1. Ensure Docker is running.
2. Open your terminal.
3. Log in to Docker Hub (the image is hosted on a private registry). Email `devforce.capstone@gmail.com` for the credentials.
   ```bash
   docker login
   ```
4. Pull the Docker image:
   ```bash
   docker pull devforce123/backend
   ```
5. Run the Docker container:
   ```bash
   docker run -d --name backend -p 8085:8085 devforce123/backend
   ```

### Building and Running Backend and Gateway Services with Java SDK

*(Before proceeding, email `devforce.capstone@gmail.com` to obtain the environmental variables.)*

1. Navigate to the backend directory:
   ```bash
   cd src/Backend
   ```
2. Build the services using Gradle:
   ```bash
   ./gradlew build
   ```
3. Run the services:
   ```bash
   ./gradlew bootRun
   ```
   The service will start running on port 8080.

4. Navigate to the gateway directory:
   ```bash
   cd src/gateway
   ```
5. Build the services using Gradle:
   ```bash
   ./gradlew build
   ```
6. Run the services:
   ```bash
   ./gradlew bootRun
   ```
   The service will start running on port 8085.

### Building and Running Storage and Notification Services

*(Before proceeding, email `devforce.capstone@gmail.com` to obtain the `.env` file.)*

1. Navigate to the storage-service directory:
   ```bash
   cd storage-service
   ```
2. Install dependencies and start the services:
   ```bash
   npm install
   npm start
   ```
   The service will start running on port 8083.

3. Navigate to the notification-service directory:
   ```bash
   cd notification-service
   ```
4. Install dependencies and start the services:
   ```bash
   npm install
   npm start
   ```
   The service will start running on port 8081 for the notification endpoints and port 8082 for the websockets.

### Building and Running the Frontend

1. Navigate to the Flutter project directory:
   ```bash
   cd Frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the Flutter app:
   ```bash
   flutter run
   ```

## Deployment/Running

To deploy and run the system:

1. Ensure all services are running as described above.
2. Access the application via the mobile frontend.
3. For detailed usage instructions, refer to the User Manual.

