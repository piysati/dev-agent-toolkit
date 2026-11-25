# How to Use Super-Dev-Hub (First-Time User Guide)

Welcome! This guide explains **Super-Dev-Hub** so simply that a brand-new user (or even a 5-year-old!) can start using it with **Antigravity / Gemini** in 2 minutes.

---

## 1. The 4 Building Blocks (Explained Simply)

Think of `Super-Dev-Hub` like a championship engineering gym with 4 types of helpers inside `.agents/`:

| Building Block | Simple Analogy | Where It Lives | How You Use It |
|---|---|---|---|
| **Rules** (15) | **House Rules** — always active on the wall | `GEMINI.md` + `.agents/rules/` | **Automatic!** You don't type anything; Antigravity obeys them on every turn (Karpathy discipline, Brutal Honesty, Zero Hallucination, Java standards). |
| **Slash Workflows** (17) | **Shortcut Buttons** — one-word commands for common routines | `.agents/workflows/*.md` | **Type `/command` in chat**, e.g. `/think`, `/forge`, `/git-rescue`, `/drill dsa`, `/design`, `/ship-and-learn`, `/plan`. |
| **Skills** (40) | **Expert Playbooks** — step-by-step manuals Antigravity reads only when needed | `.agents/skills/<name>/SKILL.md` | **Auto-triggered** when relevant, **OR force one explicitly**: *"Use the `git-master` skill to recover..."* |
| **Subagents / Agents** (12) | **Specialist Teammates** — dedicated reviewers/planners with focused roles | `.agents/agents/*.md` | **Call them by exact name**: *"Run the `java-reviewer` subagent on this diff"* or *"Use `algo-systems-researcher` to audit..."* |

> **Built for Antigravity & Gemini**: Every rule, skill, agent, and workflow here is adapted natively for **Antigravity / Gemini** (`.agents/`, `GEMINI.md`, Gemini `flash_lite` / `flash` / `pro` tiers, Vertex AI / Gemini SDK, and Antigravity tool names).

---

## 2. First-Time Setup (Do This Once — 60 Seconds)

1. Open the **`Super-Dev-Hub`** folder in **Antigravity**.
2. **Start a brand-new conversation** (Antigravity discovers `.agents/` at the start of a new conversation).
3. *(Optional verify)* Open **Settings → Customizations** and confirm your workspace rules, skills, agents, and workflows appear.
4. Try your first prompt right away:
   ```text
   /think Given an array of integers, find the count of subarrays whose sum equals k.
   ```
   Notice how Antigravity will **NOT** just dump code — it will decompose the problem, spot the pattern signal, start with brute force, pause to test *your* thinking, and then optimize with trade-offs!

---

## 3. How to Use Super-Dev-Hub When Starting a NEW Project (or at Work)

Whenever you start a new repository — or want this entire harness inside an existing company Spring Boot / GCP / AI repo:

### Step 1: Sync the harness into your project
Run one command from `Super-Dev-Hub`:
```bash
./scripts/sync-to-project.sh /path/to/your-new-project --with-gemini-md
```
- This safely copies `.agents/{rules,skills,agents,workflows}` into `/path/to/your-new-project/.agents/`.
- If your project does **not** already have a `GEMINI.md`, `--with-gemini-md` copies it in. If one already exists, it will **never overwrite** it (it prints a note so you can merge manually).
- *(Tip: If it's a company repo and you don't want to commit `.agents/` to git, add `.agents/` and `GEMINI.md` to your local `.git/info/exclude`!)*

### Step 2: Open your project in a NEW Antigravity conversation
Antigravity automatically discovers `.agents/` inside that project.

### Step 3: Pick your mode for the task
- **Learning / Deep Understanding / Unfamiliar Code**: Use `/think` or ask `code-explorer` to map the repo first.
- **Work Deadline (Need to Ship Fast + Still Learn)**: Use `/ship-and-learn <your task>`. You'll get a crisp plan + trade-off table → clean, tested, surgical code → a 60-second **Pattern Debrief** at the end.
- **Before Pushing Any PR**: Run `/code-review` or *"Use `java-reviewer` and `security-reviewer` on my git diff"*.
- **End of Day**: Run `/retro-pattern` (to log patterns to `journal/`) or *"Use `llm-wiki` to ingest today's debugging lesson"* (to grow `wiki/`).

---

## 4. What Principles Does Antigravity Follow Here?

