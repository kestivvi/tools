# Crash course

The target, delivered as a series of **primers**: short Feynman explanations the
student reads in order. No reconnaissance rounds - the learning records stand in
for them. The map, the priors, and the writes are in `SKILL.md`.

## Phase 1: Read the records

Draw today's map of the target down to nodes the student holds, then class every
node from the priors in `SKILL.md`: the roadmap, prior maps, and the
`understanding.tsv` rows behind them. Read the rows, not only the classes - a
row's `reading` names the exact misconception a primer must repair.

The step is done when every node on the map carries one of:

- `:::known` - the newest record says transfer, and no later record disagrees.
- `:::shaky` - a stumble on record, or an older `:::known` a newer hit contradicts.
- no class - the records never touched it.

Write `map.mmd` with these classes. They are priors from records, so add no
`understanding.tsv` rows yet.

## Phase 2: Plan the parts

The **course** is every node that is not `:::known`, in dependency order, ending
at the target.

Cut the course into **parts**. One part is one primer:

- A part teaches **one idea**: a chain of at most three course nodes, each
  resting on the one before or on the ground.
- A part rests only on `:::known` nodes and earlier parts.
- A part starts fresh where a node pulls in a second, unrelated chain.

The part count is whatever this cut yields - one for a single missing node,
many for a whole block. Count follows the map, never a round number.

Write `course.md` in the session folder:

```
# <target>

Ground: <known labels the course rests on>

1. <part title> - <node labels> - <for a shaky node: the misconception on record>
2. ...
```

Show the plan with `map.mmd` linked, and ask for the go-ahead. The student's yes
starts part 1. Anything else corrects the plan: a node they say they know,
probe it once with a single question and reclass it; a node they say they lack,
add it. Then re-cut and show the plan again.

## Phase 3: The primers

One part per turn. Write the primer to `NN-slug.md` in the session folder (the
part's number), and show it in chat.

A **Feynman primer** explains the idea the way a patient friend would, to someone
bright who has never met it:

- **Start from ground.** Open on a `:::known` node or a thing from
  `_tutor/student-context/index.md`, and build from there.
- **Plain words first.** Describe the thing before naming it. A term enters only
  once its meaning is already on the page, then stays the same word throughout.
- **One analogy**, drawn from the student's own setting. Say where it breaks.
- **Short.** Short sentences, short paragraphs; the whole primer reads in about
  five minutes.
- **Repair on record.** For a `:::shaky` node, name the misconception from its
  `understanding.tsv` row and show why it fails.
- **Recap** in two or three sentences - the part in its simplest form.
- Add a picture when the idea has anatomy.

End the primer with one **transfer check**: a short case the primer did not
cover, answered in the student's own words.

Then wait. On the answer:

1. **Record** the part's nodes - a row in `understanding.tsv`, a state in
   `map.mmd`. Transfer is `:::known`; anything less is `:::shaky`.
2. **Repair** a miss in a few sentences aimed at the gap the answer shows, then one
   more check. A second miss stays `:::shaky`: note it in `course.md` beside the
   part, and move on - the next session picks it up.
3. **Answer** every question the student asks, then ask for the go-ahead to the
   next part.

A prerequisite a check exposes goes into the map and into `course.md` as a new
part ahead of the current one. Say so in one line.

The course ends when every part has had its check. Close with the parts still
`:::shaky`, as the list for the next session.
