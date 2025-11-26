# Contributing to NX Log Viewer

Thank you for your interest in contributing to NX Log Viewer! 🎉

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/nx-log-viewer.git`
3. Create a feature branch: `git checkout -b feature/my-feature`

## Development

### Prerequisites

- Bash 4.0+ (or Zsh)
- An NX monorepo for testing

### Testing Locally

```bash
# Make the script executable
chmod +x bin/nxlogs

# Test directly
./bin/nxlogs --help

# Or install locally
./install.sh
```

### Code Style

- Use 4 spaces for indentation
- Add comments for complex logic
- Follow existing naming conventions
- Keep functions focused and small

## Pull Request Process

1. Ensure your code follows the style guidelines
2. Test your changes with at least one NX project
3. Update README.md if you've added new features
4. Create a pull request with a clear description

## Feature Requests

Open an issue with the `enhancement` label describing:
- What problem does this solve?
- How should it work?
- Example usage

## Bug Reports

Open an issue with the `bug` label including:
- Your OS and Bash version
- Steps to reproduce
- Expected vs actual behavior
- Relevant log output

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
