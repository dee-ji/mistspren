# Mistspren Charter

## Purpose

Mistspren is a structured intelligence system for converting technical information into durable understanding, defensible decisions, and executable roadmaps.

It exists to support long-term architecture and engineering work around networking, network automation, service-provider infrastructure, inventory systems, source-of-truth platforms, discovery systems, and AI-assisted engineering workflows.

Mistspren is not a note dump.

Mistspren is an evidence-driven decision engine.

---

## First Ideal

**Information before opinion.**

**Evidence before inference.**

**Understanding before action.**

This means the system must not jump directly from raw input to conclusions. Knowledge must be staged, sourced, linked, and tested before it changes the roadmap.

---

## Core Pipeline

```text
0-raw/
→ 1-workbench/
→ 2-atoms/
→ 3-threads/
→ 4-decisions/
→ 5-roadmap/
```

Each stage has a specific purpose.

No stage may be skipped.

---

## Directory Structure

```text
mistspren/
├── 0-raw/
│   ├── articles/
│   ├── docs/
│   ├── meetings/
│   ├── logs/
│   └── ideas/
│
├── 1-workbench/
│   ├── extracts/
│   ├── claim-maps/
│   ├── questions/
│   └── candidate-atoms/
│
├── 2-atoms/
│   ├── networking/
│   ├── automation/
│   ├── inventory/
│   ├── source-of-truth/
│   ├── ai-agents/
│   ├── discovery/
│   └── architecture/
│
├── 3-threads/
│   ├── architecture/
│   ├── implementation/
│   ├── operations/
│   ├── risks/
│   └── strategy/
│
├── 4-decisions/
│   ├── accepted/
│   ├── superseded/
│   └── rejected/
│
├── 5-roadmap/
│   ├── initiatives/
│   ├── milestones/
│   ├── tasks/
│   └── backlog/
│
└── friction/
    ├── open/
    ├── resolved/
    └── archived/
```

---

## Stage Definitions

### 0-raw

Raw intake.

Examples:

- Articles
- Research papers
- Vendor docs
- Meeting notes
- Design ideas
- CLI output
- Logs
- Screenshots
- Transcripts

Rules:

- Do not rewrite the source.
- Do not interpret yet.
- Preserve original context.
- Record source metadata.

Suggested filename:

```text
YYYY-MM-DD_source_topic.md
```

---

### 1-workbench

Temporary analysis layer.

Purpose:

- Extract claims
- Identify evidence
- Raise questions
- Detect contradictions
- Propose candidate atoms

Rules:

- Workbench notes are allowed to be messy.
- Workbench notes should not be treated as permanent knowledge.
- Anything important must graduate into atoms.

Suggested filename:

```text
YYYY-MM-DD_workbench_topic.md
```

---

### 2-atoms

Permanent atomic knowledge.

One atom = one durable idea.

Rules:

- Every atom must have a source.
- Every atom must represent one concept.
- Every atom must link related atoms when known.
- No unsourced claims are allowed.

Atom template:

```markdown
# Atom: <Title>

## Statement

<One clear claim or concept.>

## Evidence

<Quoted or summarized evidence.>

## Source

- Type: <article | doc | meeting | log | experiment | code | other>
- Reference: <path, URL, commit, person, system, etc.>
- Date captured: <YYYY-MM-DD>

## Confidence

<high | medium | low>

## Related Atoms

- <link>

## Notes

<Optional clarification.>
```

---

### 3-threads

Synthesis layer.

Threads connect multiple atoms into understanding.

Threads answer:

**What does this mean?**

Examples:

- Why CLI-based discovery may be more reliable than SNMP in brownfield provider networks
- How inventory truth differs from monitoring truth
- How an agent should discover device reachability paths
- How Mistspren should model physical vs logical devices

Thread template:

```markdown
# Thread: <Title>

## Question

<What this thread is trying to understand.>

## Summary

<Current synthesis.>

## Supporting Atoms

- <atom link>
- <atom link>

## Patterns

<Recurring ideas or relationships.>

## Tradeoffs

<Competing design choices.>

## Open Questions

- <question>

## Related Friction Records

- <friction link>

## Current Interpretation

<What the evidence appears to mean right now.>
```

---

### 4-decisions

Decision records.

Decisions answer:

**What should we do?**

Rules:

- Decisions must be backed by threads.
- Decisions must include alternatives.
- Decisions must preserve history.
- Superseded decisions are moved, not deleted.

Decision template:

