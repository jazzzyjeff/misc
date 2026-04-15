# Simple mcp app

## Overview

This project is a simple demonstration of the Model Context Protocol (MCP) using Python.
It shows how an AI assistant like Claude can interact with locally defined tools to perform tasks.

The project includes:
- A basic MCP server
- Example tools (e.g. adding numbers)
- Two implementations:
  - **FastMCP** (high-level, minimal setup)
  - **Low-level MCP** (manual tool + schema control)


## How It Works
1. The MCP server exposes tools (functions) to an AI client
2. The AI interprets user input (e.g. "add 2 and 3")
3. The AI selects the appropriate tool
4. The tool is executed and returns a result
5. The AI responds with the output


## Usage
### 1. Install dependencies
Using uv:
```
uv sync
```

or install manually:
```
pip install fastmcp
```

### 2. Run with Claude Desktop
This project is designed to be run via Claude using MCP.

Add the server to your MCP config:
```json
{
  "mcpServers": {
    "demo-server": {
      "command": "uv",
      "args": [
        "run",
        "--project",
        "/path/to/mcp-demo",
        "python",
        "fastmcp_app.py"
      ]
    }
  }
}
```

Restart Claude after updating the config.

### 3. Example prompts

Once connected, try asking:
- "What is 2 + 3?"
- "Add 10 and 25"
- "Can you sum 8 and 12?"

The AI will call the `add_numbers` tool to compute the result.
