---
description: 3-Stage Gemini-Native Engineering Pipeline — (1) Spec-First Architect Gate -> (2) 3-Approach Algo & Distributed Edge-Case Audit -> (3) Surgical TDD Implementation with Resilience & Observability.
---

# /forge — 3-Stage End-to-End Engineering Pipeline

Use `/forge <feature or system task>` for non-trivial production features, services, or refactors where you want maximum engineering rigor in one seamless **Antigravity + Gemini** flow (replaces jumping across separate LLMs for Architecture → Algorithms → Code).

> **Zero shortcuts**: Never jump straight to writing production code on Turn 1. If the user's prompt has missing constraints, data models, or boundaries, **say NO straightaway** and ask before proceeding.

---

## Stage 1: Principal Architect Spec Gate (`architect`)

1. **Reject Ambiguity**: If data model, traffic/scale bounds, consistency requirements, or failure boundaries are missing, stop and ask sharp clarifying questions first.
2. **Draft a Tight Spec** (in chat or `spec.md` when requested) covering:
   - **Scope & Boundaries**: What is in scope vs. explicitly out of scope (bounded context / SOLID boundaries).
   - **Data Schema & Indexes**: Tables/entities, keys, constraints, and expected query access patterns.
   - **API / Event Contract**: Exact request/response DTOs, status codes, idempotency keys, pagination.
   - **SLOs & Capacity Targets**: Target latency (p50/p95/p99), expected & peak RPS, storage/retention.
   - **Systemic Vulnerability Hunt**: Explicitly identify race conditions, Single Points of Failure (SPOFs), and database locking vectors *before* coding.
   - **Observability Strategy**: Exact RED metrics (OpenTelemetry / Cloud Monitoring / Prometheus), structured log fields (`traceId`, `orderId`), and alerts.
3. **GATE — WAIT FOR USER CONFIRMATION** before moving to Stage 2 (unless the user explicitly wrote *"run all 3 stages"*).

---

## Stage 2: Deep Algorithmic & Edge-Case Audit (`algo-systems-researcher`)

Once the spec is confirmed:
1. For the core algorithm, query path, or stateful workflow, evaluate **3 distinct approaches** (Naive → Standard Optimal → Hardware/Cache-Optimal) and pick the simplest one that cleanly meets Stage 1 SLOs.
2. Trace **multi-threaded execution & memory allocations** (check-then-act races, thread-pool exhaustion, virtual-thread pinning, GC pressure).
3. Stress-test **distributed edge cases**: network timeouts/retries, duplicate delivery, split-brain/stale locks, clock drift, and partial commits (e.g., DB write vs. Pub/Sub event).

---

## Stage 3: Surgical TDD Implementation (`tdd-guide` + `karpathy-guidelines` + Stack Skills)

Activate the matching stack skills (`java-coding-standards`, `springboot-patterns`, `springboot-tdd`, `jpa-patterns`, `postgres-patterns`, `gcp-cloud-architecture`, `google-ai-engineering`):

1. **Tests First (RED)**: Write failing unit/integration tests with mocks (or Testcontainers for DB) covering the happy path AND the exact edge cases surfaced in Stage 2.
2. **Surgical Implementation (GREEN)**:
   - Minimum clean, modular, SOLID code — **use design patterns only where they genuinely simplify**, never forced.
   - **Resilience at External Boundaries**: Explicit timeouts, typed exceptions, circuit breakers, and jittered retries on external HTTP/DB/AI calls. In Spring Boot, centralize HTTP error mapping in `@RestControllerAdvice` (do NOT scatter raw `try-catch` blocks in controllers).
   - **Structured Observability**: Add clean structured logging at entry, exit, and error paths of major execution workflows (never log secrets/PII!).
3. **Verify & Review**:
   - Run the actual build & tests and confirm exit code 0.
   - Run `java-reviewer` (or `code-reviewer`) and `security-reviewer` checks on the diff.
4. **Capture the Win**: Output a concise **3-Line Pattern Recall Card** and offer to log key decisions to `journal/tradeoff-log.md` or compile deep learnings into `wiki/` via `llm-wiki`.
