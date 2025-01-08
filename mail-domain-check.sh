#!/bin/bash

# Domain kontrol scripti
# SMTP ayarları
SMTP_SERVER="smtp.office365.com"
SMTP_PORT=587
SMTP_USER="mail@address"
SMTP_PASS="PASS"
TO_EMAIL="mail@address"

# Kontrol edilecek domainler
DOMAINS=(
    "muratakpinar.com"
    "muratakpinar.com.tr"
)

# Geçici dosya
TMP_FILE="/tmp/domain_check_$$.txt"

# Domain durumu kontrol fonksiyonu
domain_check() {
    local DOMAIN="$1"
    if [[ "$DOMAIN" == *.com.tr ]]; then
        whois -h whois.nic.tr "$DOMAIN" > "$TMP_FILE" 2>/dev/null
    else
        whois "$DOMAIN" > "$TMP_FILE" 2>/dev/null
    fi

    if grep -q "No match for" "$TMP_FILE" || grep -q "NOT FOUND" "$TMP_FILE"; then
        echo "AVAILABLE"
    elif grep -q "Expires on" "$TMP_FILE"; then
        local EXPIRY_DATE=$(grep "Expires on" "$TMP_FILE" | head -n 1 | awk '{print $NF}')
        echo "TAKEN|$EXPIRY_DATE"
    elif grep -q "Expiry Date:" "$TMP_FILE"; then
        local EXPIRY_DATE=$(grep "Expiry Date:" "$TMP_FILE" | head -n 1 | awk '{print $NF}')
        echo "TAKEN|$EXPIRY_DATE"
    elif grep -q "Expiration Date:" "$TMP_FILE"; then
        local EXPIRY_DATE=$(grep "Expiration Date:" "$TMP_FILE" | head -n 1 | awk '{print $NF}')
        echo "TAKEN|$EXPIRY_DATE"
    else
        echo "UNKNOWN"
    fi
}

# E-posta gönderme fonksiyonu
send_email_summary() {
    local SUMMARY="$1"

    SUBJECT="Domain Status Summary"
    BODY="$SUMMARY"

    echo -e "Subject:$SUBJECT\n\n$BODY" | \
    curl -s --url "smtp://$SMTP_SERVER:$SMTP_PORT" \
        --ssl-reqd \
        --mail-from "$SMTP_USER" \
        --mail-rcpt "$TO_EMAIL" \
        --upload-file - \
        --user "$SMTP_USER:$SMTP_PASS"
}

# Ana kontrol döngüsü
while true; do
    SUMMARY=""
    for DOMAIN in "${DOMAINS[@]}"; do
        RESULT=$(domain_check "$DOMAIN")
        STATUS=$(echo "$RESULT" | cut -d '|' -f 1)
        EXPIRY_DATE=$(echo "$RESULT" | cut -d '|' -f 2)

        if [ "$STATUS" = "AVAILABLE" ]; then
            SUMMARY+="$DOMAIN : Available\n"
        elif [ "$STATUS" = "TAKEN" ]; then
            SUMMARY+="$DOMAIN : Taken, Expiry date: $EXPIRY_DATE\n"
        else
            SUMMARY+="$DOMAIN : Status Unknown\n"
        fi
    done

    send_email_summary "$SUMMARY"
    echo "[$(date)] Summary email sent."
    sleep 3600 # Her saat kontrol et
done

# Geçici dosyayı temizle
rm -f "$TMP_FILE"
