# data_processor.py
import datetime

# Simulate data processing
current_time = datetime.datetime.now()
report_content = f"Data processed successfully at {current_time}"

# Save the report to a file
with open("report.txt", "w") as report_file:
    report_file.write(report_content)

print("Report generated: report.txt")
