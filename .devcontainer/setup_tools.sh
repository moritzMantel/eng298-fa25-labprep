#!/usr/bin/env bash
set -euo pipefail

echo "[*] Updating base image..."
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
  curl wget unzip ca-certificates gnupg lsb-release python3-pip jq git

# Optional: clear apt cache to reduce container size
sudo rm -rf /var/lib/apt/lists/*

echo "[*] Installing Syft (SBOM generator)..."
if ! command -v syft >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sudo sh -s -- -b /usr/local/bin
fi
syft version || echo "[!] Syft installation check skipped (offline mode)"

echo "[*] Installing Grype (vulnerability scanner for SBOMs)..."
if ! command -v grype >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo sh -s -- -b /usr/local/bin
fi
grype version || echo "[!] Grype installation check skipped (offline mode)"

echo "[*] Installing Trivy (scanner + CycloneDX SBOM generator)..."
if ! command -v trivy >/dev/null 2>&1; then
  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
fi
trivy --version || echo "[!] Trivy installation check skipped (offline mode)"

echo "[*] Installing cve-bin-tool (binary CVE scanner)..."
python3 -m pip install --upgrade pip
python3 -m pip install --no-cache-dir cve-bin-tool
cve-bin-tool --version || echo "[!] CVE-Bin-Tool installation check skipped (offline mode)"

echo "[*] Setup complete."
