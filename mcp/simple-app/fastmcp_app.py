from fastmcp import FastMCP

mcp = FastMCP("fastmcp-demo")

@mcp.tool
def add_numbers(a: int, b: int) -> int:
    """Adds two numbers together."""
    return a + b

@mcp.tool
def read_file(path: str) -> str:
    """Read a file from disk and return its content"""
    
    with open(path, "r") as f:
        return f.read()

if __name__ == "__main__":
    mcp.run()