```markdown
# Decision: <Title>

## Status

<proposed | accepted | rejected | superseded>

## Date

<YYYY-MM-DD>

## Context

<Why this decision exists.>

## Supporting Threads

- <thread link>

## Alternatives Considered

### Option A

<Description, pros, cons.>

### Option B

<Description, pros, cons.>

## Decision

<Chosen direction.>

## Rationale

<Why this is the best current decision.>

## Expected Outcome

<What should improve.>

## Risks

<What could go wrong.>

## Review Trigger

<When this decision should be revisited.>
```

---

### 5-roadmap

Execution layer.

Roadmap answers:

**What happens next?**

Rules:

- Roadmap items must trace to decisions.
- Roadmap changes must not be made directly from raw notes.
- Tasks should be concrete and testable.

Roadmap item template:

```markdown
# Roadmap Item: <Title>

## Status

<backlog | planned | active | blocked | complete>

## Linked Decision

- <decision link>

## Objective

<What this accomplishes.>

## Milestones

- [ ] <milestone>

## Tasks

- [ ] <task>

## Validation

<How success will be proven.>

## Risks / Blockers

<Current risks.>
```

---

## Friction Records

A friction record captures conflicting evidence or unresolved tension.

Friction is not failure.

Friction is where intelligence improves.

Create a friction record when:

- Two sources disagree
- An assumption conflicts with operational reality
- A design goal conflicts with implementation complexity
- Evidence is incomplete but action pressure exists
- A vendor claim may be hype

Friction template:

```markdown
# FRICTION: <Title>

## Status

<open | investigating | resolved | archived>

## Competing Claims

### Claim A

<Claim and source.>

### Claim B

<Claim and source.>

## Why It Matters

<Impact on architecture, decisions, or roadmap.>

## Confidence

- Claim A: <high | medium | low>
- Claim B: <high | medium | low>

## Open Questions

- <question>

## Resolution Path

<What evidence would resolve this.>

## Final Resolution

<Only fill in when resolved.>
```

---

## Knowledge Integrity Rules

1. No source, no atom.
2. No atom, no thread.
3. No thread, no decision.
4. No decision, no roadmap change.
5. Never silently overwrite knowledge.
6. Preserve superseded decisions.
7. Link related concepts.
8. Separate facts, assumptions, hypotheses, and decisions.
9. Create friction records for conflicts.
10. Favor operational reality over theoretical elegance.

---

## Mistspren Operating Mode for Agents

When an agent receives a request, it should first determine the stage:

- Is this raw intake?
- Is this extraction or analysis?
- Is this an atom candidate?
- Is this synthesis?
- Is this a decision?
- Is this roadmap execution?

Then it should move the request forward one stage at a time.

The agent should not jump straight from idea to implementation unless the necessary upstream artifacts already exist.

---

## Project Mission Areas

Mistspren should continuously build intelligence around:

- Networking
- Network Automation
- Service Provider Architecture
- Inventory Systems
- Source of Truth Platforms
- AI Agents
- Discovery Systems
- Intent-Based Networking
- Network Modeling
- Brownfield Infrastructure
- Operational Safety
- Engineering Decision-Making

---

## Engineering Biases

Favor:

- Single-purpose artifacts
- Clear traceability
- Simple workflows
- Git-friendly files
- Human-readable markdown
- Reproducible decisions
- Operationally safe automation
- Extensible architecture

Avoid:

- Hype-driven decisions
- Unverifiable claims
- Magic agents
- Hidden state
- Premature abstraction
- Vendor lock-in
- Roadmap churn without decision records

---

## Initial GitHub Repository Recommendation

Recommended repository name:

```text
mistspren
```

Recommended initial files:

```text
README.md
MISTSPREN_SYSTEM_PROMPT.md
MISTSPREN_CHARTER.md
.gitignore
0-raw/.gitkeep
1-workbench/.gitkeep
2-atoms/.gitkeep
3-threads/.gitkeep
4-decisions/.gitkeep
5-roadmap/.gitkeep
friction/.gitkeep
```

---

## Long-Term Goal

Mistspren should eventually connect to a Codex-enabled development workflow where agents can:

- Read existing project knowledge
- Add raw intake
- Propose atoms
- Maintain threads
- Draft decision records
- Suggest roadmap changes
- Generate implementation plans
- Create pull requests
- Preserve knowledge traceability

The objective is not to automate thinking away.

The objective is to make thinking durable, inspectable, and executable.
