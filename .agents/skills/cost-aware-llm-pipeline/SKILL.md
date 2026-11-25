---
name: cost-aware-llm-pipeline
description: Cost optimization patterns for Google Gemini and Vertex AI LLM pipelines — model routing by task complexity (Flash-Lite / Flash / Pro), immutable budget tracking, narrow retry logic, and Gemini Context Caching. Use when LLM spend or latency needs to come down, or when routing tasks across Gemini model tiers and budgets.
metadata:
  origin: ECC (Adapted for Google AI / Gemini)
---

# Cost-Aware LLM Pipeline (Google AI / Gemini & Vertex AI)

Patterns for controlling LLM API costs and latency while preserving output quality. Combines Gemini tier routing, immutable budget tracking, narrow transient-error retries, and Gemini Context Caching into a composable pipeline.

## When to Activate

- Building Spring Boot, Python, or Node services that call the Gemini API or Vertex AI
- Processing batches of documents/items with varying complexity
- Enforcing per-request or per-tenant spend limits
- Reducing Time-To-First-Token (TTFT) and input token cost on repeated prompts/docs

## Core Concepts

### 1. Model Routing by Task Complexity (Flash-Lite → Flash → Pro)

Default to the fastest/cheapest Gemini tier that passes your eval suite; escalate to Pro only when complexity demands deep reasoning.

```python
MODEL_FLASH_LITE = "gemini-2.5-flash-lite"  # Cheapest: classification, extraction, routing
MODEL_FLASH = "gemini-2.5-flash"            # Balanced: general RAG, structured output, tool use
MODEL_PRO = "gemini-2.5-pro"                # Deepest: complex architecture, multi-step reasoning

_PRO_CHAR_THRESHOLD = 12_000
_PRO_ITEM_THRESHOLD = 30

def select_model(
    text_length: int,
    item_count: int,
    requires_deep_reasoning: bool = False,
    force_model: str | None = None,
) -> str:
    """Route to the lowest-cost Gemini tier that meets quality requirements."""
    if force_model is not None:
        return force_model
    if requires_deep_reasoning or text_length >= _PRO_CHAR_THRESHOLD or item_count >= _PRO_ITEM_THRESHOLD:
        return MODEL_PRO
    if text_length < 1_500 and item_count <= 3:
        return MODEL_FLASH_LITE
    return MODEL_FLASH
```

*(Note: Verify exact current Gemini model IDs in Google AI Studio / Vertex AI docs before deploying to production.)*

### 2. Immutable Cost & Token Tracking

Track cumulative token usage and spend with immutable records (Python frozen dataclass or Java `record`) so auditing and concurrency stay bug-free.

```python
from dataclasses import dataclass

@dataclass(frozen=True, slots=True)
class CostRecord:
    model: str
    prompt_tokens: int
    cached_tokens: int
    output_tokens: int
    cost_usd: float

@dataclass(frozen=True, slots=True)
class CostTracker:
    budget_limit_usd: float = 1.00
    records: tuple[CostRecord, ...] = ()

    def add(self, record: CostRecord) -> "CostTracker":
        """Return a new tracker with the added record (never mutates self)."""
        return CostTracker(
            budget_limit_usd=self.budget_limit_usd,
            records=(*self.records, record),
        )

    @property
    def total_cost(self) -> float:
        return sum(r.cost_usd for r in self.records)

    @property
    def over_budget(self) -> bool:
        return self.total_cost > self.budget_limit_usd
```

### 3. Narrow Retry Logic With Jitter

Retry **only** on transient HTTP/RPC failures (`429 Too Many Requests`, `500`, `503`, timeouts). Fail fast on `400 Bad Request`, `401/403 Auth/IAM`, or `404 Not Found`.

```python
import random
import time
from google.genai.errors import APIError

_RETRYABLE_STATUS_CODES = {429, 500, 503, 504}

def call_with_retry(func, *, max_retries: int = 3, base_delay: float = 0.5):
    """Retry only on transient Gemini/Vertex API errors with exponential backoff + jitter."""
    for attempt in range(max_retries):
        try:
            return func()
        except APIError as err:
            if err.code not in _RETRYABLE_STATUS_CODES or attempt == max_retries - 1:
                raise
            delay = base_delay * (2 ** attempt) + random.uniform(0, 0.25)
            time.sleep(delay)
```

### 4. Gemini Context Caching (Cut Cost & Latency on Static Prefixes)

When sending a large static system prompt, codebase, or policy manual repeatedly across many queries, create a cached content handle via `google-genai` (Vertex AI or Gemini API) and reference `cached_content` on each `generate_content` call so you pay discounted cached-input rates instead of re-prefilling every turn.

- **Implicit caching**: Keep static instructions and shared documents strictly at the **top** of the prompt and put variable user input at the **bottom** so prefix caches hit.
- **Explicit Context Caching**: Create a TTL-bounded cache resource when reusing a large corpus (thousands of tokens) across high-frequency requests.

### 5. Enforce Hard Guardrails
- Always set `max_output_tokens` appropriate to the task (prevent runaway generation).
- Use `response_mime_type="application/json"` + `response_schema` to eliminate verbose markdown fluff.
- Check `usage_metadata` (`prompt_token_count`, `cached_content_token_count`, `candidates_token_count`) on every call and emit metrics to Cloud Monitoring / Micrometer.

## Best Practices
- **Start with Flash-Lite / Flash** and prove with an eval dataset (`eval-harness` skill) that Pro is actually needed before upgrading.
- **Set explicit budget caps** per batch job and per tenant — fail fast before overspending.
- **Keep model IDs in config/env**, never scattered as hardcoded strings.
- **Check if deterministic code/SQL/regex works first** — the cheapest LLM call is the one you never make.

## Anti-Patterns to Avoid
- Routing every request to Gemini Pro regardless of complexity
- Retrying on 400/401/403 errors or retrying without jitter (causes thundering herds)
- Putting timestamps or dynamic user IDs *before* static system instructions (breaks prefix cache hits!)
- Shipping prompt or model changes without measuring both quality delta and cost-per-1k-requests delta
