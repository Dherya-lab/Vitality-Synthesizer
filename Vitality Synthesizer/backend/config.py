"""
Application Configuration and Environment Loader for Vitality Synthesizer.
"""
import os
from pathlib import Path
from dotenv import load_dotenv

# Resolve root directory
ROOT_DIR = Path(__file__).resolve().parent.parent
ENV_PATH = ROOT_DIR / ".env"

# Load .env if present
if ENV_PATH.exists():
    load_dotenv(dotenv_path=ENV_PATH)
else:
    load_dotenv()

# ==============================================================================
# 🔑 GEMINI API KEY PLACEHOLDER & CONFIGURATION
# ==============================================================================
# You can paste your Gemini API key directly here or set it in the .env file.
# ==============================================================================
DEFAULT_API_KEY_PLACEHOLDER = "YOUR_GEMINI_API_KEY_HERE"

def get_gemini_api_key() -> str:
    """
    Returns the configured Gemini API key.
    Checks environment variable GEMINI_API_KEY first, then falls back to empty string.
    """
    api_key = os.getenv("GEMINI_API_KEY", "").strip()
    if not api_key or api_key == DEFAULT_API_KEY_PLACEHOLDER:
        return ""
    return api_key

def is_api_key_configured() -> bool:
    """Returns True if a non-placeholder Gemini API key is configured."""
    key = get_gemini_api_key()
    return bool(key and key != DEFAULT_API_KEY_PLACEHOLDER)

# AI Model Configuration
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")

# Timing parameters (Set to 35.0s default to prevent 429 rate limit errors)
TELEMETRY_INTERVAL_SECONDS = float(os.getenv("TELEMETRY_INTERVAL_SECONDS", "2.0"))
SYNTHESIS_INTERVAL_SECONDS = float(os.getenv("SYNTHESIS_INTERVAL_SECONDS", "35.0"))

TELEMETRY_INTERVAL_MS = int(TELEMETRY_INTERVAL_SECONDS * 1000)
SYNTHESIS_INTERVAL_MS = int(SYNTHESIS_INTERVAL_SECONDS * 1000)