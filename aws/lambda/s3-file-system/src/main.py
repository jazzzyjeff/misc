import os

MOUNT = os.environ["MOUNT_PATH"]

def lambda_handler(event, context):
    action = event.get("action", "list")

    if action == "list":
        files = os.listdir(MOUNT)
        return {"action": "list", "files": files}

    elif action == "write":
        path = os.path.join(MOUNT, "hello.txt")
        with open(path, "w") as f:
            f.write("Hello from S3 Files!\n")
        return {"action": "write", "path": path}

    elif action == "read":
        path = os.path.join(MOUNT, "hello.txt")
        with open(path) as f:
            content = f.read()
        return {"action": "read", "content": content}

    elif action == "rename":
        src  = os.path.join(MOUNT, "hello.txt")
        dest = os.path.join(MOUNT, "renamed.txt")
        os.rename(src, dest)
        return {"action": "rename", "from": src, "to": dest}

    elif action == "stat":
        path = os.path.join(MOUNT, "renamed.txt")
        s = os.stat(path)
        return {"action": "stat", "size": s.st_size, "mtime": s.st_mtime}

    else:
        return {"error": f"unknown action: {action}"}