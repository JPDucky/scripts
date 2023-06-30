import os

def detect_compositor():
    if "WAYLAND_DISPLAY" in os.environ:
        return "Wayland"
    elif "DISPLAY" in os.environ:
        return "X11"
    else:
        return "Unknown"

compositor = detect_compositor()
print(f"Running under {compositor} compositor")