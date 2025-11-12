# Leaf

Leaf is a tiny Swift CLI that lets you save shell command aliases and run them on demand, or communicate with an LLM to generate commands.

## Installation

Download the executable for your platform from the [Releases](https://github.com/dvdbits/leaf/releases) page, then add it to your PATH.

## AI Configuration

The AI configuration structure:

```json
{
  "model": "string",
  "temperature": 0.0,
  "endpoint": "string",
  "apiKey": "string"
}
```

## HTTP Request Body

The HTTP call body structure sent to the LLM endpoint:

```json
{
  "model": "string",
  "options": {
    "temperature": 0.0
  },
  "stream": false,
  "prompt": "string"
}
```

## Caveats

Commands are run using `execvp`, so only one command can be run per alias.
