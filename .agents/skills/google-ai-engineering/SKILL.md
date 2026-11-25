---
name: google-ai-engineering
description: >-
  Hands-on Google AI engineering mastery: Gemini API, Vertex AI, Java & Python
  GenAI SDKs, structured outputs, tool/function calling, RAG & grounding, Agent
  Development Kit (ADK), evaluations, and production integration with Spring Boot.
  Use when designing, building, debugging, or evaluating Google AI features.
---

# Google AI Engineering (Production-Grade, First-Principles)

Treat LLMs as **probabilistic, latency-bound, metered system components**—not magic oracles. Combine solid backend engineering (contracts, retries, caching, evals, observability) with Google's AI stack.

## 1. Google AI Stack Map (Know When to Use What)

| Layer | Option A (Fast Start) | Option B (Enterprise / GCP) | Trade-Off |
|-------|-----------------------|-----------------------------|-----------|
| **Model Access** | **Gemini Developer API** (API key via Google AI Studio) | **Vertex AI** (IAM, VPC-SC, regional residency, CMEK, enterprise SLAs, provisioned throughput) | Prototype with Gemini API; ship enterprise/regulated workloads on **Vertex AI**. Both share the unified **Google GenAI SDK** (`google-genai` in Java/Python/JS). |
| **Model Selection** | **Gemini Flash / Flash-Lite** (low latency, high throughput, cheap) | **Gemini Pro** (complex reasoning, architecture, hard synthesis) | Route by task complexity! Never pay Pro latency/cost for classification or extraction that Flash nails. |
| **Knowledge / Memory** | **Long Context + Context Caching** (up to 1M+ tokens, cached prefix reduces cost & TTFT) | **RAG** (Embeddings + Vertex AI Vector Search or PostgreSQL `pgvector` + reranking) | Use Context Caching when corpus fits cleanly and repeats across queries; use RAG when corpus is huge, dynamic, or needs per-user ACL filtering. |
| **Agent Orchestration** | Single-turn Structured Output / Tool Calling | **Google ADK (Agent Development Kit)** (multi-agent workflows, tool lifecycle, session state, evals) | **Karpathy Rule**: Use a single deterministic pipeline or one LLM call + tools before reaching for multi-agent graphs! |
| **Java / Spring Boot** | Official **Google GenAI Java SDK** (`com.google.genai:google-genai`) | **Spring AI** (Google Vertex AI / GenAI starter) | Official SDK tracks newest Gemini features fastest (caching, Live API, grounding); Spring AI gives Spring idioms & provider portability. |

## 2. Core Production Patterns

### A. Structured Outputs (Contracts, Not Regex!)
- Always enforce a JSON Schema (`responseMimeType: "application/json"` + `responseSchema`) for downstream code consumption.
- Validate the parsed DTO in Java with Bean Validation (`@Valid`) and handle refusal/truncation (`finishReason != STOP`).

### B. Tool / Function Calling Loop
1. Define narrow, unambiguous tool schemas with clear parameter descriptions.
2. **Never trust model-supplied arguments blindly**: re-authorize user permissions (`userId`, tenant isolation) on the server before executing any tool!
3. Cap maximum tool-loop iterations (e.g., max 5 steps) and enforce per-call timeouts to prevent runaway loops and bill spikes.

### C. RAG Done Right (Naive RAG → Production RAG)
- **Naive RAG fails on**: bad chunking, vocabulary mismatch (exact IDs/error codes), no citation verification, stale embeddings.
- **Production Upgrade Ladder**:
  1. Structure-aware chunking (headers/paragraphs/code blocks) + metadata filtering (tenant/date/acl).
  2. **Hybrid retrieval** (dense vector embeddings + BM25/keyword lexical search) + Reciprocal Rank Fusion (RRF).
  3. Cross-encoder / LLM reranker on top-20 → pass top-5 to Gemini.
  4. Grounded citations + "say I don't know if unsupported" rule.
  5. Measure retrieval separately from generation (**Recall@K / MRR** vs **Faithfulness / Answer Relevance**).

### D. Context Caching, Streaming & Latency Engineering
- **Stream responses** (SSE / WebFlux) so users see Time-To-First-Token (TTFT) in <1s instead of waiting 8s.
- Use **Vertex AI / Gemini Context Caching** for large static system prompts, docs, or codebases queried repeatedly.
- Never block Tomcat request threads indefinitely on LLM calls — configure explicit HTTP timeouts, bounded thread pools (or Java 21 virtual threads), circuit breakers, and fallback behavior.

### E. Evals Are Unit Tests for AI (Non-Negotiable)
Before changing a prompt, model, or chunk size:
1. Build a **golden dataset** (30–100 real examples including adversarial & edge cases).
2. Run deterministic checks first (valid JSON, schema compliance, latency, token budget, regex/tool-call accuracy).
3. Use LLM-as-a-judge (or Vertex AI Gen AI Evaluation Service) with clear rubrics for qualitative fidelity/groundedness.
4. Compare **delta vs baseline** — never ship prompt changes on "vibes."

## 3. Security & Cost Guardrails
- **Prompt Injection Defense**: Separate system instructions from untrusted user/retrieved content; never let retrieved text grant privileges or trigger state-changing tools without confirmation.
- **PII Redaction**: Scrub sensitive fields before logging prompts/responses (or use Cloud DLP / Sensitive Data Protection).
- **Budget Controls**: Track `promptTokenCount`, `candidatesTokenCount`, `cachedContentTokenCount` per request/tenant; set per-user rate limits and hard max output tokens.

## Reasoning Checklist for Every Google AI Task
1. Does this problem actually need an LLM, or is deterministic code/SQL/regex faster, cheaper, and 100% reliable?
2. What is the simplest architecture (1 prompt + schema → RAG → single agent with tools → multi-agent ADK)?
3. How will we **measure quality** (eval dataset + metrics) and **bound latency/cost**?
4. What happens when the model hallucinates, times out, or hits quota (429)?
