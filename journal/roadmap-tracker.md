# Top 1% Engineering Mastery Roadmap (8 Pillars)

> **Rule**: Never check a box just because you watched a video or read a blog. Check it only when you can **explain it from first principles, weigh its trade-offs, and build/debug it hands-on**.

---

## Pillar 1: Java (Core + JVM + Concurrency)
### Foundations
- [ ] Value vs reference semantics, String pool, immutability, `equals`/`hashCode` contract
- [ ] Collections internals: `ArrayList`, `HashMap` (hashing, collisions, treeification, resizing), `LinkedHashMap`, `TreeMap`, `PriorityQueue`, `ArrayDeque`
- [ ] Generics (PECS: Producer Extends, Consumer Super), type erasure, Records, Sealed classes, Pattern Matching (Java 17–21+)
- [ ] Functional Java: Streams, `Optional` best practices, method references, avoiding stream pitfalls
### Deep Internals & Top 1%
- [ ] JVM Memory Model: Heap (Young/Old), Metaspace, Direct Memory, Stack frames, Escape Analysis
- [ ] Garbage Collectors trade-offs: G1GC vs ZGC vs Shenandoah (throughput vs pause time vs footprint)
- [ ] Java Memory Model (JMM): `happens-before`, `volatile`, `final` publication, false sharing
- [ ] Concurrency: `ConcurrentHashMap`, `ReentrantLock`, `ReadWriteLock`, `Semaphore`, `CountDownLatch`, `CompletableFuture`, `ThreadPoolExecutor` sizing & rejection policies
- [ ] Java 21+ Virtual Threads & Structured Concurrency (carrier pinning pitfalls!)
- [ ] Profiling hands-on: `jcmd`, thread dumps, heap dumps, JFR / `async-profiler` flamegraphs

---

## Pillar 2: Spring Boot (Production Backend Mastery)
### Foundations
- [ ] IoC Container, Bean lifecycle, scopes, constructor injection, `@Configuration` proxy behavior
- [ ] Spring MVC request lifecycle (`DispatcherServlet` → Filters → Interceptors → Controllers → `@RestControllerAdvice`)
- [ ] Bean Validation (`@Valid`), clean DTOs/records, API versioning, pagination (`Pageable` / cursor)
- [ ] Spring Data JPA & Hibernate: entity lifecycle, dirty checking, lazy vs eager loading, `JOIN FETCH` / `@EntityGraph` (killing N+1!)
### Deep Internals & Top 1%
- [ ] `@Transactional` internals: AOP proxies, self-invocation trap, propagation (`REQUIRED` vs `REQUIRES_NEW`), isolation levels, rollback rules, `readOnly = true`
- [ ] HikariCP connection pool sizing & preventing connection leaks under slow downstream calls
- [ ] Spring Security: filter chain, stateless JWT / OAuth2 Resource Server, RBAC/ABAC, CORS/CSRF
- [ ] Resilience & Async: `@Async` with bounded executors, Resilience4j (circuit breaker, retry + jitter, bulkhead, rate limiter), Transactional Outbox
- [ ] Testing pyramid: JUnit 5 + Mockito unit tests, `@WebMvcTest`, `@DataJpaTest`, **Testcontainers** integration tests
- [ ] Observability: Spring Boot Actuator, Micrometer + OpenTelemetry, structured JSON logging, graceful shutdown

---

