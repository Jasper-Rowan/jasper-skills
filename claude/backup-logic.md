# Backup Logic Pro Projects to Google Drive

Back up one or more Logic Pro X projects from this Mac to Google Drive.

## Fixed Details (do not ask the user for these)

- **Logic Pro projects directory:** `~/Music/Logic/`
- **Google Drive destination:** My Drive > Jasper > Zen Cruz > Logic Projects
- **Google Drive folder ID:** `1bWmUCDPqfPE618_I_MkO6tJIsuB3JJL8`
- **Google account:** jasperrowan199@gmail.com
- **Auth:** gcloud is already configured. Get a token with: `ACCESS_TOKEN=$(gcloud auth print-access-token)`

## Your Task

1. **List projects** — run `ls ~/Music/Logic/` and show the user what's there
2. **Ask which to back up** — "all of them" or specific ones. If they say a project name or number, match it against the list.
3. **Run the full pipeline** for each selected project, in this order:

---

### Step 1: Asset Collection (per project, sequential)

Open each project in Logic Pro and ensure all audio assets are bundled into the package.

**CRITICAL — use shell `open`, NOT AppleScript `open`:**
```applescript
do shell script "open '/path/to/project.logicx'"
```
Using `tell application "Logic Pro" to open` will BLOCK if Logic shows a dialog (missing plugins, sample rate mismatch). The shell open command returns immediately.

**Full per-project flow:**
```applescript
-- 1. Open via shell (non-blocking)
do shell script "open '/Users/jasperrowan/Music/Logic/PROJECT.logicx'"
delay 20

-- 2. Dismiss any dialogs that appeared
tell application "System Events"
    tell process "Logic Pro"
        try
            click button "OK" of front window
            delay 2
        end try
        try
            click button "Continue" of front window
            delay 2
        end try
    end tell
end tell
delay 3

-- 3. Open Assets settings
tell application "System Events"
    tell process "Logic Pro"
        set fileMenu to menu "File" of menu bar 1
        click menu item "Assets…" of menu "Project Settings" of menu item "Project Settings" of fileMenu
    end tell
end tell
delay 2

-- 4. Enable asset checkboxes
tell application "System Events"
    tell process "Logic Pro"
        set frontWin to front window
        repeat with cbName in {"Copy audio files into project", "Copy Sampler audio files into project", "Copy Alchemy audio files into project", "Copy Ultrabeat audio files into project", "Copy Space Designer impulse responses into project"}
            set cb to checkbox cbName of frontWin
            if value of cb is 0 then click cb
        end repeat
    end tell
end tell

-- 5. Save
tell application "Logic Pro"
    save document 1
end tell
```

**Leave these UNCHECKED** (too large / pre-installed on every Mac):
- "Copy movie file into project"
- "Copy Apple Sound Library content into project"

**IMPORTANT — do NOT chain all projects in one long AppleScript block.** Logic Pro times out (~30s AppleEvent limit). Instead: run the `open` + `delay 20` in one script, then confirm the project loaded with `tell application "Logic Pro" to name of every document`, then run the assets + save step as a separate script call.

---

### Step 2: Zip (run in parallel for multiple projects)

```bash
cd ~/Music/Logic
zip -r ~/Desktop/NNN_logic_backup.zip "PROJECT NAME.logicx" &
# ... repeat for each project
wait && echo "ALL ZIPS DONE"
```

- Name zip files as `NNN_logic_backup.zip` matching the project name/number
- Project filenames may have **leading spaces** (e.g., ` 004.logicx`) — quote carefully
- Run all zips in parallel with `&` + `wait`

---

### Step 3: Upload to Google Drive (run in parallel for multiple projects)

Use the resumable upload API. Define a reusable shell function:

```bash
upload_to_drive() {
  local zip_path="$1"
  local name="$2"
  local folder_id="1bWmUCDPqfPE618_I_MkO6tJIsuB3JJL8"
  local token=$(gcloud auth print-access-token)

  local upload_url=$(curl -s -X POST \
    "https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable" \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"$name\", \"parents\": [\"$folder_id\"]}" \
    -D - | grep -i "^location:" | tr -d '\r' | awk '{print $2}')

  local result=$(curl -s -X PUT "$upload_url" \
    -H "Content-Type: application/zip" \
    --data-binary @"$zip_path")

  echo "$name: $(echo $result | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("id","ERROR"))')"
}

# Run all uploads in parallel
upload_to_drive ~/Desktop/001_logic_backup.zip "001_logic_backup.zip" &
upload_to_drive ~/Desktop/002_logic_backup.zip "002_logic_backup.zip" &
wait && echo "ALL UPLOADS DONE"
```

- Run uploads **in background** (`run_in_background: true`) — they can take several minutes for large projects
- Check output for Drive file IDs to confirm success (an "ERROR" means the upload failed)

---

### Step 4: Cleanup

After confirming all uploads succeeded, ask the user:
> "All projects are backed up to Google Drive. Want me to delete the zip files from your Desktop?"

If yes, delete each zip from `~/Desktop/`.

---

## Status Table

Show a running status table as work progresses:

| Project | Assets | Zip | Upload |
|---------|--------|-----|--------|
| 001 - Name | ⏳ / ✅ | ⏳ / ✅ | ⏳ / ✅ |

---

## Common Gotchas

- **AppleScript timeouts (-1712):** Always split open+wait from the assets step. Never chain multiple projects in one AppleScript block.
- **Leading spaces in filenames:** ` 004.logicx` has a leading space — always quote paths and use `ls` output directly.
- **Colons in filenames:** macOS displays `:` as `/` in Finder but stores as `:` on disk (e.g., `001 - Daft:Jamiroquai.logicx`).
- **Background shell PATH:** When running scripts with `run_in_background: true`, use full paths like `/usr/bin/osascript` and `/usr/bin/zip` — the background shell may not inherit your PATH.
- **gcloud token expiry:** Tokens last ~1 hour. If uploading many large files, refresh with `gcloud auth print-access-token` before each upload batch.