Two strict contracts are **always active** via `GEMINI.md` and `.agents/rules/`:

### A. Andrej Karpathy's 4 Principles ([karpathy-discipline.md](.agents/rules/karpathy-discipline.md))
1. **Think Before Coding** — Surface assumptions, ambiguities, and trade-offs up front; never guess silently.
2. **Simplicity First** — Write the minimum clean code that solves today's problem; zero speculative abstractions.
3. **Surgical Changes** — Touch only what is requested; match existing style; no drive-by refactors.
4. **Goal-Driven Execution** — Convert tasks into verifiable checks (failing test → passing test, measured baseline → verified speedup) and loop until verified.

### B. Brutal Honesty, Zero Hallucination & Straight-No Mandate ([brutal-honesty-zero-hallucination.md](.agents/rules/brutal-honesty-zero-hallucination.md))
- **Zero Hallucination**: Never invents APIs, annotations, CLI flags, benchmarks, or passing tests. If unverified, Antigravity says *"I don't know / haven't verified this"* and checks first.
- **Brutal Honesty**: Zero sugarcoating or *"Great question!"* fluff. Calls out weak invariants, wrong Big-O, cargo-culted Kafka/Redis, or premature complexity directly.
- **Straightaway Say NO**: If your prompt has a gap, flawed premise, or asks for an anti-pattern, Antigravity stops immediately, says **NO**, explains *why it breaks*, and asks what's missing before writing code.

---

## 5. Complete Slash Workflows Catalog (17 Commands)

Type these directly in chat:

### Mastery & Daily Co-Thinking Workflows (7 Custom)

| Slash Command | What It Does | Copy-Paste Example |
|---|---|---|
| **`/think`** | Full 7-step First-Principles Mentor loop (decompose → pattern signal + ELI5 analogy → brute force → Socratic checkpoint → optimize & trade-offs → recall card). | `/think Explain why Spring @Transactional fails on self-invocation.` |
| **`/forge`** | **3-Stage Full Engineering Pipeline**: (1) Architect Spec Gate (`spec.md` + Latency/RPS/SPOF/DB lock check) → (2) 3-Approach Algo & Distributed Edge-Case Audit → (3) Surgical TDD Build with boundary resilience & structured logging. | `/forge Build an idempotent ledger transfer service in Spring Boot + PostgreSQL.` |
| **`/git-rescue`** | **Safe Git Diagnosis & Recovery**: inspects live repo state first, creates a backup branch checkpoint before any history rewrite, and guides verified recovery (rebases, detached HEAD, reflog, `revert -m 1`, `rebase --onto`, leaked secrets). | `/git-rescue I accidentally committed to main and already started rebasing.` |
| **`/ship-and-learn`** | **Work Mode**: fast, surgical, tested production delivery + trade-off table up front + 60-second pattern debrief at the end. | `/ship-and-learn Add idempotent payment webhook handling to OrderController.` |
| **`/drill`** | Active-recall muscle-memory quiz. Agent waits for *your* Signal → Baseline → Bottleneck → Optimal answer before grading. | `/drill dsa` · `/drill springboot` · `/drill dbms` · `/drill os` · `/drill gcp` · `/drill google-ai` · `/drill review` |
| **`/design`** | 6-stage System Design / GCP / Google AI session from naive single-node baseline → math → bottleneck scaling → failure modes. | `/design Design a notification service on GCP with Spring Boot, Cloud SQL, and Pub/Sub.` |
| **`/retro-pattern`** | End-of-session retrospective that saves learned patterns & trade-offs into `journal/`. | `/retro-pattern` |

### Production Engineering Workflows (10 Curated from ECC)

