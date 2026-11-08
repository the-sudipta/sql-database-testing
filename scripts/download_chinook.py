"""Downloads the Chinook sample database (SQLite) into data/chinook and verifies its SHA-256 checksum.

Source: https://github.com/lerocha/chinook-database (release v1.4.5). The file is not committed to this
repository; run `uv run python scripts/download_chinook.py` once (the setup scripts do it for you).
"""

import hashlib
import sys
import urllib.request
from pathlib import Path

URL = "https://github.com/lerocha/chinook-database/releases/download/v1.4.5/Chinook_Sqlite.sqlite"
SHA256 = "bdf635be69850bd3be09c9a2dbeef7ddfb80036bd3ef3381383cd03b61e4a61a"
TARGET = Path(__file__).resolve().parents[1] / "data" / "chinook" / "Chinook_Sqlite.sqlite"


def sha256_of(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    if TARGET.exists() and sha256_of(TARGET) == SHA256:
        print(f"Chinook already present: {TARGET}")
        return 0
    TARGET.parent.mkdir(parents=True, exist_ok=True)
    temp = TARGET.with_suffix(".download")
    with urllib.request.urlopen(URL, timeout=60) as response:  # noqa: S310 - fixed https URL
        temp.write_bytes(response.read())
    if sha256_of(temp) != SHA256:
        temp.unlink()
        print("Checksum mismatch - download rejected", file=sys.stderr)
        return 1
    temp.replace(TARGET)
    print(f"Chinook downloaded and verified: {TARGET}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
