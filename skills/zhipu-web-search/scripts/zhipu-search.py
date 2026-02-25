#!/usr/bin/env python3
"""
Zhipu AI Web Search Client

Direct HTTP client for Zhipu AI's web search API.
https://open.bigmodel.cn/dev/api/search-model/web-search
"""

import json
import os
import re
import subprocess
import sys
from typing import Optional

API_URL = "https://open.bigmodel.cn/api/paas/v4/web_search"
DEFAULT_TIMEOUT = 30
DEFAULT_COUNT = 10


def get_api_key() -> str:
    """Get API key from environment variable."""
    api_key = os.environ.get("ZHIPU_API_KEY") or os.environ.get("BIGMODEL_API_KEY")
    if not api_key:
        print("ERROR: ZHIPU_API_KEY or BIGMODEL_API_KEY environment variable not set", file=sys.stderr)
        print("Get your API key from https://open.bigmodel.cn/", file=sys.stderr)
        sys.exit(1)
    return api_key


def make_request(payload: dict, api_key: str, timeout: int = DEFAULT_TIMEOUT) -> dict:
    """Make HTTP POST request using curl."""
    data = json.dumps(payload, ensure_ascii=False)

    cmd = [
        "curl", "-s", "-X", "POST", API_URL,
        "-H", "Content-Type: application/json",
        "-H", f"Authorization: Bearer {api_key}",
        "-d", data,
        "--max-time", str(timeout)
    ]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout + 5)
        if result.returncode != 0 and result.stderr:
            print(f"ERROR: curl failed: {result.stderr}", file=sys.stderr)
            sys.exit(1)

        try:
            return json.loads(result.stdout)
        except json.JSONDecodeError:
            print(f"ERROR: Invalid JSON response: {result.stdout[:500]}", file=sys.stderr)
            sys.exit(1)

    except subprocess.TimeoutExpired:
        print(f"ERROR: Request timed out after {timeout}s", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print("ERROR: curl not found. Please install curl.", file=sys.stderr)
        sys.exit(1)


def search(api_key: str, query: str, count: int = DEFAULT_COUNT, timeout: int = DEFAULT_TIMEOUT) -> dict:
    """Perform web search."""
    payload = {
        "search_query": query,
        "search_engine": "search_pro",
        "search_intent": True,
        "count": count
    }
    return make_request(payload, api_key, timeout)


def format_search_results(result: dict) -> str:
    """Format search results for readable output."""
    # Check for error
    if "error" in result:
        return f"ERROR: {result['error'].get('message', str(result['error']))}"

    # Get search results
    search_results = result.get("search_result", [])

    if not search_results:
        return "No results found."

    output_lines = []
    for i, entry in enumerate(search_results, 1):
        title = entry.get('title', 'N/A')
        link = entry.get('link', '')
        content = entry.get('content', '')
        media = entry.get('media', '')
        publish_date = entry.get('publish_date', '')

        # Clean up content (remove HTML tags)
        content = re.sub(r'<[^>]+>', '', content)

        # Format link as markdown
        if link:
            output_lines.append(f"## [{i}] [{title}]({link})")
        else:
            output_lines.append(f"## [{i}] {title}")

        # Truncate content if too long
        if len(content) > 300:
            content = content[:300] + "..."

        output_lines.append(f"**Summary:** {content}")

        if media:
            output_lines.append(f"**Source:** {media}")
        if publish_date:
            output_lines.append(f"**Date:** {publish_date}")

        output_lines.append("")

    return "\n".join(output_lines)


def main():
    if len(sys.argv) < 2:
        print("Usage: zhipu-search.py <query> [count] [timeout]", file=sys.stderr)
        print("Example: zhipu-search.py 'latest AI news' 10 30", file=sys.stderr)
        sys.exit(1)

    query = sys.argv[1]
    count = int(sys.argv[2]) if len(sys.argv) > 2 else DEFAULT_COUNT
    timeout = int(sys.argv[3]) if len(sys.argv) > 3 else DEFAULT_TIMEOUT

    api_key = get_api_key()
    result = search(api_key, query, count, timeout)

    # Debug: print raw result
    if os.environ.get("DEBUG"):
        print(f"DEBUG: Raw result: {json.dumps(result, ensure_ascii=False, indent=2)}", file=sys.stderr)

    print(format_search_results(result))


if __name__ == "__main__":
    main()
