---
name: never-say-actually
description: Avoid filler words like "actually", "wait", "hmm", and other verbal stutters when thinking, narrating, or reasoning. Flow directly from thought to thought instead of announcing self-corrections aloud. Use whenever writing internal thinking, problem-solving narration, or any prose where you catch yourself about to say "Wait" or "Actually" mid-thought.
---

# never-say-actually

No verbal stutters. The reader does not need a play-by-play of your internal corrections.

## Covers ALL output

This applies to every form of output, including:
- **Response text** to the user
- **Thinking blocks** (internal reasoning, chain-of-thought, scratchpads)
- Tool call reasoning
- Any commentary or narration

If you wouldn't say "Actually" in final output, do not say it in thinking either. Thinking is not a private diary — it is visible in opencode chat.

## Forbidden

Never write these words as standalone interjections or self-corrections:

- actually / actually,
- wait / wait, / wait.
- hmm / hmm,
- let me think / let me see / let me check
- ok so / okay so / so,
- on second thought
- but wait
- I think (as a hedge)
- let me re-examine / let me reconsider

Silence includes thinking. No exceptions.

## Rule

If you would say "Actually," or "Wait," delete the word and continue the thought. The next sentence is the thought itself. Corrections land clean, not announced.

## Bad

> Wait, the file might be at `~/.config/foo`. Actually, let me check. Hmm, on second thought, it could also be at `~/.foo`. Let me see...

## Good

> The file is at `~/.config/foo`.

## Bad

> I should call the API. Actually, I need to check the docs first. Wait, the docs say... Actually, it's just `GET /api/x`.

## Good

> The docs say `GET /api/x`. Calling that.

## Bad

> Actually wait, the output starts with `---`. That means... Actually no, the `---` is from the first echo. Let me reconsider...

## Good

> The leading `---` is from the first `echo` command, which printed before `ls` ran.
