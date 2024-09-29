# ResumeAI

ResumeAI is a tool that allows users to generate, update, and enhance their resumes using the power of OpenAI's GPT API. This project comprises a backend and a frontend, both of which work in coordination to provide a seamless experience for generating professional resumes and cover letters.

## Table of Contents

- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Backend Setup](#backend-setup)
  - [Frontend Setup](#frontend-setup)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)
  - [Push Docker Images to Amazon ECR](#push-docker-images-to-amazon-ecr)
  - [Deploy to Amazon EKS](#deploy-to-amazon-eks)
  - [Deploy to Minikube](#deploy-to-minikube)
- [CI/CD with Jenkins](#cicd-with-jenkins)
  - [Setup Jenkins Pipeline](#setup-jenkins-pipeline)
- [Tech Stack](#tech-stack)
- [License](#license)

## Project Structure

- **Backend**: Node.js application that serves as the backend, handling requests, interacting with the OpenAI API, sending emails, and managing data in MongoDB.
- **Frontend**: A separate Node.js application providing a user interface to interact with the backend for generating and managing resumes.

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (Version 18 or higher)
- Docker
- Kubernetes (Amazon EKS or Minikube)
- Jenkins for CI/CD
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) or a local instance of MongoDB for storing data

### Backend Setup

1. Clone the repository:

   ```sh
   git clone https://github.com/Sukhilnair/ResumeAI.git
   cd ResumeAI
   ```
2. Navigate to the backend directory:
    ```sh
    cd ResumeBuilderBackend
    ```
3. Create an environment file (.env) with the necessary configuration variables.
    Refer to [Environment Variables](#environment-variables) for more details.

4. To run the backend locally, you can use Docker. Create a Dockerfile with the following contents:

    ```Dockerfile
    Copy code
    FROM node:18
    WORKDIR /app
    COPY package*.json ./
    COPY . .
    RUN npm install
    RUN npm install -g typescript
    RUN npm run build
    RUN apt-get update && apt-get install -y chromium
    EXPOSE 4292
    CMD [ "npm", "start" ]
    ```
5. Build and run the Docker container:
    ```sh
    docker build -t resumeai-backend .
    docker run -p 4292:4292 --env-file .env resumeai-backend
    ```
### Frontend Setup
1. Navigate to the frontend directory:
    ```sh
    cd frontend
    ```
2. Create an environment file (.env) with the necessary configuration variables. Refer to [Environment Variables](#environment-variables) for more details.

3. To run the frontend using Docker, create a Dockerfile with the following contents:

    ```Dockerfile
    Copy code
    FROM node:18
    WORKDIR /app
    COPY . .
    RUN npm install -f
    EXPOSE 4200
    CMD ["/bin/sh", "-c", "npm run generate-proxy-config && npm start"]
    ```
4. Build and run the Docker container:

    ```
    docker build -t resumeai-frontend .
    docker run -p 4200:4200 --env-file .env resumeai-frontend
    ```
### Environment Variables

For both backend and frontend, you need to configure environment variables as follows:

#### Backend `.env` Variables
- `JWT_SECRET_KEY`: A secret key for signing JWT tokens. Example: MYREALLYSECRETKEY
- `MONGO_URL`: MongoDB connection URL. Example: mongodb+srv://...
- `OPENAI_KEY`: OpenAI API key. Example: YOUR_OPENAI_API_KEY
- `GMAIL_USER`: Gmail address used by Nodemailer to send resumes. Example: youremail@gmail.com
- `GMAIL_PASS`: Password or App Password for the Gmail user.
- `FRONT_END`: URL of the frontend. Example: http://192.168.1.96:4200
#### Frontend `.env` Variables
- `API_TARGET`: URL of the backend API. Example: http://192.168.1.96:4292

### Deployment
Push Docker Images to Amazon ECR
1. Authenticate Docker to your Amazon ECR registry:

    ```sh
    aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<your-region>.amazonaws.com
    ```
2. Create a repository in ECR:
    ``` sh
    aws ecr create-repository --repository-name resumeai-backend
    aws ecr create-repository --repository-name resumeai-frontend
    ```
3. Tag your images:
    ```sh
    docker tag resumeai-backend:latest <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/resumeai-backend:latest
    docker tag resumeai-frontend:latest <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/resumeai-frontend:latest
    ```
4. Push your images to ECR:
    ```sh
    docker push <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/resumeai-backend:latest
    docker push <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/resumeai-frontend:latest
    ```

### Deploy to Amazon EKS
1. Configure kubectl to use your Amazon EKS cluster:

    ```sh
    aws eks --region <region> update-kubeconfig --name <cluster_name>
    ```
2. Create Kubernetes deployment and service files for both frontend and backend using helm.
    ```sh
    helm create ResumeAI
    ```

3. Navigate to the helm directory, Apply the deployment:
    ```sh
    cd ResumeAI
    helm repo add stable https://charts.helm.sh/stable
    helm repo update
    helm install resumeai ./resumeai
    ```
4. Verify the deployment:
    ```sh
    kubectl get pods
    kubectl get services
    ```

### Deploy to Minikube
1. Start Minikube:
    ```sh
    minikube start
    ```
2. Set minikube as kubectl context
    ```sh
    kubectl config use-context minikube
    ```
3. Create Kubernetes deployment and service files for both frontend and backend using helm.
    ```sh
    helm create ResumeAI
    ```

4. Navigate to the helm directory, Apply the deployment:
    ```sh
    cd ResumeAI
    helm repo add stable https://charts.helm.sh/stable
    helm repo update
    helm install resumeai ./resumeai
    ```
5. Access the application:
    ```sh
    minikube service resumeai-frontend
    ```
### CI/CD with Jenkins
#### Setup Jenkins Pipeline
1. `Jenkinsfile`: Create a Jenkinsfile in your repository to automate the CI/CD pipeline. Example is attached in the repo.
2. `Add Jenkins Credentials`: Add AWS credentials and Docker credentials in Jenkins for accessing ECR and deploying to EKS.
3. `Create Pipeline`: In Jenkins, create a new pipeline job and point it to your repository containing the Jenkinsfile.
4. `Run the Pipeline`: Run the Jenkins job to build, push, and deploy the application.

### Tech Stack
- `Backend`: Node.js, Express.js, Typescript, MongoDB, OpenAI API, Nodemailer
- `Frontend`: Angular, Typescript
- `Deployment`: Docker, Kubernetes (EKS/Minikube)


Feel free to raise any issues or contribute to the project by submitting a pull request.