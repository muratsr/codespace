from datetime import datetime
from pathlib import Path


message_lines = [
	"runner output Hello World",
	datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
]

Path("runner.txt").write_text("\n".join(message_lines) + "\n", encoding="utf-8")
