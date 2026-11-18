#!/usr/bin/env python3
"""Minimal AMD TokenLab chat client (nur key). Usage:
  python3 amd.py <model> <max_tokens> <prompt_file> [system_file]
Prints ONLY the assistant reply to stdout. Key is read from file, never printed.
"""
import json, os, sys, urllib.request

KEY = open(os.path.expanduser("~/workspace/amd-tokenlab/api-key.txt")).read().strip()
URL = "https://api.tokenlab.amd.com/v1/chat/completions"

def main():
    model = sys.argv[1]
    max_tokens = int(sys.argv[2])
    prompt = open(sys.argv[3]).read()
    system = open(sys.argv[4]).read() if len(sys.argv) > 4 else "You are an expert Solidity smart-contract engineer. Output code only, no markdown fences around the whole file unless asked. Be precise and complete."
    body = json.dumps({
        "model": model,
        "messages": [
            {"role": "system", "content": system},
            {"role": "user", "content": prompt},
        ],
        "max_tokens": max_tokens,
        "temperature": 0.2,
    }).encode()
    req = urllib.request.Request(URL, data=body, headers={
        "Content-Type": "application/json",
        "Authorization": f"Bearer {KEY}",
    })
    try:
        with urllib.request.urlopen(req, timeout=120) as r:
            d = json.load(r)
    except urllib.error.HTTPError as e:
        print(f"HTTP {e.code}: {e.read().decode()[:500]}", file=sys.stderr)
        sys.exit(2)
    ch = d["choices"][0]
    print(ch["message"]["content"])
    if ch.get("finish_reason") != "stop":
        print(f"[finish_reason={ch.get('finish_reason')}]", file=sys.stderr)
    u = d.get("usage", {})
    print(f"[usage in={u.get('prompt_tokens')} out={u.get('completion_tokens')}]", file=sys.stderr)

if __name__ == "__main__":
    main()
