# Global Instructions

Personal defaults for all projects. Project-specific `CLAUDE.md` files take
precedence over this file. Keep this short — add rules here only once they've
proven true across more than one project.

## Environment

- macOS (Darwin), zsh shell, Homebrew for packages.
- Dotfiles (nvim, ghostty, zsh) are managed via GNU Stow in `~/dotfiles`
  (github.com/xd1i0/dotfiles). New machine-wide configs should go there, not
  as one-off files.

## Communication

- Be concise. Short status updates over long narration.
- No unsolicited summaries, no restating the plan before doing it.
- State findings and decisions directly; skip hedging when confident.

## Development Standards

### Architecture
- Prefer composition over inheritance; use dependency injection for testability.
- Follow SOLID principles where the language/framework makes them idiomatic —
  don't force patterns onto codebases that don't already use them.

### Security
- Never log or commit sensitive data (passwords, API keys, tokens, PII).
- Validate and sanitize input at system boundaries (user input, external APIs).
- Use environment variables / secret managers for credentials, never hardcode.
- Keep OWASP Top 10 in mind for anything handling untrusted input.

## Git & GitHub

- Never push, force-push, or create/delete branches or remote repos without
  explicit confirmation first.
- Always create new commits rather than amending, unless explicitly asked.
- Never use `--no-verify` or skip hooks unless explicitly asked.
- Default to conventional commit prefixes (feat:, fix:, docs:, refactor:,
  chore:) when a project doesn't already have its own convention.
- Keep commits atomic and focused; run the project's existing test suite
  before committing if one exists.
- Commit messages: concise, explain *why* not *what*, no attribution spam
  beyond what's already configured.
- Never add "Co-Authored-By" (or any variant) to commits — enforced as a
  hard block in `settings.json` permissions.deny, this is the documented
  reason why.

## Code Style

- No comments unless they explain non-obvious *why* (a workaround, a subtle
  invariant) — never restate *what* the code does.
- No speculative abstractions, feature flags, or error handling for cases
  that can't happen. Match the scope of the change to what was asked.
- Prefer editing existing files over creating new ones. Don't create README
  or docs files unless explicitly requested.

## Workflow

- Treat destructive or hard-to-reverse actions (rm -rf, git reset --hard,
  overwriting uncommitted work) as things to confirm first, not assume.
- When restructuring config/dotfiles, verify symlinks resolve and diff clean
  before considering the change done.
