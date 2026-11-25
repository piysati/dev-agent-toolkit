# Pattern Bank — Muscle-Memory & Spaced Repetition Ledger

> **Purpose**: Every time you solve a DSA problem, fix a gnarly Spring/SQL/Linux bug, or crack a system design bottleneck, log the **Trigger → Pattern → Brute Force → Optimal → Trade-Off** here. Run `/drill review` to quiz yourself on due dates (+1d → +3d → +7d → +21d).

## Review Queue (Spaced Repetition)

| ID | Pillar | Pattern / Problem | Trigger Signal | Confidence (1–5) | Next Review |
|----|--------|-------------------|----------------|------------------|-------------|
| P-001 | Example / DSA | Prefix Sum + HashMap | Contiguous subarray sum = K with negative numbers | 3 | (Template) |

---

## Pattern Cards

### P-001 — [Example] Prefix Sum + HashMap (Subarray Sum Equals K)
- **Pillar**: DSA
- **Signal / Clue**: Contiguous subarray sum equals target `k`, array contains **negative numbers** (so Sliding Window monotonicity breaks!).
- **Brute Force**: Check all `(i, j)` pairs → `O(n^2)` time, `O(1)` space. Redundant work: re-summing overlapping subarrays.
- **Optimal Insight**: Maintain running `prefixSum`. Subarray `(i..j]` sums to `k` iff `prefixSum[j] - prefixSum[i] == k` → look up `prefixSum - k` in a `HashMap<Long, Integer>` counting prior prefix frequencies (seed `map.put(0L, 1)`).
- **Complexity**: `O(n)` time, `O(n)` space.
- **Trade-Off**: Trades `O(n)` memory for eliminating the inner `O(n)` scan.
- **Gotcha**: Seed `0 -> 1` before loop; use `long` to avoid overflow; update map *after* querying `prefixSum - k`.

---

<!-- Append new Pattern Cards below using /retro-pattern -->
