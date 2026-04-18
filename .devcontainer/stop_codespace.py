import os
import sys
import urllib.error
import urllib.request


def main() -> int:
    codespace_name = os.environ.get("CODESPACE_NAME")
    token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GITHUB_CODESPACES_TOKEN")
    api_url = os.environ.get("GITHUB_API_URL", "https://api.github.com")

    if not codespace_name:
        print("CODESPACE_NAME is not set", file=sys.stderr)
        return 1

    if not token:
        print("GITHUB_TOKEN is not set", file=sys.stderr)
        return 1

    request = urllib.request.Request(
        f"{api_url}/user/codespaces/{codespace_name}/stop",
        method="POST",
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
        },
    )

    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            print(f"Codespace stop requested: HTTP {response.status}")
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        print(f"GitHub API returned HTTP {exc.code}: {body}", file=sys.stderr)
        return 1
    except urllib.error.URLError as exc:
        print(f"Could not reach GitHub API: {exc}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())