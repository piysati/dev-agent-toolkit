---
description: End-to-end System Design, GCP Cloud, or Google AI architecture session from naive single-node baseline to production scale with explicit trade-offs.
---

# /design — First-Principles Architecture & Trade-Off Session

Load `system-design-first-principles`, `first-principles-mentor`, and (when applicable) `gcp-cloud-architecture`, `google-ai-engineering`, `architecture-decision-records`, and `postgres-patterns` / `redis-patterns`.

## Interactive 6-Stage Flow

1. **Stage 1 — Scope & SLOs**: Clarify top 3 functional flows, read/write ratio, consistency requirement, and latency/availability targets.
2. **Stage 2 — Back-of-the-Envelope Math**: Co-calculate Read QPS, Write QPS, storage/year, and bandwidth with the user.
3. **Stage 3 — API & Data Model**: Sketch key endpoints (with idempotency/pagination) and relational/NoSQL schema + indexes.
4. **Stage 4 — Naive Single-Node Baseline**: Draw the simplest working Spring Boot + DB architecture and ask the user: *"At our numbers, what breaks first?"*
5. **Stage 5 — Bottleneck-Driven Scaling**: Evolve the architecture ONE bottleneck at a time (caching, replicas, sharding, queues/outbox, rate limiting, GCP services, Google AI routing/evals), producing a **Trade-Off Matrix** for every major choice.
6. **Stage 6 — Failure Modes, Security & ADR**:
   - Stress-test failures (node crash, duplicate message, network partition, 429/timeout).
   - Offer to record the key decision(s) in `journal/tradeoff-log.md`.
