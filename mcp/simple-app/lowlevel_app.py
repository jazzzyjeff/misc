import asyncio
from typing import Any

import mcp.server.stdio
from mcp.types import Tool

from mcp.server.lowlevel import NotificationOptions, Server
from mcp.server.models import InitializationOptions

server = Server("lowlevel-demo")

@server.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="add_numbers",
            description="Adds two numbers together.",
            inputSchema={
                "type": "object",
                "properties": {
                    "a": {"type": "integer", "description": "First number"},
                    "b": {"type": "integer", "description": "Second number"},
                },
                "required": ["a", "b"],
            },
        )
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict[str, Any]) -> Any:
    if name == "add_numbers":
        return {"result": arguments["a"] + arguments["b"]}
    raise ValueError(f"Unknown tool: {name}")

async def run():
    async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="lowlevel-demo",
                server_version="0.1.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={},
                ),
            ),
        )

if __name__ == "__main__":
    asyncio.run(run())