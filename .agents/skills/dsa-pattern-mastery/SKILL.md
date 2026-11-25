---
name: dsa-pattern-mastery
description: >-
  First-principles Data Structures and Algorithms (DSA) mastery in Java. Use when
  practicing algorithms, solving LeetCode/interview problems, analyzing time/space
  complexity, building pattern recognition muscle memory, or optimizing hot-path
  Java code. Enforces brute-force-first derivation, signal-to-pattern mapping,
  invariant proofs, and clean Java 17+ implementations.
---

# DSA Pattern Mastery (Java First-Principles)

Build automatic pattern recognition so that reading a problem statement triggers the right mental model, data structure, and invariant within 60 seconds.

## Always Follow the 5-Stage Progression

1. **Constraints → Target Complexity**
   - `n <= 20`: Backtracking / Bitmask DP — `O(2^n)` or `O(n!)`
   - `n <= 500`: `O(n^3)` (Floyd-Warshall, Interval DP)
   - `n <= 5,000`: `O(n^2)` (2D DP, nested loops)
   - `n <= 10^5 – 10^6`: `O(n log n)` or `O(n)` (Sorting, Heap, Two Pointers, Sliding Window, Prefix Sum, Binary Search, Linear DP)
   - `n >= 10^9`: `O(log n)` or `O(1)` (Binary Search, Math, Bit Manipulation, Matrix Exponentiation)
2. **Signal → Pattern Lookup** (Identify *before* coding!)
3. **Brute Force First**: Write or trace the naive solution and pinpoint the **redundant work** (repeated scans, recomputed subproblems, linear lookups).
4. **State & Invariant**: State the exact invariant maintained at every step (e.g., *"window `[l..r]` always contains at most `k` zeros"* or *"stack is strictly decreasing"*).
5. **Java Implementation + Edge-Case Dry Run**: Trace on empty, 1-element, all-equal, negative, and `Integer.MAX_VALUE` inputs.

---

## Master Signal → Pattern Matrix

| Problem Signal / Clue | Suspect Pattern | Java Data Structure(s) |
|-----------------------|-----------------|------------------------|
| Contiguous subarray / substring + condition (min/max/count) | **Sliding Window** (variable or fixed) | `int[]` freq / `HashMap`, two indices `l, r` |
| Subarray sum equals `k` (with **negatives**) | **Prefix Sum + HashMap** | `HashMap<Long, Integer>` |
| Sorted array / pair / triplet / palindrome | **Two Pointers** | Primitive indices `l, r` |
| Next greater / smaller element, histogram, span | **Monotonic Stack** | `Deque<Integer> stack = new ArrayDeque<>()` |
| Sliding window maximum / minimum | **Monotonic Deque** | `ArrayDeque<Integer>` storing indices |
| "Minimize the maximum" or "Maximize the minimum" + monotonic predicate | **Binary Search on Answer** | `long lo, hi; mid = lo + (hi - lo) / 2` |
| Top-K, K-th largest, merge K sorted, running median | **Heap (Priority Queue)** / Two Heaps | `PriorityQueue<T>` (min-heap default) |
| Overlapping intervals, scheduling, meeting rooms | **Sort + Sweep Line / Greedy** | `Arrays.sort(intervals, Comparator.comparingInt(a -> a[0]))` |
| Shortest path in **unweighted** graph / grid / level-by-level | **BFS** | `ArrayDeque<int[]>`, `boolean[][] visited` |
| Shortest path with **non-negative** weights | **Dijkstra** | `PriorityQueue<long[]>` (lazy deletion) |
| Ordering with dependencies / cycle detection in DAG | **Topological Sort (Kahn's BFS)** | `int[] indegree`, `ArrayDeque<Integer>` |
| Dynamic connectivity / components / Kruskal MST | **Union-Find (DSU)** | `parent[]`, `rank[]` (path compression + union by rank) |
| Prefix matching / dictionary search / word grid | **Trie** | Fixed `TrieNode[26]` array for lowercase ASCII |
| Optimal substructure + overlapping subproblems | **DP** (Top-down Memo → Bottom-up Tab → Space-optimized) | `int[]` / `int[][]` |
| Generate all subsets / permutations / valid boards | **Backtracking** (Choose → Explore → Unchoose) | `List<T>` path + pruning |
| Range sum / RMQ with **point updates** | **Fenwick Tree (BIT) / Segment Tree** | `long[] tree` |

---

## Java-Specific DSA Traps (Burn Into Muscle Memory)

- **Never use `java.util.Stack` or `LinkedList` as stack/queue**: Use `ArrayDeque<>` (faster, cache-friendly, no legacy synchronization).
- **Comparator Overflow**: NEVER write `(a, b) -> a - b` (overflows when `a = -2e9, b = 2e9`). Always use `Integer.compare(a, b)` or `Comparator.comparingInt(...)`.
- **`==` on boxed `Integer`**: `Integer` caches `-128..127`; beyond that `==` compares references! Always use `.equals()` or unbox to `int`.
- **String concatenation in loops**: `O(n^2)` allocations — always use `StringBuilder`.
- **HashMap worst-case & resizing**: Pre-size when `n` is known (`HashMap.newHashMap(n)` in Java 19+); prefer `int[26]` or `int[128]` over `HashMap<Character, Integer>` for ASCII.
- **Overflow in sums/products**: Use `long` for prefix sums, binary search `mid`, and grid coordinates.
- **`Arrays.sort(int[])` vs `Arrays.sort(Integer[])`**: Primitive `int[]` uses Dual-Pivot Quicksort (`O(n^2)` worst case on adversarial inputs); `Integer[]` uses TimSort (`O(n log n)` worst case).

---

## Muscle-Memory Drill Protocol

When practicing a problem:
1. User states **Constraint → Target Big-O → Suspected Pattern** in 2 minutes before writing code.
2. User explains **Brute Force** and the exact **redundant computation** to kill.
3. User writes the **Invariant** in 1 sentence.
4. Implement cleanly in Java 17+ with JUnit tests covering edge cases.
5. Record a 3-line entry in `journal/pattern-bank.md` and schedule a blind re-solve in 3 days.
