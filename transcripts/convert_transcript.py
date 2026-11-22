"""Convert a Claude Cowork session .jsonl into a readable, scrubbed Markdown transcript.

Usage: python3 convert_transcript.py input.jsonl output.md "Title"
Keeps: user messages, assistant text, tool calls and tool results (long ones truncated).
Drops: app bookkeeping records, empty thinking blocks, <system-reminder> blocks.
Scrubs: local file paths, sandbox paths, and the user's email address.
"""
import json
import re
import sys

MAX = 2500  # max characters shown per tool call / result

SCRUB = [
    (re.compile(r"<system-reminder>.*?</system-reminder>", re.S), "[system reminder removed]"),
    (re.compile(r"[\w.+-]+@stanford\.edu"), "<email removed>"),
    (re.compile(re.escape("/Users/oliviapricilia/Desktop/Stanford PhD Media Psych 2026/"
                          "Stanford courses 2026/Autumn 2026/PSYCH 251 Experimental Method")), "<local path>"),
    (re.compile(re.escape("/Users/oliviapricilia/Library/Application Support/Claude") + r"[^\s\"'`)\]]*"),
     "<app folder>"),
    (re.compile(r"/Users/oliviapricilia[^\s\"'`)\]]*(?: [^\s\"'`)\]/]+)*"), "<local path>"),
    (re.compile(r"/sessions/[\w-]+"), "<sandbox>"),
    (re.compile(r"/private/(?:tmp|var)/[^\s\"'`)\]]+"), "<tmp path>"),
    (re.compile(r"/var/folders/[^\s\"'`)\]]+"), "<tmp path>"),
    (re.compile(r'~/Desktop/"Stanford PhD Media Psych 2026/Stanford courses 2026/Autumn 2026/'
                r'PSYCH 251 Experimental Method/'), '<local path>/"'),
    (re.compile(r"oliviapricilia"), "<user>"),
    (re.compile(r"pricilia@"), "<email removed>"),
]


def scrub(s: str) -> str:
    for pat, rep in SCRUB:
        s = pat.sub(rep, s)
    return s


def trunc(s: str) -> str:
    return s if len(s) <= MAX else s[:MAX] + f"\n… [truncated {len(s) - MAX} characters]"


def result_text(content) -> str:
    if isinstance(content, str):
        return content
    out = []
    for c in content or []:
        if c.get("type") == "text":
            out.append(c.get("text", ""))
        elif c.get("type") == "image":
            out.append("[image]")
    return "\n".join(out)


def fence(s: str) -> str:
    return "~~~~\n" + s.replace("~~~~", "~ ~ ~ ~") + "\n~~~~"


def main(inp, outp, title):
    lines = [f"# {title}", "",
             "Converted from the Claude Cowork session export (.jsonl) with `convert_transcript.py`. "
             "Local paths, sandbox paths, the user's email and automatic system reminders are removed; "
             f"tool calls/results longer than {MAX} characters are truncated. Empty model 'thinking' "
             "blocks and app bookkeeping records are omitted.", ""]
    seen = set()
    for raw in open(inp, encoding="utf-8"):
        r = json.loads(raw)
        if r.get("type") not in ("user", "assistant"):
            continue
        uid = r.get("uuid")
        if uid in seen:
            continue
        seen.add(uid)
        ts = (r.get("timestamp") or "")[:19].replace("T", " ")
        msg = r.get("message") or {}
        content = msg.get("content")
        if r["type"] == "user":
            if isinstance(content, str):
                txt = scrub(content).strip()
                if txt:
                    lines += [f"## Olivia ({ts} UTC)", "", txt, ""]
                continue
            for b in content or []:
                t = b.get("type")
                if t == "text":
                    txt = scrub(b.get("text", "")).strip()
                    if txt and txt != "[system reminder removed]":
                        lines += [f"## Olivia ({ts} UTC)", "", txt, ""]
                elif t == "image":
                    lines += [f"## Olivia ({ts} UTC)", "", "[screenshot attached]", ""]
                elif t == "tool_result":
                    txt = trunc(scrub(result_text(b.get("content"))).strip())
                    lines += ["<details><summary>Tool result</summary>", "", fence(txt), "", "</details>", ""]
        else:
            for b in content or []:
                t = b.get("type")
                if t == "text" and b.get("text", "").strip():
                    lines += [f"## Claude ({ts} UTC)", "", scrub(b["text"]).strip(), ""]
                elif t == "thinking" and b.get("thinking", "").strip():
                    lines += ["<details><summary>Claude reasoning</summary>", "",
                              scrub(b["thinking"]).strip(), "", "</details>", ""]
                elif t == "tool_use":
                    inp_s = trunc(scrub(json.dumps(b.get("input", {}), indent=1, ensure_ascii=False)))
                    lines += [f"**Tool call: `{b.get('name')}`** ({ts} UTC)", "", fence(inp_s), ""]
    open(outp, "w", encoding="utf-8").write("\n".join(lines))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3])
