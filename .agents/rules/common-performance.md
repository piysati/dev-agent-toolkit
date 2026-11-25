# Performance Optimization (Antigravity & Gemini)

## Model Selection Strategy (Antigravity Subagent & Pipeline Tiers)

- **`flash_lite`** (Lightest & fastest):
  - Trivial formatting, classification, quick log parsing, high-volume batch scans
- **`flash`** (Fast & capable):
  - Lightweight helper subagents, focused code exploration, routine test generation, documentation lookups
- **`pro`** (Deepest reasoning — default for core engineering):
  - Main development work, complex debugging, system design, trade-off analysis, code/security/database reviews, multi-file refactoring

## Context Window Management

Keep conversations crisp and high-signal. Use `/compact` (or start a fresh session after `/save-session`) at natural phase boundaries before the context window gets crowded — especially before:
- Large-scale multi-file refactoring
- Complex distributed-systems or concurrency debugging
- Shifting from exploration/planning to implementation

Lower context-sensitivity tasks (single-file edits, docs updates, quick fixes) tolerate longer sessions comfortably.

## Structured Reasoning & Planning

For complex tasks requiring deep reasoning:
1. Start with `/think` or `/plan` before touching code.
2. Decompose into atomic sub-problems and surface hidden assumptions first.
3. Delegate independent reviews/checks in parallel to specialist subagents (`java-reviewer`, `database-reviewer`, `security-reviewer`, `architect`).

## Build Troubleshooting

If a build fails:
1. Delegate to `java-build-resolver` (for Java/Maven/Gradle) or run `/build-fix`.
2. Analyze the root cause of the compiler/dependency error rather than guessing.
3. Apply the smallest surgical fix.
4. Re-run the build/tests and verify exit code 0 before moving on.
