---
name: os-linux-internals
description: >-
  Hands-on Operating Systems and Linux internals mastery for Java/Spring Boot and
  distributed systems engineers. Use when debugging CPU, memory, GC, threads,
  deadlocks, disk I/O, networking, container OOMKills, or learning OS fundamentals
  from first principles (processes, virtual memory, syscalls, epoll, locks, cgroups).
---

# OS & Linux Internals (From First Principles to Production Debugging)

Top 1% backend engineers never treat the OS or JVM as magic. Every Spring Boot request, DB query, and GC pause ultimately translates into **CPU instructions, memory pages, syscalls, locks, and kernel buffers**.

## Core Mental Models (Bridge Fundamentals ↔ Java/Backend)

### 1. Processes, Threads & Scheduling
- **Process**: Isolated virtual address space, file descriptor table, PID.
- **OS Thread (`pthread` / Linux task)**: Shares address space & FDs, owns stack + registers.
- **JVM Mapping**:
  - Platform thread (`new Thread()`) = 1:1 Linux kernel thread (`~1 MB` stack, context switch costs ~1–10 µs + TLB/cache pollution).
  - Java 21+ Virtual Thread (`Executors.newVirtualThreadPerTaskExecutor()`) = M:N user-space continuation parked on ForkJoinPool carrier threads (cheap blocking I/O, **watch out for pinning** inside `synchronized` blocks on Java 21–23).
- **CFS / EEVDF Scheduler**: When runnable threads > CPU cores, **run-queue latency** spikes (tail latency!). Sizing thread pools:
  - CPU-bound: `≈ #cores` (or `cores + 1`).
  - Blocking I/O-bound: bounded by downstream DB/connection pool, NOT infinite threads.

### 2. Virtual Memory, Page Cache & Container OOMKills
- **Virtual vs Physical (RSS)**: `malloc` / JVM `-Xmx` reserves virtual address space; physical pages are faulted in lazily (minor page fault).
- **Total JVM Memory ≠ Heap!**
  `RSS ≈ Heap (-Xmx) + Metaspace + Direct ByteBuffers (Netty/NIO) + Thread Stacks (#threads × -Xss) + Code Cache + GC/Native overhead`.
- **Why containers get `OOMKilled` (Exit Code 137)**: Setting `-Xmx` equal to the Kubernetes/Docker memory limit leaves zero room for off-heap + page cache → kernel cgroup OOM killer terminates the JVM!
  - Rule of thumb: Set `-XX:MaxRAMPercentage=65.0` to `75.0` and always inspect native memory (`-XX:NativeMemoryTracking=summary`).
- **Linux Page Cache**: Databases (PostgreSQL/MySQL) rely heavily on the OS page cache (`read`/`write`/`mmap`/`fsync`). Dirty pages flush asynchronously unless `fsync` is called (WAL durability!).

### 3. I/O Models & Networking (`epoll`, Sockets, TCP)
- **Blocking I/O (Tomcat default)**: 1 thread blocks in `read()` per active request. Simple, debuggable, great with virtual threads.
- **Non-Blocking Event Loop (`epoll` / Netty / WebFlux)**: Single thread monitors thousands of FDs via `epoll_wait()`. Trade-off: higher concurrency per core, but **one blocking call on an event-loop thread stalls all connections**.
- **TCP Pitfalls in Microservices**:
  - `TIME_WAIT` & ephemeral port exhaustion → always use HTTP connection pooling!
  - `LISTEN` backlog (`somaxconn`) drops under traffic bursts.
  - TCP Keepalive vs idle connection timeouts behind load balancers (GCP LB closes idle sockets after 600s).

### 4. Concurrency Primitives (Hardware → Kernel → JVM)
- **CPU Cache & Visibility**: L1/L2 per core, L3 shared. Without memory barriers (`volatile`, `Atomic*`, locks), writes sit in store buffers and another core sees stale values.
- **Locks & Futexes**: Uncontended lock = fast userspace CAS (`lock cmpxchg`). Contended lock = kernel `futex` syscall + thread sleep + wake-up storm.
- **Java Mapping**: `ReentrantLock` / `Semaphore` / `CountDownLatch` are built on `AbstractQueuedSynchronizer (AQS)` using `VarHandle`/`Unsafe` CAS + `LockSupport.park()` (`futex`).

---

## The USE Method & Production Linux Diagnostic Playbook

When something is slow or broken, systematically check **Utilization, Saturation, Errors** across CPU, Memory, Disk, Network:

```bash
# 1. 60-Second Triage (Brendan Gregg checklist)
uptime                       # Load average vs core count (nproc)
dmesg -T | tail -n 30        # Kernel errors, OOMKills!
vmstat 1 5                   # Run queue (r), swap (si/so), context switches (cs), CPU (us/sy/wa)
mpstat -P ALL 1 3            # Per-CPU imbalance (single hot core / GC / lock)
pidstat 1 5                  # Per-process CPU & involuntary context switches
iostat -xz 1 3               # Disk utilization, await latency, queue depth
free -h                      # Available memory vs buff/cache
ss -s && ss -tanp | head     # Socket states (ESTABLISHED, TIME_WAIT, CLOSE_WAIT leaks!)

# 2. Deep Process & JVM Inspection
lsof -p <pid> | wc -l        # File descriptor leak check (ulimit -n)
strace -f -c -p <pid>        # Syscall breakdown (NEVER leave running long on prod)
jcmd <pid> VM.native_memory summary
jcmd <pid> Thread.print      # Thread dump -> spot BLOCKED / deadlock / pool exhaustion
jcmd <pid> GC.heap_info
# Prefer async-profiler / Java Flight Recorder (JFR) for low-overhead CPU + allocation flamegraphs
```

## Reasoning Checklist for Every OS/Linux Question
1. Which layer is involved? (User space JVM → Syscall boundary → Kernel subsystem → Hardware)
2. Is the bottleneck **CPU, Memory, Lock Contention, Disk I/O, or Network I/O**?
3. What single Linux/JVM command proves or disproves our hypothesis?
4. What is the trade-off of the fix (latency vs throughput, memory vs CPU, durability vs speed)?
