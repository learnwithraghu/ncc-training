#!/usr/bin/env python3
"""
Docker Hello World Application
A simple Flask web application demonstrating Docker containerization
"""

from datetime import datetime
from pathlib import Path
import os
import socket

from flask import Flask, jsonify, request

app = Flask(__name__)

DATA_DIR = Path(os.getenv('DATA_DIR', '/app/data'))
HOST = os.getenv('HOST', '0.0.0.0')
PORT = int(os.getenv('PORT', '5000'))

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
        'environment': os.getenv('ENVIRONMENT', 'development'),
        'data_dir': str(DATA_DIR)
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
        'host': HOST,
        'port': PORT,
        'environment_variables': {
            'ENVIRONMENT': os.getenv('ENVIRONMENT', 'not set'),
            'APP_VERSION': os.getenv('APP_VERSION', 'not set'),
            'DATA_DIR': os.getenv('DATA_DIR', str(DATA_DIR))
        },
        'python_version': os.sys.version,
        'data_dir_exists': DATA_DIR.exists()
    })

@app.route('/write', methods=['POST'])
def write_data():
    """Write data to a file (demonstrates volumes)"""
    data = request.get_json(silent=True) or {}
    message = data.get('message', 'No message provided')
    
    # Write to the data directory (usually mounted as a volume)
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    
    filename = DATA_DIR / 'messages.txt'
    with filename.open('a', encoding='utf-8') as f:
        f.write(f"{datetime.now().isoformat()} - {message}\n")
    
    return jsonify({
        'status': 'success',
        'message': 'Data written to file',
        'file': str(filename)
    })

@app.route('/read')
def read_data():
    """Read data from file (demonstrates volumes)"""
    filename = DATA_DIR / 'messages.txt'
    
    try:
        with filename.open('r', encoding='utf-8') as f:
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
    print(f"Data directory: {DATA_DIR}")
    
    # Run on all interfaces (0.0.0.0) so it's accessible from outside container
    app.run(host=HOST, port=PORT, debug=False)