| Slash Command | What It Does | Copy-Paste Example |
|---|---|---|
| **`/plan`** | Restate requirements, assess risks, build a phased implementation plan, and **wait for your confirmation** before editing code. | `/plan Migrate order events to the Transactional Outbox pattern` |
| **`/code-review`** | Fresh-context review of local uncommitted diffs or a GitHub PR for bugs, security, performance, and style. | `/code-review` or `/code-review 142` |
| **`/build-fix`** | Detect build system (Maven/Gradle/etc.) and fix build/compilation errors incrementally with minimal changes. | `/build-fix` |
| **`/gradle-build`** | Targeted Gradle build & dependency error resolver. | `/gradle-build` |
| **`/security-scan`** | Audit code, secrets, permissions, configs, and agent/MCP surfaces. | `/security-scan` |
| **`/test-coverage`** | Find test coverage gaps and generate missing tests toward 80%+ coverage. | `/test-coverage` |
| **`/evolve`** | Cluster accumulated continuous-learning instincts into reusable skills, workflows, or agents. | `/evolve` |
| **`/instinct-status`** | View learned project + global instincts and confidence scores. | `/instinct-status` |
| **`/save-session`** | Save current session context (what worked, what failed, exact next step) to `.agents/session-data/`. | `/save-session` |
| **`/resume-session`** | Reload your latest saved session file from `.agents/session-data/` and brief you before continuing. | `/resume-session` |

---

## 6. Complete Specialist Subagents / Agents Catalog (12 Agents)

Located in [`.agents/agents/`](.agents/agents/). To activate any subagent, just ask Antigravity by its **exact name**:

| Agent Name | Tier | What It Specializes In | How to Activate (Example Prompt) |
|---|---|---|---|
| **`planner`** | `pro` | Breaking complex features/refactors into phased, verifiable implementation steps with risks. | *"Use the `planner` subagent to plan adding rate limiting to our API."* |
| **`architect`** | `pro` | Spec-first system design (`spec.md`), Latency/RPS/Observability targets, race conditions/SPOFs/DB locking vectors, and ADRs. | *"Invoke the `architect` agent to write a spec and compare Cloud SQL vs Cloud Spanner."* |
| **`algo-systems-researcher`** | `pro` | 3-approach algorithmic comparison (Naive vs Standard Optimal vs Hardware/Cache-Optimal), CPU cache locality, JVM allocations, multi-threaded races, and distributed edge cases (split-brain, clock drift, partitions). | *"Use `algo-systems-researcher` to compare 3 approaches and trace concurrency edge cases."* |
| **`java-reviewer`** | `pro` | Spring Boot & Java code review: `@Transactional`, JPA N+1, constructor DI, DTOs, concurrency, security, tests. | *"Run `java-reviewer` on my staged Java files."* |
| **`java-build-resolver`** | `pro` | Fixing Maven/Gradle compilation, classpath, and dependency errors with minimal surgical changes. | *"Delegate to `java-build-resolver` to fix `./mvnw verify`."* |
| **`database-reviewer`** | `pro` | SQL tuning, `EXPLAIN ANALYZE`, composite indexing, schema migrations, locking, and query plans. | *"Have `database-reviewer` review this PostgreSQL migration and slow query."* |
| **`code-reviewer`** | `pro` | General fresh-context review for correctness, readability, error handling, and security. | *"Run `code-reviewer` on my current git diff."* |
| **`security-reviewer`** | `pro` | OWASP Top 10, authn/authz, injection, SSRF, secret leaks, unsafe crypto, API boundaries. | *"Use `security-reviewer` on our JWT auth filter and webhook handler."* |
| **`performance-optimizer`** | `pro` | Profiling bottlenecks, Big-O improvements, JVM memory/GC leaks, and tail-latency fixes. | *"Invoke `performance-optimizer` to find why p99 latency spiked to 2s."* |
| **`tdd-guide`** | `pro` | Enforcing RED → GREEN → REFACTOR test-driven development and 80%+ test coverage. | *"Use `tdd-guide` to build this service method with JUnit 5 tests first."* |
| **`code-explorer`** | `pro` | Deeply tracing execution flows, layers, and dependencies in unfamiliar codebases. | *"Use `code-explorer` to trace how checkout requests reach the database."* |
| **`refactor-cleaner`** | `pro` | Safely identifying and deleting dead code, duplicates, and obsolete abstractions. | *"Run `refactor-cleaner` on the legacy `billing` package."* |

---

## 7. Complete Skills Catalog (40 Skills)

Located in [`.agents/skills/<name>/SKILL.md`](.agents/skills/). Antigravity activates them automatically when relevant, or you can **explicitly activate any skill** by saying:
> **`Use the <skill-name> skill to ...`**

### Tier 1: Custom Mastery, Git, Wiki & Credibility Skills (9)

