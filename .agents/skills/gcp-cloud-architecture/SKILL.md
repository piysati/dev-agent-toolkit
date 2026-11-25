---
name: gcp-cloud-architecture
description: >-
  Hands-on Google Cloud Platform (GCP) architecture and engineering guide for
  Java/Spring Boot, data, and AI workloads. Use when choosing GCP services,
  designing cloud architectures, debugging IAM/VPC/Cloud Run/GKE/Cloud SQL/PubSub,
  or weighing cost, reliability, security, and operational trade-offs on GCP.
---

# GCP Cloud Architecture (First-Principles & Production Trade-Offs)

Choose GCP primitives by reasoning from **workload shape, consistency, latency, blast radius, and total cost of ownership**—never by buzzword.

## 1. Compute Trade-Off Matrix (Java / Spring Boot Focus)

| Service | Best For | Trade-Offs & JVM Considerations |
|---------|----------|---------------------------------|
| **Cloud Run** | Stateless HTTP/gRPC APIs, webhooks, event workers, rapid iteration | Scale-to-zero saves cost, **but JVM cold starts hurt** unless using `min-instances >= 1`, startup CPU boost, AppCDS, or GraalVM Native Image. Request timeout capped; no persistent local disk. |
| **GKE (Autopilot / Standard)** | Complex microservices, custom networking, sidecars, stateful sets, high steady throughput, GPU pods | Higher operational surface; Autopilot reduces node ops. Must tune JVM `-XX:MaxRAMPercentage`, liveness/readiness probes (`/actuator/health/readiness`), PDBs, and HPA. |
| **Compute Engine (GCE)** | Legacy workloads, custom kernels, ultra-low-latency tuning, self-managed DBs | Full OS control, highest ops burden (patching, MIG autoscaling, health checks). |
| **Cloud Run Jobs / Functions** | Short batch jobs, lightweight glue triggers | Keep thin; avoid giant Spring Boot fat jars for sub-second event glue. |

## 2. Storage & Database Trade-Off Matrix

| Need | Primary GCP Choice | Alternative & When to Switch |
|------|--------------------|------------------------------|
| Relational OLTP (regional, Postgres/MySQL) | **Cloud SQL** (HA regional + read replicas) | **AlloyDB** for heavy Postgres analytical/HTAP + high throughput; **Cloud Spanner** ONLY when you truly need global strong consistency + horizontal write scaling (high cost!). |
| Key-value / Low-latency cache / Rate limiting | **Memorystore (Redis / Valkey)** | Watch VPC peering / Private Service Access & eviction policy (`allkeys-lru` vs `noeviction`). |
| Document / Mobile / Real-time sync | **Firestore** | Not for complex ad-hoc joins or heavy aggregations. |
| Wide-column / High-write time-series / IoT | **Cloud Bigtable** | Avoid for small datasets (minimum node cost is steep); design row keys carefully to prevent hotspotting. |
| Analytics / Data Warehouse | **BigQuery** | Serverless columnar OLAP; partition + cluster tables to control bytes-scanned cost! Never use for OLTP point updates. |
| Blobs / Artifacts / Backups / Data Lake | **Cloud Storage (GCS)** | Signed URLs for direct client upload/download (never proxy giant files through Spring Boot!). Lifecycle rules for Nearline/Coldline/Archive. |

## 3. Messaging & Async Patterns
- **Pub/Sub**: Decoupled pub/sub, fan-out, high throughput, **at-least-once delivery** (consumers MUST be idempotent! Configure Dead-Letter Topics + ack deadlines).
- **Cloud Tasks**: Explicit HTTP task queues with **rate limits, scheduled delays, and per-task retries** (great for calling flaky third-party APIs without overwhelming them).
- **Managed Service for Apache Kafka**: Choose when you need strict partition ordering, log compaction, replayable streams, or Kafka ecosystem compatibility.

## 4. Security, IAM & Networking Non-Negotiables
- **Never export JSON Service Account keys!** Use **Workload Identity Federation** (GKE / GitHub Actions) and attached runtime Service Accounts (Cloud Run / GCE).
- **Least Privilege**: Grant predefined granular roles (`roles/cloudsql.client`, `roles/secretmanager.secretAccessor`), never `roles/editor` or `roles/owner`.
- **Secrets**: Store in **Secret Manager** and inject via env/volume mount — never in `application.yml` or git.
- **Networking**:
  - Private IP for Cloud SQL & Memorystore via Private Service Connect / Direct VPC Egress.
  - Cloud Load Balancing + **Cloud Armor** (WAF + DDoS + rate limiting) at the edge.
  - VPC Service Controls for sensitive data perimeters.

## 5. Observability & Reliability on GCP
- **Structured JSON Logs** (`logback` JSON encoder with `traceId`, `spanId`, `severity`) → Cloud Logging parses fields automatically and correlates with **Cloud Trace**.
- **OpenTelemetry** → export traces to Cloud Trace and metrics (RED: Rate, Errors, Duration + JVM GC/HikariCP pool) to Cloud Monitoring.
- **Design for Failure**: Regional redundancy (multi-zone HA), Cloud SQL automated backups + PITR, retry with exponential backoff + jitter, circuit breakers (Resilience4j).

## Reasoning Protocol for Any GCP Design
1. State traffic shape (QPS, burstiness, payload size, regional vs global) and SLOs (availability, p99 latency, RPO/RTO).
2. Start with the **simplest managed architecture** (usually Cloud Run + Cloud SQL + GCS + Pub/Sub).
3. Justify every upgrade (e.g., Cloud Run → GKE, Cloud SQL → Spanner) with an **explicit bottleneck and cost trade-off**.
4. Draw the **IAM + Network trust boundary** (what is public, what is private, which SA has which role).
