#!/bin/bash
# test-notifications.sh

# Teste Telegram
echo "📱 Testando Telegram..."
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d "chat_id=${TELEGRAM_CHAT_ID}" \
  -d "text=✅ Pipeline de teste executado com sucesso! $(date)"

# Teste Mailgun
echo "📧 Testando Mailgun..."
curl -s -X POST "https://api.mailgun.net/v3/${MAILGUN_DOMAIN}/messages" \
  -u "api:${MAILGUN_API_KEY}" \
  -F from="${MAILGUN_FROM_EMAIL}" \
  -F to="${REPORT_RECIPIENT_EMAIL}" \
  -F subject="Teste de notificação - Pipeline" \
  -F html="<h1>Teste bem sucedido!</h1><p>Pipeline configurado corretamente às $(date)</p>"