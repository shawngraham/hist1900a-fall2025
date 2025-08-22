#!/usr/bin/env python3
"""
Simple HTTP server with CORS headers for TensorFlow.js apps
Usage: python cors_server.py [port]
"""

import http.server
import socketserver
import sys
from urllib.parse import urlparse

class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_cors_headers()
        super().end_headers()
    
    def send_cors_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
    
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_cors_headers()
        self.end_headers()

if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 5000
    
    with socketserver.TCPServer(("", port), CORSRequestHandler) as httpd:
        print(f"Server running at http://localhost:{port}")
        print("CORS headers enabled for TensorFlow.js")
        httpd.serve_forever()