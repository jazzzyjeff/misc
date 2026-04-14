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


@mcp.tool
def search_in_file(path: str, keyword: str) -> list:
    """Search for a keyword in a file and return matching lines."""
    results = []
    with open(path, "r") as f:
        for line in f:
            if keyword.lower() in line.lower():
                results.append(line.strip())
    return results


if __name__ == "__main__":
    mcp.run()