| Skill Name | Best For | Example Activation |
|---|---|---|
| **`first-principles-mentor`** | Co-thinking, decomposition, pattern recognition + ELI5 analogies, brute-force → optimize, Socratic checkpoints, trade-offs. | *"Use `first-principles-mentor` to help me solve..."* |
| **`dsa-pattern-mastery`** | 16 DSA patterns, constraint → Big-O table, invariant proofs, Java DSA traps & drills. | *"Use `dsa-pattern-mastery` on this sliding-window problem."* |
| **`os-linux-internals`** | Processes/threads/virtual threads, RSS vs Heap, container OOMKill (137), `epoll`, futexes, Linux/JVM triage commands. | *"Use `os-linux-internals` to diagnose this Exit Code 137 OOMKill."* |
| **`gcp-cloud-architecture`** | Cloud Run vs GKE vs GCE, Cloud SQL vs Spanner vs BigQuery, Pub/Sub vs Cloud Tasks, IAM/Workload Identity, VPC. | *"Use `gcp-cloud-architecture` to design my Spring Boot deployment on GCP."* |
| **`google-ai-engineering`** | Gemini API vs Vertex AI, Java/Python GenAI SDK, Spring AI, Structured Outputs, Tool Calling, RAG, Context Caching, Google ADK, Evals. | *"Use `google-ai-engineering` to add structured Gemini output to Spring Boot."* |
| **`system-design-first-principles`** | 6-stage scaling framework: SLOs, capacity math, single-node MVP → caching, replicas, sharding, queues, Outbox, Saga. | *"Use `system-design-first-principles` to design a distributed job scheduler."* |
| **`git-master`** | Live Git diagnosis, strict safety checkpoints (`--force-with-lease --force-if-includes`), and complete 0–5+ yr recovery playbook (`reflog`, `rebase --onto`, `revert -m 1`, `bisect`, `git-filter-repo`, submodules). | *"Use `git-master` to untangle this branch with rebase --onto."* |
| **`llm-wiki`** | Ingesting notes/articles/bug postmortems into `wiki/`, querying your compiled knowledge, and linting for gaps/contradictions. | *"Use `llm-wiki` to ingest these PostgreSQL vacuum notes."* |
| **`tech-writing-credibility`** | *(Phase 2 — Credibility)* Turning real `wiki/` + `journal/` + `playground/` findings into authentic, zero-cringe LinkedIn technical posts and **NotebookLM** source/podcast packets. | *"Use `tech-writing-credibility` to turn my PostgreSQL MVCC wiki page into a LinkedIn post (or NotebookLM packet)."* |

### Tier 2: Andrej Karpathy Behavioral Discipline (1)

| Skill Name | Best For |
|---|---|
| **`karpathy-guidelines`** | Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution (includes `references/EXAMPLES.md`). |

### Tier 3: Curated ECC Production Harness Skills (30)

#### Java & Spring Boot (6)
- **`java-coding-standards`** — Modern Java 17+ idioms, immutability, records, `Optional`, streams, exceptions, generics.
- **`springboot-patterns`** — Layered REST architecture, services, caching, async, structured logging.
- **`springboot-security`** — Authn/authz, Bean Validation, CSRF/CORS, secrets, headers, rate limiting.
- **`springboot-tdd`** — JUnit 5, Mockito, `@WebMvcTest`, `@DataJpaTest`, Testcontainers, JaCoCo.
- **`springboot-verification`** — Build, static analysis, coverage, security, and pre-PR verification loop.
- **`jpa-patterns`** — Hibernate/JPA entity modeling, N+1 prevention (`JOIN FETCH`/`@EntityGraph`), pagination, locking.

#### DBMS & Caching (4)
- **`postgres-patterns`** — PostgreSQL schemas, composite/partial/covering indexes, `EXPLAIN ANALYZE`, query optimization.
- **`mysql-patterns`** — MySQL/InnoDB indexing, transactions, locks, replication, connection pools.
- **`database-migrations`** — Zero-downtime migrations (expand-and-contract, non-blocking indexes, Flyway/Liquibase).
- **`redis-patterns`** — Caching strategies, stampede protection, distributed locks, rate limiting, pub/sub.

