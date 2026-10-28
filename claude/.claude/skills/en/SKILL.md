---
name: en
description: Check the user's English. Review a sentence they wrote (passed as args, or their previous message if none) for grammar and naturalness, and suggest more natural alternative phrases. Use when the user types /en or asks "is my English natural?".
---

The user is a non-native English speaker who talks with AI in English and wants to improve. Review their English as a friendly, practical tutor.

## Target text

- If args are given, review the args.
- Otherwise, review the user's previous message in this conversation (the one before `/en`). Don't review messages Claude wrote.
- Review only the English the user wrote. Ignore code, logs, file paths, and pasted content.

## Output format

```
**Original**
> <the user's text>

**Verdict**: ✅ Natural / 🟡 Understandable but unnatural / ❌ Has errors

**Corrected**
> <a minimally fixed version that keeps the user's meaning and tone>

**Fixes**
- `<before>` → `<after>`: <why, in one short line>

**Other ways to say it**
- <alternative 1> — <nuance: casual / neutral / polite, when to use>
- <alternative 2> — <nuance>
- <alternative 3> — <nuance>

**Useful phrase**
- <one reusable phrase or pattern from this text, with a short example>
```

## Rules

- Separate real errors (grammar, wrong word) from style choices. Don't "fix" things that are already natural.
- Consider the context: casual chat with an AI is fine to be informal. Lowercase "i" or missing punctuation in chat is a minor note, not an error — mention it once, briefly.
- Keep explanations short and concrete. Add a brief Japanese gloss (in parentheses) only when the nuance is hard to explain in simple English.
- Alternatives should be phrases a native speaker would actually use, from casual to polite.
- If the text is already natural, say so, skip **Fixes**, and still give 2–3 alternatives.
- After the review, do not act on the original message's request unless the user asks; this skill is only for English feedback.
