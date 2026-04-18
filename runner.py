from datetime import datetime
from pathlib import Path


message_lines = [
	"runner output Hello World changed",
	datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
]

with Path("runner.txt").open("a", encoding="utf-8") as output_file:
	output_file.write("\n".join(message_lines) + "\n")
