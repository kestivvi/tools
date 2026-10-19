# Step by step

Three phases: reconnaissance, the route, the lesson. The map, the priors, and the
writes are in `SKILL.md`.

## Phase 1: Reconnaissance

Two moves, repeated:

- **Mapping** - draw the map of what the target requires, down to nodes
  the student already holds. The first map is a hypothesis, not a survey.
- **Diagnosis** - probe the frontier: nodes the student does not know yet,
  whose prerequisites they do know. Probe laterally too - the map is drawn from
  the subject, so it misses routes the student brings from elsewhere, and a hit
  there adds an entry point the map never had.

### Probing

A **path** is a chain of untested nodes running from a `:::known` node up to the
target. Each round, take every unresolved path and probe its **midpoint** - one
probe per path.

A probe **measures** one node, and the student supplies that node: the probe
carries the scenario, the vocabulary, and at most one fact the student does not
already hold. Recon runs **blind** - the Route is the debrief.

```
## Runda N

❓ **P1**: <question body>

---

❓ **P2**: <question body>
```

Then wait. The answers close one round and open the next:

1. **Record** each probed node - a row in `understanding.tsv`, a state in
   `map.mmd`. A right answer for a wrong reason is `:::shaky`; a wrong model is
   recorded and routed, and Phase 3 repairs it.
2. **Grow** the map: a miss names a prerequisite the map lacks - add it below the
   node; a hit on something you never drew is a lateral entry point - add it.
   New nodes cut new paths.
3. **Probe** again.

Recon ends on a round that leaves every path resolved - each node on it
`:::known` or `:::shaky`.

## Phase 2: The route

Hand the map back to the student as a **route**: where they stand, and the path
today takes from there.

1. **Ground** - the `:::known` nodes today's route rests on, as a list of
   labels. Name them, do not re-explain them.
2. **Route** - the frontier nodes today crosses, numbered in dependency order,
   ending at the target, one label each. For a `:::shaky` node, add the one
   sentence of what went wrong in its probe.

Link `map.mmd` under the route for the student who wants the whole map.

Then ask for the go-ahead.

The student's explicit yes is the only way into the lesson. Anything else is a
correction to the map: patch the map, go back to Phase 1 and probe the node they
disputed, then show the route again.

## Phase 3: The lesson

Take the route one node at a time.

Per node, pick a technique and teach. Chain further techniques as the node needs
them. Name each technique you pick in one line. The pick is yours.

- **Socratic** - fits a node the student can reason out from its prerequisites.
- **Feynman** - fits a node simpler read than derived.
- **Puzzle** - fits a node with a counter-intuitive turn.
- **Worked example** - fits a procedure or a calculation.
- **Playground** - fits a spatial, dynamic, or numeric node.

Teach in words that stand alone. Add a picture when the node has anatomy.

Silence is not evidence. When the student's reply leaves part of your question
untouched, ask that part again before you class the node.

Answer every question the student asks and ask whether it landed. Their yes
opens the next node, and it can arrive well after transfer.

A node on transfer goes `:::known`; a `:::shaky` node stays on the route.

`:::known` ends the node, not the turn. Ask for the go-ahead and stop.

A prerequisite the lesson exposes - a node the map lacks, or a `:::known` that
clearly is not - goes into the map and into the route ahead of the current node.
Say so in one line, and teach it.

The lesson ends when every node on the route is `:::known`.

### Techniques

The menu above is the full list. Only techniques with rules appear here.

#### Socratic

- **Derive.** One question at a time. Wait.
- After two hints on one node, choose another technique.

#### Puzzle

- **Why?** A result that should not have happened.
- Name the controls - everything held equal. Each one closes an easy explanation.
- The hook's own text cannot answer the question it asks.
- Ask, then stop. The answer is what the node teaches.
- Ask it again when the node is taught. The student answers it, not you.

#### Worked example

- **I do one, you do the next.**
- Name every step, including the one you would skip.
- The next case has the same shape and different numbers.

#### Playground

- **Move it.** Write a single HTML file in the session folder. No build step.
- Build it with `/ponytail full`.
- Give them one variable to move and one thing to watch.
- Ask for their prediction before they touch it.
- Set the ranges so the surprise falls inside them.
- Ask what they saw, and where it differed from their prediction.
