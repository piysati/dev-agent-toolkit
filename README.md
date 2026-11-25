# Super-Dev-Hub

An **Antigravity + Gemini / Google AI** engineering harness built to take a working developer to the **Top 1%** across 8 hands-on pillars:

**Java · Spring Boot · DSA · DBMS · OS & Linux · Cloud (GCP) · Google AI · System Design**

---

## Why This Exists

Most AI coding setups turn you into a copy-paste operator: you type a prompt, the LLM dumps 300 lines of code, and you learn nothing.

**Super-Dev-Hub** flips that completely. It fuses three systems into one native Antigravity (`.agents/` + `GEMINI.md`) workspace:

1. **First-Principles Co-Thinking Mentor** — Breaks prompts into smaller problems, names the underlying pattern, starts from brute force, diagnoses bottlenecks, weighs trade-offs, and pauses at Socratic checkpoints so you build genuine **muscle-mind connection & muscle memory**.
2. **Andrej Karpathy's 4 Coding Principles + Brutal Honesty / Zero Hallucination** — Think before coding, simplicity first, surgical changes, goal-driven verification, **zero hallucination**, **zero sycophancy**, and **straightaway saying NO** whenever there is a gap in your prompt or reasoning.
3. **Curated ECC Production Harness (Adapted for Antigravity & Gemini)** — Production-grade Java/Spring Boot, DBMS, OS/Linux, GCP, Google AI, System Design, TDD, Security, and Verification skills + specialist subagents + an **LLM Wiki** for compounding knowledge.

---

## Start Here (Docs at This Level)

| Document | Read This When... |
|---|---|
| **[HOW-TO-USE.md](HOW-TO-USE.md)** | **First-time user!** Plain-English walkthrough of how to start, how to use Super-Dev-Hub on a **brand-new project**, how to activate every slash command, subagent, and skill, plus the complete catalog of all **17 workflows, 12 subagents, 40 skills, and 15 rules**. |
| **[llm-wiki.md](llm-wiki.md)** | You want Antigravity / Gemini to compile your articles, war stories, and study notes into a permanent, interlinked personal engineering wiki (`wiki/`). |
| **[GEMINI.md](GEMINI.md)** | You want to see or tweak the always-on brain & routing rules Antigravity reads on every turn. |

---

## Repository Map

```text
Super-Dev-Hub/
├── README.md                    # Project overview (this file)
├── HOW-TO-USE.md                # Beginner-friendly user guide + full catalog of workflows, agents & skills
├── llm-wiki.md                  # Guide to your compounding LLM Wiki (skill: .agents/skills/llm-wiki/SKILL.md)
├── GEMINI.md                    # Always-on Antigravity operating rules & routing map
├── .agents/                     # Native Antigravity 2.0 customization root (adapted for Gemini)
│   ├── rules/                   # 14 always-on rules (Karpathy, Brutal Honesty, Common & Java standards)
│   ├── skills/                  # 40 skills (9 custom mastery/git/wiki/writing + Karpathy + 30 curated ECC)
│   ├── agents/                  # 12 specialist subagents (Antigravity tools & Gemini tiers)
│   └── workflows/               # 17 slash commands (/think, /forge, /git-rescue, /drill, /design, /ship-and-learn, etc.)
├── journal/                     # Active training trackers
│   ├── roadmap-tracker.md       # 8-pillar Top 1% hands-on checklist
│   ├── pattern-bank.md          # Spaced-repetition pattern recognition flashcards
│   └── tradeoff-log.md          # Architectural & engineering trade-off journal
├── wiki/                        # Compounding LLM-maintained personal engineering encyclopedia
│   ├── index.md                 # Master catalog of all compiled wiki pages
│   ├── log.md                   # Append-only activity log (ingest / query / lint)
│   ├── raw/                     # Immutable raw sources & notes
│   └── pages/                   # Interlinked compiled pages across all 8 pillars
├── playground/                  # Hands-on coding & debugging sandbox per pillar
└── scripts/
    └── sync-to-project.sh       # Copy .agents/ (and optionally GEMINI.md) into any new/work project
```
