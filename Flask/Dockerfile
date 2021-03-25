# Pull the base image
FROM python:latest

# Set the working directory
WORKDIR /app

# Copy the Source code
COPY src/ .

# Install flask
RUN pip install flask

# Expose port 5000
EXPOSE 5000

# Runs app.py at start of the container
ENTRYPOINT [ "python", "./app.py"]