## Pillar 3: DSA (Pattern Recognition & Muscle Memory)
### Core Patterns (Brute Force → Invariant → Optimal in Java)
- [ ] Arrays, Hashing, Prefix Sums (`Subarray Sum = K`, range queries)
- [ ] Two Pointers & Sliding Window (fixed + variable window invariants)
- [ ] Binary Search (classic + **Binary Search on Answer**)
- [ ] Stack, Queue, **Monotonic Stack**, **Monotonic Deque**
- [ ] Linked Lists (fast/slow pointers, reversal, LRU Cache from scratch)
- [ ] Trees & BSTs (DFS traversals, BFS level-order, LCA, diameter, serialize/deserialize)
- [ ] Heaps / Priority Queues (Top-K, K-way merge, Two Heaps running median)
- [ ] Graphs (BFS shortest path, DFS components/cycles, Topological Sort Kahn's, Union-Find DSU, Dijkstra, MST)
- [ ] Tries & Intervals (merge/sweep-line/scheduling)
- [ ] Backtracking (subsets, permutations, constraint pruning)
- [ ] Dynamic Programming (1D, 2D grid, Knapsack, LCS/LIS, Interval/State-machine DP, Memo → Tab → Space-optimized)
- [ ] Bit Manipulation & Advanced (Fenwick Tree / Segment Tree basics)

---

## Pillar 4: DBMS (Relational Internals, SQL & Redis)
### Foundations
- [ ] Normalization vs intentional denormalization; keys, constraints, foreign-key indexing
- [ ] Writing fluent SQL: joins, CTEs, window functions (`ROW_NUMBER`, `RANK`, `LAG/LEAD`, running totals), aggregations
- [ ] B-Tree index mechanics: composite index column order (leftmost prefix), covering indexes (`INCLUDE`), selectivity, why functions on indexed columns break index use
### Deep Internals & Top 1%
- [ ] Reading `EXPLAIN (ANALYZE, BUFFERS)` fluently: Seq Scan vs Index Scan vs Index-Only Scan vs Bitmap Heap Scan, Nested Loop vs Hash Join vs Merge Join
- [ ] ACID, WAL (Write-Ahead Log), Buffer Pool, Checkpoints, MVCC (vacuum/bloat in PostgreSQL, undo logs in MySQL InnoDB)
- [ ] Isolation levels & anomalies: Dirty Read, Non-Repeatable Read, Phantom Read, Write Skew (`READ COMMITTED` vs `REPEATABLE READ` vs `SERIALIZABLE`)
- [ ] Locking: row locks, `SELECT ... FOR UPDATE` / `SKIP LOCKED`, optimistic locking (`@Version`), deadlock detection & prevention
- [ ] Zero-downtime schema migrations (expand-and-contract, `CREATE INDEX CONCURRENTLY`, Flyway/Liquibase)
- [ ] Partitioning, Replication (async vs sync, replication lag), Sharding trade-offs
- [ ] Redis internals: data structures, TTL/eviction policies, cache-aside/write-through, stampede prevention, Lua atomic scripts

---

## Pillar 5: OS & Linux (What Really Runs Beneath Your JVM)
### Foundations
- [ ] Process vs Thread, virtual address space, user mode vs kernel mode, syscalls
- [ ] CPU scheduling (CFS/EEVDF), context switching, load average, run-queue saturation
- [ ] Virtual memory: pages, page tables, TLB, page faults, RSS vs VSZ, Linux Page Cache, swap, OOM killer
- [ ] File descriptors, inodes, `read`/`write`/`fsync`/`mmap`, pipes, sockets
### Deep Internals & Top 1%
- [ ] Networking internals: TCP 3-way handshake, congestion control, `TIME_WAIT` / `CLOSE_WAIT`, `epoll` event loop vs thread-per-connection
- [ ] Concurrency at OS level: mutexes, spinlocks, futexes, semaphores, deadlocks, CPU caches & false sharing
- [ ] Containers from scratch: Linux namespaces, cgroups v2 (CPU throttling & JVM memory limits — avoiding Exit Code 137!)
- [ ] Production Linux troubleshooting (USE method): `vmstat`, `mpstat`, `pidstat`, `iostat`, `free`, `ss`, `lsof`, `dmesg`, `strace`, `perf`

---

## Pillar 6: Cloud (GCP Hands-On & Architecture)
### Foundations
- [ ] GCP Resource Hierarchy (Org → Folders → Projects), IAM roles, Service Accounts, **Workload Identity** (no static JSON keys!)
- [ ] VPC networking: subnets, firewall rules, Cloud NAT, Private Service Connect, Cloud Load Balancing, Cloud Armor
- [ ] Cloud Run (deploying Spring Boot containers, startup CPU boost, concurrency, `min-instances`, Secret Manager)
- [ ] Cloud Storage (GCS): buckets, storage classes, lifecycle policies, Signed URLs
### Deep Internals & Top 1%
- [ ] GKE (Autopilot vs Standard): Deployments, Services, Ingress, HPA, PDB, resource requests/limits for JVM, Workload Identity
- [ ] Data on GCP trade-offs: Cloud SQL (HA + read replicas + IAM auth) vs AlloyDB vs Cloud Spanner vs Memorystore vs BigQuery vs Firestore
- [ ] Event-driven GCP: Pub/Sub (ordering keys, ack deadlines, DLQ, idempotent consumers) vs Cloud Tasks vs Managed Kafka
- [ ] Observability & FinOps: Cloud Logging (structured JSON), Cloud Trace (OTel), Cloud Monitoring SLOs/error budgets, cost optimization

---

## Pillar 7: AI — Google AI Engineering
### Foundations
- [ ] LLM fundamentals for engineers: tokens, context windows, temperature/top-p, latency (TTFT vs tokens/sec), pricing models
- [ ] Gemini API & Vertex AI via Google GenAI SDK (Java & Python): model routing (Flash vs Pro)
- [ ] Structured Outputs (JSON Schema) + validation + streaming (SSE) inside a Spring Boot service
- [ ] Tool / Function Calling with strict server-side authorization & loop limits
### Deep Internals & Top 1%
- [ ] Production RAG: structure-aware chunking, embeddings, hybrid search (vector + BM25), reranking, Vertex AI Vector Search / `pgvector`, grounded citations
- [ ] Context Caching (Vertex AI / Gemini) vs RAG cost & latency trade-offs
- [ ] Agentic Systems with **Google ADK (Agent Development Kit)**: single-agent vs multi-agent trade-offs, state/memory, guardrails
- [ ] Evaluation Harnesses: golden datasets, deterministic assertions + LLM-as-judge, regression gating before prompt/model swaps
- [ ] AI Security & Reliability: prompt injection defense, PII scrubbing, rate limits, fallback & circuit breakers on 429/timeouts

---

## Pillar 8: System Design (First-Principles Distributed Systems)
### Foundations
- [ ] Back-of-the-envelope capacity planning (QPS, storage, bandwidth, memory)
- [ ] Core building blocks: DNS, CDN, L4/L7 Load Balancers, Reverse Proxies, API Gateways
- [ ] Caching strategies (Cache-Aside, Write-Through, Write-Behind), invalidation, stampede mitigation
- [ ] Asynchronous processing: queues, pub/sub, backpressure, retries with jitter, DLQs, idempotency
### Deep Internals & Top 1%
- [ ] Distributed data: consistent hashing, sharding strategies, leader-follower & multi-leader replication, CAP & PACELC trade-offs
- [ ] Consistency & coordination: distributed locks (and why they aren't magic — fencing tokens!), Raft/Paxos intuition, Transactional Outbox, Saga pattern
- [ ] End-to-End Design Katas (design from naive → scaled):
  - [ ] Rate Limiter (distributed)
  - [ ] URL Shortener / Pastebin
  - [ ] Payment / Ledger Service (strong consistency + idempotency)
  - [ ] Notification / Webhook Delivery Engine
  - [ ] News Feed / Timeline (push vs pull hybrid)
  - [ ] Distributed Job Scheduler
  - [ ] Production AI RAG / Copilot Backend on GCP + Vertex AI
