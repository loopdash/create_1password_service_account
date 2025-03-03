#!/bin/bash

# Define variables
SERVICE_ACCOUNT_NAME="Loopdash Bot"

# List of vault names (permissions will be set to "read_items,share_items" for all)
VAULTS=(
    "accountabletech.org"
    "aerate.me"
    "ai2030.encodeai.org"
    "akpopup.com"
    "anagocleaning.com"
    "analytics.loopdash.com"
    "andvariassociates.com"
    "antaeusaction.com"
    "bansurveillanceadvertising.com"
    "bbxlogisticsproperties.com"
    "beerfrontier.net"
    "bestclevelandcpa.com"
    "bindlepaper.com"
    "bluestandard.com"
    "buzzr.com"
    "cbo.ai"
    "cesnet.org"
    "clearfieldland.com"
    "clevelandquicksale.com"
    "clevelandsightcenter.org"
    "code3.com"
    "copublicstrategies.com"
    "courtneycoverscleveland.com"
    "crimlawny.com"
    "cryptodeclass.com"
    "deargoogle.org"
    "designitforus.org"
    "drummajorsforchange.org"
    "east86th.org"
    "eatfuku.com"
    "encodeai.org"
    "envalo.com"
    "facebookpapers.com"
    "forgehealth.com"
    "forwardmajority.org"
    "forwardtogetherwi.org"
    "genomoncology.com"
    "getpicnic.com"
    "ghiaiacashmere.com"
    "goldfishswimschool.com"
    "greatlakeseastllc.com"
    "gregholcomb.com"
    "hiphopcaucus.org"
    "homedoggy.com"
    "homehelpershomecare.com"
    "instilbio.com"
    "interviewpath.com"
    "jmireports.com"
    "justcourtsalliance.com"
    "keeptrumpofffacebook.com"
    "kyntronics.com"
    "labelmaker.nyc"
    "lentner.com"
    "liveeatsurf.com"
    "master-mfg.com"
    "merrittwoodwork.com"
    "momsfirst.us"
    "morelandconnect.com"
    "northwoodmachine.com"
    "novakinsurance.com"
    "oceanic.global"
    "onedevotion.com"
    "peakdryiceblasting.com"
    "perfectfithealthclub.com"
    "pod3strategies.com"
    "powerbacktopeople.us"
    "pradopadilla.com"
    "primalhealthwellness.com"
    "reininbigtech.org"
    "rooterman.com"
    "shi-shievents.com"
    "sixthcityglazing.com"
    "textbookpainting.com"
    "theclearbluecompany.com"
    "thedurkovicgroup.com"
    "thegreatlakesgroup.com"
    "thehdgroup.com"
    "timothydurkovic.com"
    "todaysbride.com"
    "unitedfordemocracy.us"
    "unworldoceansday.org"
    "vesey.vc"
    "voltacommsgroup.com"
    "whitehatwiki.com"
    "wirecloth.com"
)

# Default permissions for all vaults
PERMISSIONS="read_items,share_items"

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "[ERROR] jq is not installed. Install it and rerun the script."
    exit 1
fi

# Ensure there is at least one vault
if [ ${#VAULTS[@]} -eq 0 ]; then
    echo "[ERROR] No vaults provided. Please add vaults before running the script."
    exit 1
fi

# Construct vault permissions argument
VAULT_ARGS=()
for vault in "${VAULTS[@]}"; do
    VAULT_ARGS+=("--vault" "$vault:$PERMISSIONS")
done

# Create service account
echo "Creating service account: $SERVICE_ACCOUNT_NAME..."
SERVICE_ACCOUNT_JSON=$(op service-account create "$SERVICE_ACCOUNT_NAME" "${VAULT_ARGS[@]}" --format=json 2>&1)

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to create service account:"
    echo "$SERVICE_ACCOUNT_JSON"
    exit 1
fi

# Extract service account ID
SERVICE_ACCOUNT_ID=$(echo "$SERVICE_ACCOUNT_JSON" | jq -r '.id')
if [ -z "$SERVICE_ACCOUNT_ID" ]; then
    echo "[ERROR] Failed to retrieve service account ID."
    exit 1
fi

# Extract service account token
SERVICE_ACCOUNT_TOKEN=$(echo "$SERVICE_ACCOUNT_JSON" | jq -r '.token')
if [ -z "$SERVICE_ACCOUNT_TOKEN" ]; then
    echo "[ERROR] Failed to retrieve service account token."
    exit 1
fi

# Output service account details
echo "Service Account Created Successfully!"
echo "Service Account ID: $SERVICE_ACCOUNT_ID"
echo "Service Account Token: $SERVICE_ACCOUNT_TOKEN"

# Optional: Save token to a file (securely)
echo "$SERVICE_ACCOUNT_TOKEN" > service_account_token.txt
chmod 600 service_account_token.txt  # Restrict file access for security

echo "Token saved to service_account_token.txt (permissions set to 600)."
