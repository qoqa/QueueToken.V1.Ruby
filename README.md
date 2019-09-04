# QueueToken.V1.Ruby

```Ruby
payload = QueueItToken::EnqueueTokenPayload.new(
  key: 'somekey',
  relative_quality: 0.45678663514,
  custom_data: {
    color: 'blue',
    size: 'medium'
  }
)
enqueue_token = QueueItToken::EnqueueToken.new(
  customer_id: 'ticketania',
  token_identifier: 'a21d423a-43fd-4821-84fa-4390f6a2fd3e',
  event_id: 'myevent',
  issued_at: 1_534_723_200_000,
  expire_at: 1_539_129_600_000,
  payload: payload
)

token = enqueue_token.token('5ebbf794-1665-4d48-80d6-21ac34be7faedf9e10b3-551a-4682-bb77-fee59d6355d6')
# => eyJ0eXAiOiJRVDEiLCJlbmMiOiJBRVMyNTYiLCJpc3MiOjE1MzQ3MjMyMDAwMDAsImV4cCI6MTUzOTEyOTYwMDAwMCwidGkiOiJhMjFkNDIzYS00M2ZkLTQ4MjEtODRmYS00MzkwZjZhMmZkM2UiLCJjIjoidGlja2V0YW5pYSIsImUiOiJteWV2ZW50In0.0rDlI69F1Dx4Twps5qD4cQrbXbCRiezBd6fH1PVm6CnVY456FALkAhN3rgVrh_PGCJHcEXN5zoqFg65MH8WZc_CQdD63hJre3Sedu0-9zIs.aZgzkJm57etFaXjjME_-9LjOgPNTTqkp1aJ057HuEiU
```