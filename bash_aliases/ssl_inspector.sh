# Quick SSL/TLS checker for web + mail services.
# Usage:
#   sslcheck example.com
#   sslweb example.com
#   sslmail example.com

_ssl_one() {
    local host="$1"
    local port="$2"
    local mode="$3"
    local verify_host="${4:-$host}"
    local label="$5"
    local starttls_args=()
    local out rc cert subject issuer not_before not_after san tls_line verify_line peer_line days_left status expiry_note end_epoch now_epoch

    case "$mode" in
        smtp-starttls) starttls_args=(-starttls smtp -crlf) ;;
        imap-starttls) starttls_args=(-starttls imap -crlf) ;;
        pop3-starttls) starttls_args=(-starttls pop3 -crlf) ;;
        none|"")       starttls_args=() ;;
        *)
            echo "Unknown TLS mode: $mode"
            return 1
            ;;
    esac

    out="$(
        timeout 12 openssl s_client \
            -connect "${host}:${port}" \
            -servername "${verify_host}" \
            -verify_hostname "${verify_host}" \
            -verify_return_error \
            -showcerts \
            "${starttls_args[@]}" \
            < /dev/null 2>&1
    )"
    rc=$?

    cert="$(awk '
        /-----BEGIN CERTIFICATE-----/ {p=1}
        p {print}
        /-----END CERTIFICATE-----/ {exit}
    ' <<< "$out")"

    verify_line="$(grep -m1 -E 'Verify return code:' <<< "$out" | sed 's/^[[:space:]]*//')"
    peer_line="$(grep -m1 -E 'Verified peername:' <<< "$out" | sed 's/^[[:space:]]*//')"

    if [[ $rc -eq 0 ]] && grep -q 'Verify return code: 0 (ok)' <<< "$out"; then
        status="OK"
    else
        status="FAIL"
    fi

    echo
    echo "[$status] $label"
    echo "      Host: ${host}:${port}"
    echo "       SNI: ${verify_host}"

    if [[ -z "$cert" ]]; then
        echo "     Error: No certificate returned"
        echo "    Verify: ${verify_line:-No verify line found}"
        echo "     Notes:"
        echo "$out" | grep -Ei 'error|alert|verify|wrong version|handshake|connection refused|timeout' | head -8 | sed 's/^/            /'
        return 1
    fi

    subject="$(openssl x509 -noout -subject <<< "$cert" 2>/dev/null | sed 's/^subject=//')"
    issuer="$(openssl x509 -noout -issuer <<< "$cert" 2>/dev/null | sed 's/^issuer=//')"
    not_before="$(openssl x509 -noout -startdate <<< "$cert" 2>/dev/null | cut -d= -f2-)"
    not_after="$(openssl x509 -noout -enddate <<< "$cert" 2>/dev/null | cut -d= -f2-)"
    san="$(openssl x509 -noout -ext subjectAltName <<< "$cert" 2>/dev/null \
        | awk '/DNS:/ {gsub(/, /,"\n"); print}' \
        | sed -E 's/^[[:space:]]*DNS://; s/DNS://g' \
        | paste -sd ', ' -)"

    tls_line="$(grep -m1 -E '^New, TLS|^New, SSL' <<< "$out" | sed -E 's/^New, //')"
    [[ -z "$tls_line" ]] && tls_line="$(awk -F: '
        /Protocol  :/ {gsub(/^[ \t]+/, "", $2); proto=$2}
        /Cipher    :/ {gsub(/^[ \t]+/, "", $2); cipher=$2}
        END {
            if (proto || cipher) print proto ", Cipher is " cipher
        }
    ' <<< "$out")"

    expiry_note=""
    end_epoch="$(date -d "$not_after" +%s 2>/dev/null)"
    now_epoch="$(date +%s)"
    if [[ -n "$end_epoch" ]]; then
        days_left=$(( (end_epoch - now_epoch) / 86400 ))
        if (( days_left < 0 )); then
            expiry_note="EXPIRED"
        elif (( days_left <= 14 )); then
            expiry_note="expires soon, ${days_left} days left"
        else
            expiry_note="${days_left} days left"
        fi
    fi

    echo "       TLS: ${tls_line:-Unknown}"
    echo "   Subject: ${subject:-Unknown}"
    echo "    Issuer: ${issuer:-Unknown}"
    echo "     Valid: ${not_before:-Unknown} -> ${not_after:-Unknown} ${expiry_note:+($expiry_note)}"
    echo "      SANs: ${san:-No SAN extension found}"
    echo "    Verify: ${verify_line:-No verify line found}"
    [[ -n "$peer_line" ]] && echo "      Peer: $peer_line"
}

ssl_check() {
    local mode="${1:-all}"
    local domain="$2"
    local mailhost webhost wwghost

    if [[ -z "$domain" ]]; then
        echo "Usage:"
        echo "  sslcheck domain.tld"
        echo "  sslweb domain.tld"
        echo "  sslmail domain.tld"
        return 1
    fi

    mailhost="mail.${domain}"
    webhost="${domain}"
    wwghost="www.${domain}"

    case "$mode" in
        all)
            echo "SSL/TLS check for: $domain"
            _ssl_one "$webhost" 443 none "$webhost" "HTTPS direct"
            _ssl_one "$wwghost" 443 none "$wwghost" "HTTPS www"
            _ssl_one "$mailhost" 465 none "$mailhost" "SMTP SSL / SMTPS"
            _ssl_one "$mailhost" 587 smtp-starttls "$mailhost" "SMTP STARTTLS"
            _ssl_one "$mailhost" 993 none "$mailhost" "IMAP SSL"
            _ssl_one "$mailhost" 143 imap-starttls "$mailhost" "IMAP STARTTLS"
            ;;
        web)
            echo "Web SSL/TLS check for: $domain"
            _ssl_one "$webhost" 443 none "$webhost" "HTTPS direct"
            _ssl_one "$wwghost" 443 none "$wwghost" "HTTPS www"
            ;;
        mail)
            echo "Mail SSL/TLS check for: $domain"
            _ssl_one "$mailhost" 465 none "$mailhost" "SMTP SSL / SMTPS"
            _ssl_one "$mailhost" 587 smtp-starttls "$mailhost" "SMTP STARTTLS"
            _ssl_one "$mailhost" 993 none "$mailhost" "IMAP SSL"
            _ssl_one "$mailhost" 143 imap-starttls "$mailhost" "IMAP STARTTLS"
            ;;
        *)
            echo "Unknown mode: $mode"
            echo "Use: all, web, or mail"
            return 1
            ;;
    esac
}

alias sslcheck='ssl_check all'
alias sslweb='ssl_check web'
alias sslmail='ssl_check mail'
