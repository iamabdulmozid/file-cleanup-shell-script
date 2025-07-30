# 🧹 File Cleanup Script

This project contains a PowerShell script that automatically deletes files older than 10 days from a specified directory. It is intended for regular cleanup tasks and can be scheduled using **Windows Task Scheduler**.

---

## ⚙️ Features

- Deletes files older than 10 days
- Can be scheduled to run daily (or at any custom interval)
- Runs silently in the background via Task Scheduler
- Highly configurable for different environments (servers or workstations)

---

## 📝 Usage

### 1. **Edit the Script**
Open `DeleteOldFiles.ps1` and configure:
- The **target directory**
- The **file age threshold** (currently set to 10 days)
- Uncomment or modify folder deletion logic if needed

---

## 📆 Schedule the Script with Task Scheduler

1. Open **Task Scheduler** (search for it in the Start menu)
2. Click **“Create Task”**
3. **General tab**:
   - Name: `Cleanup Old Files`
   - Description: `Deletes files older than 10 days`
   - Check: `Run whether user is logged on or not`
   - Check: `Run with highest privileges`
4. **Triggers tab**:
   - Click **“New”**
   - Set to run **daily** at a time when the system is idle (e.g., `2:00 AM`)
5. **Actions tab**:
   - Click **“New”**
   - Action: `Start a program`
   - Program/script: `powershell.exe`
   - Arguments: `-ExecutionPolicy Bypass -File "C:\Scripts\DeleteOldFiles.ps1"`
6. **Conditions tab** (optional):
   - Check: `Start the task only if the computer is idle for` (optional for workstations)
7. **Settings tab** (optional):
   - Configure retry attempts
   - Optionally stop the task if it runs too long
8. Click **OK**, enter your password if prompted

---

## ⚠️ Important Notes

- 🔍 **Test the script first** on non-critical files before production use
- 🗂️ The script currently only deletes **files**, not **folders** (folder logic is commented out for safety)
- 🛡️ For servers, consider adding:
  - Error handling
  - Logging
  - Email notifications (e.g., using `Send-MailMessage`)
- 📤 Add email alerts if cleanups affect critical paths

---

## ✅ Requirements

- Windows OS
- PowerShell 5.0+
- Task Scheduler access with admin rights
