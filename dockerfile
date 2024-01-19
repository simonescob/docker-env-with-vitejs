# Use an official Node.js runtime as the base image
FROM node:alpine AS build

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the project dependencies
RUN npm install

# Copy the rest of the project files to the working directory
COPY . .

# Set your environment variable
ENV VITE_VAR_TEST="hello this a variable come from docker"

# Build the app for production
RUN npm run build

# Use a smaller base image for the production environment
FROM nginx:alpine

# Copy the build output to replace the default nginx contents.
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 on the container
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
