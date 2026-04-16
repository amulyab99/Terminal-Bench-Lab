import os, stat, subprocess
from pathlib import Path

def test_private_key_exists():
    assert Path("/app/deploy_key").exists()

def test_public_key_exists():
    assert Path("/app/deploy_key.pub").exists()

def test_private_key_permissions():
    mode = oct(stat.S_IMODE(os.stat("/app/deploy_key").st_mode))
    assert mode == "0o600", f"Expected 0o600, got {mode}"

def test_public_key_permissions():
    mode = oct(stat.S_IMODE(os.stat("/app/deploy_key.pub").st_mode))
    assert mode == "0o644", f"Expected 0o644, got {mode}"

def test_authorized_keys_exists():
    assert Path("/app/.ssh/authorized_keys").exists()

def test_authorized_keys_contains_pubkey():
    pub = Path("/app/deploy_key.pub").read_text().strip()
    auth = Path("/app/.ssh/authorized_keys").read_text().strip()
    assert pub in auth

def test_authorized_keys_permissions():
    mode = oct(stat.S_IMODE(os.stat("/app/.ssh/authorized_keys").st_mode))
    assert mode == "0o600", f"Expected 0o600, got {mode}"

def test_key_is_valid_rsa_4096():
    result = subprocess.run(["ssh-keygen", "-l", "-f", "/app/deploy_key.pub"], capture_output=True, text=True)
    assert result.returncode == 0
    assert "4096" in result.stdout
    assert "RSA" in result.stdout

def test_fingerprint_file_exists():
    assert Path("/app/key_fingerprint.txt").exists()
