#!/usr/bin/env python3
"""Gemini generate via custom.gemini surrogate (fallback when AMD 503s).
Usage: python3 gemini.py <model> <prompt_file> [system_file]
Prints ONLY the assistant reply to stdout.
"""
import json, sys, urllib.request
sys.path.insert(0, "/opt/muse/skills/custom-connector-setup/bin")
from dynamic_credentials import add_surrogate_to_request, read_json_response

class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, *args):
        raise RuntimeError("redirect refused, verify the endpoint")

def main():
    model = sys.argv[1]
    prompt = open(sys.argv[2]).read()
    system = open(sys.argv[3]).read() if len(sys.argv) > 3 else "You are an expert Solidity smart-contract engineer. Output code only, no markdown fences unless asked. Be precise and complete."
    body = json.dumps({
        "system_instruction": {"parts": [{"text": system}]},
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {"temperature": 0.2, "maxOutputTokens": 4096},
    }).encode()
    req = urllib.request.Request(
        f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent",
        data=body, headers={"Content-Type": "application/json"},
    )
    add_surrogate_to_request(req, "custom.gemini",
                             allowed_hosts=["generativelanguage.googleapis.com"])
    try:
        with urllib.request.build_opener(NoRedirect()).open(req, timeout=120) as r:
            d = read_json_response(r)
    except urllib.error.HTTPError as e:
        print(f"HTTP {e.code}: {e.read().decode()[:500]}", file=sys.stderr)
        sys.exit(2)
    try:
        text = d["candidates"][0]["content"]["parts"][0]["text"]
    except (KeyError, IndexError):
        print("NO TEXT: " + json.dumps(d)[:800], file=sys.stderr)
        sys.exit(3)
    print(text)

if __name__ == "__main__":
    main()
