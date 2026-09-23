from flask import Flask
import os
import socket

app = Flask(__name__)

VERSION = os.getenv("APP_VERSION", "local")

@app.get("/")
def home():
    hostname = socket.gethostname()

    return {
        "application": "Preview Environment Engine",
        "version": VERSION,
        "hostname": hostname,
        "message": "Preview environment is running"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy"
    }

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=8080
    )