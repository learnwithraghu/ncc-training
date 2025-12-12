#!/usr/bin/env python3
"""
Docker Hello World Application
A simple Flask web application demonstrating Docker containerization
"""

from flask import Flask, jsonify, request
from datetime import datetime
import os
import socket

app = Flask(__name__)

# Track visit count (will be lost when container restarts without volumes)
visit_count = 0

@app.route('/')
def hello():
    """Main endpoint - returns a welcome message"""
    global visit_count
    visit_count += 1
    
    return jsonify({
        'message': 'Hello from Docker!',
        'container_id': socket.gethostname(),
        'timestamp': datetime.now().isoformat(),
        'visit_count': visit_count,
        'environment': os.getenv('ENVIRONMENT', 'development')
    })

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat()
    })

@app.route('/info')
def info():
    """Container information endpoint"""
    return jsonify({
        'hostname': socket.gethostname(),
        'environment_variables': {
            'ENVIRONMENT': os.getenv('ENVIRONMENT', 'not set'),
            'APP_VERSION': os.getenv('APP_VERSION', 'not set')
        },
        'python_version': os.sys.version
    })

@app.route('/write', methods=['POST'])
def write_data():
    """Write data to a file (demonstrates volumes)"""
    data = request.get_json()
    message = data.get('message', 'No message provided')
    
    # Write to /app/data directory (will be mounted as volume)
    data_dir = '/app/data'
    os.makedirs(data_dir, exist_ok=True)
    
    filename = f"{data_dir}/messages.txt"
    with open(filename, 'a') as f:
        f.write(f"{datetime.now().isoformat()} - {message}\n")
    
    return jsonify({
        'status': 'success',
        'message': 'Data written to file',
        'file': filename
    })

@app.route('/read')
def read_data():
    """Read data from file (demonstrates volumes)"""
    filename = '/app/data/messages.txt'
    
    try:
        with open(filename, 'r') as f:
            content = f.readlines()
        return jsonify({
            'status': 'success',
            'messages': content,
            'count': len(content)
        })
    except FileNotFoundError:
        return jsonify({
            'status': 'error',
            'message': 'No messages file found. Use /write endpoint first.'
        }), 404

if __name__ == '__main__':
    print("Starting Docker Hello World Application...")
    print(f"Container ID: {socket.gethostname()}")
    print(f"Environment: {os.getenv('ENVIRONMENT', 'development')}")
    
    # Run on all interfaces (0.0.0.0) so it's accessible from outside container
    app.run(host='0.0.0.0', port=5000, debug=True)