#### System Design, Architecture, Performance & Infra (9)
- **`api-design`** — REST semantics, idempotency keys, cursor pagination, versioning, error envelopes.
- **`architecture-decision-records`** — Writing crisp ADRs with context, alternatives, and consequences.
- **`hexagonal-architecture`** — Ports & Adapters isolation of domain logic from frameworks and databases.
- **`latency-critical-systems`** — p95/p99 tail-latency, queues, caches, freshness, and hot-path tuning.
- **`error-handling`** — Explicit error hierarchies, fail-fast boundaries, retries with jitter.
- **`docker-patterns`** — Multi-stage builds, non-root containers, JVM container flags, healthchecks.
- **`kubernetes-patterns`** — Deployments, probes, requests/limits, HPA, PDB, RBAC, `kubectl` debugging.
- **`deployment-patterns`** — Rolling, blue-green, canary deployments, and rollback safety.
- **`production-audit`** — Local *"what breaks in prod?"* pre-launch and post-merge readiness audit.

#### Google AI / LLM Engineering & Evals (4)
- **`ai-first-engineering`** — Engineering process, review gates, and ownership when building AI-powered systems.
- **`eval-harness`** — Golden datasets, deterministic checks + LLM-as-a-judge regression gating.
- **`cost-aware-llm-pipeline`** — Gemini Flash-Lite/Flash/Pro routing, immutable budget tracking, narrow jittered retries, Context Caching.
- **`mcp-server-patterns`** — Designing, validating, and securing MCP servers (tools, resources, prompts).

#### Execution, Quality & Self-Learning (7)
- **`tdd-workflow`** — RED → GREEN → REFACTOR test-first workflow targeting 80%+ coverage.
- **`verification-loop`** — End-to-end verification before claiming any task is done.
- **`security-review`** — Security checklist for auth, user inputs, secrets, endpoints, and sensitive flows.
- **`search-first`** — Check existing libraries, patterns, and codebase utilities before reinventing the wheel.
- **`codebase-onboarding`** — Rapidly map an unfamiliar codebase's architecture, entry points, and gotchas.
- **`continuous-learning-v2`** — Capture recurring lessons as scoped instincts and evolve them into skills.
- **`strategic-compact`** — Compact context cleanly at natural phase boundaries in long sessions.

---

## 8. Always-On Rules (15 Files — No Invocation Needed)

Antigravity automatically loads all 15 files (~10k tokens total, safely under the 20k-token rules cap):
- `GEMINI.md`
- `.agents/rules/brutal-honesty-zero-hallucination.md`
- `.agents/rules/karpathy-discipline.md`
- `.agents/rules/common-{coding-style,security,testing,code-review,development-workflow,git-workflow,patterns,performance}.md`
- `.agents/rules/java-{coding-style,patterns,security,testing}.md`

---

## 9. How to Use Your Journal, LLM Wiki & Playground Together

| Tool | When to Use It | Command / Action |
|---|---|---|
| **`journal/roadmap-tracker.md`** | Weekly check-in to pick your next weak spot across the 8 pillars. Check a box **only** after hands-on mastery. | Open & pick 1 unchecked topic → run `/think` or `/drill` |
| **`journal/pattern-bank.md`** | After solving any DSA, Spring, SQL, OS, or design problem so it turns into permanent muscle memory. | Run `/retro-pattern` to save; run `/drill review` to quiz due cards |
| **`journal/tradeoff-log.md`** | After any architecture decision or major work trade-off. | Run `/design` or `/retro-pattern` |
| **`wiki/` (`llm-wiki.md`)** | Whenever you read a great doc/paper or fix a hard production bug and want it compiled into your permanent personal encyclopedia. | *"Use `llm-wiki` to ingest..."* · *"Query `llm-wiki` about..."* · *"Lint `llm-wiki`"* |
| **`playground/`** | Hands-on coding, benchmarking, and breaking things safely across `dsa/`, `java-spring/`, `dbms/`, `os-linux/`, `gcp/`, `google-ai/`, `system-design/`. | Write & test real code right inside `playground/<pillar>/` |

---

## 10. Recommended Daily Top-1% Routine (60–90 Minutes)

1. **15 min — Spaced-Repetition Warmup**: Run `/drill review` (or `/drill dsa`) to sharpen instant pattern recognition.
2. **During Work**: Use `/ship-and-learn` inside your synced work repo so every ticket builds your instincts instead of just closing a Jira story.
3. **30–45 min — Deep Pillar Study**: Pick 1 unchecked box in `journal/roadmap-tracker.md` → run `/think` or `/design` → build a real mini-experiment in `playground/`.
4. **5 min — Compound Your Knowledge**: Run `/retro-pattern` to save your pattern card, and ingest any deep insight into `wiki/` with `llm-wiki`.
