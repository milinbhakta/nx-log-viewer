# 📋 NX Log Viewer

A beautiful, powerful CLI tool for viewing and managing logs in any NX monorepo.

[![npm version](https://img.shields.io/npm/v/nx-log-viewer.svg)](https://www.npmjs.com/package/nx-log-viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell: Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![GitHub](https://img.shields.io/github/stars/milinbhakta/nx-log-viewer?style=social)](https://github.com/milinbhakta/nx-log-viewer)

## ✨ Features

- 🔍 **Smart App Discovery** - Auto-detects apps from your NX workspace
- 🎨 **Beautiful Output** - Colored, formatted logs with level detection
- 📊 **Log Statistics** - Quick overview of log sizes and line counts
- 🔄 **Live Following** - Real-time log tailing with formatting
- 🔎 **Powerful Search** - Regex search across all logs
- 🕒 **Time Filtering** - Filter logs by relative or absolute time
- 🔃 **Log Rotation** - Automatic log trimming with configurable thresholds
- ⚙️ **Configurable** - Project or user-level configuration
- 🚀 **Zero Dependencies** - Pure bash, works anywhere

## 🚀 Quick Start

### Installation

#### Option 1: npm (Recommended)

```bash
# Install globally
npm install -g nx-log-viewer

# Or as a dev dependency in your project
npm install --save-dev nx-log-viewer
```

#### Option 2: Direct Download

```bash
curl -fsSL https://raw.githubusercontent.com/milinbhakta/nx-log-viewer/main/install.sh | bash
```

#### Option 3: Manual Installation

```bash
git clone https://github.com/milinbhakta/nx-log-viewer.git
cd nx-log-viewer
./install.sh
```

### Basic Usage

```bash
# Navigate to your NX project
cd /path/to/your/nx-project

# Interactive mode
nxlogs

# View specific app logs
nxlogs my-app

# Start app and capture logs (Wrapper Mode)
nxlogs serve my-app

# View NX Daemon logs
nxlogs --daemon

# Follow logs in real-time
nxlogs -f my-app

# View all errors
nxlogs --errors

# Show log statistics
nxlogs --stats
```

## 🚀 Serving Apps & Capturing Logs

NX Log Viewer can act as a wrapper around `nx serve` to automatically capture output to log files:

```bash
# Start 'api' and capture logs
nxlogs serve api

# Pass arguments to the underlying command
nxlogs serve api --port=4000 --host=0.0.0.0
```

This will:
1. Run `nx serve api`
2. Pipe output to `logs/nx/api.log`
3. Show formatted output in your terminal simultaneously

## 📖 Commands

| Command | Description |
|---------|-------------|
| `nxlogs` | Interactive app selection menu |
| `nxlogs <app>` | View logs for specific app |
| `nxlogs serve <app>` | Start app and capture logs to file |
| `nxlogs --daemon` | View NX Daemon logs |
| `nxlogs --cache` | View recent NX task runner logs |
| `nxlogs -f, --follow` | Follow logs in real-time |
| `nxlogs -s, --search <term>` | Search logs for a term |
| `nxlogs -e, --errors` | Show only errors and warnings |
| `nxlogs -n, --lines <N>` | Show last N lines (default: 50) |
| `nxlogs -a, --all` | View all app logs combined |
| `nxlogs --since <time>` | Show logs since specified time |
| `nxlogs --until <time>` | Show logs until specified time |
| `nxlogs --rotate [app]` | Rotate log files (trim old lines) |
| `nxlogs --max-lines <N>` | Max lines before rotation |
| `nxlogs --trim-to <N>` | Lines to keep after rotation |
| `nxlogs --json` | Output logs in JSON format |
| `nxlogs --export <file>` | Export filtered logs to a file |
| `nxlogs --demo [apps]` | Generate demo logs for testing |
| `nxlogs --stats` | Show log file statistics |
| `nxlogs --apps` | List detected apps |
| `nxlogs --clean` | Remove all log files |
| `nxlogs --init` | Create config file in current project |
| `nxlogs --theme <name>` | Set color theme |
| `nxlogs --help` | Show help message |

## 🕒 Time Filtering

Filter logs by time using flexible expressions:

```bash
# Relative times
nxlogs --since "1 hour ago" api
nxlogs --since "30 minutes ago" api
nxlogs --since "2 days ago" api

# Absolute dates
nxlogs --since "2025-01-26" api
nxlogs --since "2025-01-26 10:30:00" api

# Time ranges
nxlogs --since "1 week ago" --until "2 days ago" api
```

Supported time units: `second`, `minute`, `hour`, `day`, `week`, `month`, `year`

## 🔄 Log Rotation

Automatically manage log file sizes:

```bash
# Rotate all logs
nxlogs --rotate

# Rotate specific app
nxlogs --rotate api

# Custom thresholds
nxlogs --rotate --max-lines 10000 --trim-to 7000
```

Enable automatic rotation in `.nxlogsrc`:

```bash
# Automatically rotate when viewing logs
ENABLE_ROTATION=true

# Trigger rotation at 7000 lines
MAX_LOG_LINES=7000

# Keep 5000 lines after rotation
TRIM_TO_LINES=5000
```

## ⚙️ Configuration

Create a `.nxlogsrc` file in your project root or `~/.nxlogsrc` for global settings:

```bash
# Log directory (relative to project root)
LOG_DIR="logs"

# Display options
TIMESTAMP=true
TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"
SHOW_APP_NAME=true
COLORIZE=true
THEME="default"

# Default lines to show
DEFAULT_LINES=50

# Auto-discover apps from nx.json
AUTO_DISCOVER=true

# Custom app list (overrides auto-discovery)
# APPS="app1 app2 app3"

# Highlight patterns (regex)
HIGHLIGHT_ERRORS="error|exception|failed|fatal"
HIGHLIGHT_WARNINGS="warn|warning"

# Pager for long output
PAGER="less -R"
```

## 🎨 Themes

Choose from multiple color themes to match your terminal:

```bash
# Set theme via command line
nxlogs --theme dark       # High contrast for dark terminals
nxlogs --theme light      # Darker colors for light terminals
nxlogs --theme minimal    # Subtle, minimal colors
nxlogs --theme cyberpunk  # Neon colors for style

# Or set in config
THEME="cyberpunk"
```

## 📤 JSON Output & Export

Output logs in JSON format for processing with tools like `jq`:

```bash
# JSON output to stdout
nxlogs api --json
nxlogs api --json | jq '.level'

# Export to file
nxlogs api --export logs.txt
nxlogs api --export logs.json --json

# Export with filters
nxlogs api --errors --export errors.txt
nxlogs api --since "1 hour ago" --export recent.log
```

## 🧪 Demo Mode

Generate sample logs to test the tool without a real project:

```bash
# Generate demo logs for default apps (api, web, worker)
nxlogs --demo

# Generate for specific apps
nxlogs --demo "api web"
```

## 🔧 Shell Completions

Enable tab completion for faster command entry:

**Bash:**
```bash
# Add to ~/.bashrc
source ~/.config/nxlogs/completions/nxlogs.bash
```

**Zsh:**
```bash
# Add to ~/.zshrc (before compinit)
fpath=(~/.config/nxlogs/completions $fpath)
```

## 📁 Log Directory Detection

NX Log Viewer searches for logs in this order:
1. Directory specified in `.nxlogsrc`
2. `./logs/nx/`
3. `./logs/`
4. `./.nx/logs/`

## 🐳 GitHub Codespaces & DevContainers

Add to your devcontainer's `postCreateCommand`:

```json
{
  "postCreateCommand": "npm install -g nx-log-viewer"
}
```

Or add convenience scripts to your `package.json`:

```json
{
  "scripts": {
    "logs": "nxlogs",
    "logs:follow": "nxlogs -f",
    "logs:errors": "nxlogs --errors",
    "logs:stats": "nxlogs --stats"
  }
}
```

Then run with:

```bash
npm run logs
# or with npx (if installed as dev dependency)
npx nxlogs
```

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

Made with ❤️ for the NX community
