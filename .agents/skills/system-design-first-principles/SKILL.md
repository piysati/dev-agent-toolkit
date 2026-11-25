---
name: system-design-first-principles
description: >-
  First-principles System Design mastery from single-node MVP to global scale.
  Use when designing distributed systems, preparing for staff/senior design
  interviews, reviewing architecture proposals, or solving real backend scaling,
  reliability, caching, sharding, and consistency problems.
---

# System Design From First Principles

Never memorize and regurgitate buzzword diagrams ("put Kafka and Redis everywhere"). Every box in a system design diagram must **earn its place by killing a measured bottleneck**.

## The 6-Stage System Design Loop

### Stage 1: Scope, Users & Non-Functional Requirements (5 min)
Clarify before drawing a single box:
- **Core functional flows** (pick the top 3; explicitly defer the rest).
- **Traffic & data profile**: Read-heavy (100:1) or write-heavy? Bursty or steady?
- **Consistency vs Availability**: Can users see 2-second stale data (feed/likes), or must it be strongly consistent (payments/inventory/booking)?
- **Latency SLOs**: p50 / p95 / p99 targets.
- **Durability & Scale**: Data retention, RPO/RTO, regional vs global.

### Stage 2: Back-of-the-Envelope Estimation (3 min)
Keep math simple using powers of 10:
- `1 day ≈ 86,400 s ≈ 10^5 s`
- `1M requests/day ≈ 12 QPS` (peak ≈ 3×–5× average)
- `100M requests/day ≈ 1,200 QPS` (peak ≈ 5,000 QPS)
- Typical single PostgreSQL node: ~5k–20k simple indexed reads/sec, ~1k–5k writes/sec, comfortable up to a few TB.
- Typical Redis node: ~50k–100k ops/sec, sub-ms latency, memory-bound.
- Always calculate: **Read QPS, Write QPS, Storage/year, Bandwidth (MB/s)**.

### Stage 3: API Contract & Data Model First
- Define clean REST/gRPC endpoints (including **idempotency keys** for writes & cursor-based pagination for lists).
- Define core tables/entities, **primary keys, indexes, and access patterns** BEFORE picking NoSQL vs SQL.

### Stage 4: Naive Single-Node Baseline (Brute Force)
Draw the simplest working system:
```text
Client -> Load Balancer -> Stateless Spring Boot Service -> PostgreSQL
```
Ask: **How far does this alone take us?** (Often 100K+ DAU!). Now apply our Stage-2 math and find **what breaks first**.

### Stage 5: Iterative Bottleneck-Driven Evolution
For each real bottleneck, add ONE targeted mechanism and explain its trade-off:

| Bottleneck | Solution Pattern | New Trade-Off / Failure Mode Introduced |
|------------|------------------|-----------------------------------------|
| Read DB CPU saturated | **Read Replicas** or **Cache-Aside (Redis)** | Replication lag (stale reads); cache invalidation, thundering herd / cache stampede (mitigate with singleflight/locks + TTL jitter) |
| Hot keys overwhelming 1 cache/DB shard | **Local L1 cache (Caffeine)** + key salting / request coalescing | Brief inconsistency across app nodes |
| Write throughput / storage exceeds 1 DB node | **Vertical scaling → Partitioning → Sharding** | Cross-shard joins/transactions break; resharding complexity; hot shard risk (choose shard key carefully!) |
| Slow downstream / bursty writes | **Message Queue (Pub/Sub / Kafka)** + **Transactional Outbox** | Eventual consistency; duplicate delivery (need idempotent consumers); poison pills (need DLQ) |
| Abusive / bursty clients | **Rate Limiter** (Token Bucket / Sliding Window in Redis / Cloud Armor) | False positives on shared NAT IPs; distributed counter sync overhead |
| Duplicate payment / double-booking | **Idempotency Keys** + DB unique constraint / optimistic locking (`@Version`) / `SELECT ... FOR UPDATE` | Contention under high concurrency on the same row |
| Cascading failures across services | **Timeouts + Retries w/ Jitter + Circuit Breaker + Bulkhead + Backpressure** | Retry storms if misconfigured without jitter or retry budgets |
| Multi-service state update | **Saga Pattern** (Orchestration vs Choreography) + compensating actions | No ACID isolation (intermediate states visible); must handle partial failure |

### Stage 6: Failure Modes, Observability & Security Check
Always stress-test your own design with 4 questions:
1. **What if X dies right now?** (App instance, primary DB, Redis, queue consumer, entire AZ)
2. **What if a request is retried 3 times or arrives out of order?**
3. **What are the top 4 dashboards/alerts we'd set on day 1?** (RED metrics + DB connection pool + queue consumer lag + error budget burn)
4. **Where are the authn/authz, PII, and abuse boundaries?**

## Key Trade-Off Cheat Sheet
- **Sync (REST/gRPC) vs Async (Queue/Event)**: Sync when caller needs immediate result; Async to decouple latency, absorb spikes, or fan-out.
- **Push vs Pull (Fan-out on Write vs Read)**: Fan-out on write = fast reads, expensive for celebrities (hybrid: pull for high-fanout accounts, push for normal users).
- **Cursor vs Offset Pagination**: Offset degrades at `O(offset)` and drifts on inserts; Cursor (`WHERE id > last_id LIMIT n`) is `O(log n)` indexed and stable.
- **Optimistic vs Pessimistic Locking**: Optimistic (`@Version`) when conflicts are rare (high throughput); Pessimistic (`FOR UPDATE`) when contention is high and retries are expensive.
