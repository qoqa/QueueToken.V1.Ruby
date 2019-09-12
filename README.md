# Queue-it Queue Token SDK gem for Ruby
The Queue-it Queue Token SDK is used to ensure that end users cannot enter the queue without a valid token and to be a container which can carry sensitive user information from integrating system into the queue.
## The Token
The token consists of two parts. Firstly, a header containing non-sensitive metadata. Secondly the payload of the token. Both header and payload are in JSON format.

### Token Header
```
{
  "issued_at": 1526464517,
  "expire_at": 1526524517,
  "token_identifier": "159aba3e-55e1-4f54-b6ee-e5b943d7e885",
  "customer_id": "ticketania",
  "event_id": "demoevent",
  "ip_address": "75.86.129.4",
  "ip_forwared_for": "45.67.2.4,34.56.3.2"
}
```
- `issued_at`: NumericDate of when token was issued. Required.
- `expire_at`: NumericDate of when token expires. Optional.
- `token_identifier`: Unique Token ID (e.g. uuid). Used to uniquely identify tokens and restrict replay attacks. Required.
- `customer_id`: The Customer ID of the issuer. Token will only be valid on events on this account. Required.
- `event_id`: The Event ID. If provided, token will only be valid on this event. Optional.
- `ip_address`: The IP address the user the token is issued to. If provided, the IP address is validated before issuing the token. Optional.
- `ip_forwared_for`: The X-Forwarded-For headerof the request when the token is issued. If provided, the X-Forwarded-For header is validated before issuing the token. Optional.

### Token Payload
```
{
  "relative_quality": 0.4578,
  "key": "XKDI42W",
  "custom_data": { "size": "medium" }
}
```
- `relative_quality`: The relative quality of the key. Must be a decimal value. Used for determining the quality of the token. Optional
- `key`: A unique key that holds value to the integrating system (e.g. email or user id). Used to restrict users from issuing multiple queue ids. Optional.
- `custom_data`: Any custom data of the user. This is a set of key-value pairs. Optional

## Usage
```Ruby
secret_key = '5ebbf794-1665-4d48-80d6-21ac34be7faedf9e10b3-551a-4682-bb77-fee59d6355d6'
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
  options: {
    token_identifier: 'a21d423a-43fd-4821-84fa-4390f6a2fd3e',
    event_id: 'myevent',
    issued_at: 1_534_723_200_000,
    expire_at: 1_539_129_600_000,
    payload: payload
  }
)

token = enqueue_token.token(secret_key)
```

### Specifying token identifier prefix
A prefix for the token identifier can optionally be provided to restrict the user session after getting through the queue to the one used before entering the queue. Once the user is through the queue the token identifier is provided to the target application in the Known User token. The format of the token identifier is then `[YOUR PREFIX]~[GUID]`, e.g: `AnfTDnpwazllYmnmgaCJ8tErV80YHv77ni5NgqQNhfWwxNqrNcHb~e937ef0d-48ec-4ff7-866e-52033273cb3d`.
```Ruby
token_identifier_prefix = "AnfTDnpwazllYmnmgaCJ8tErV80YHv77ni5NgqQNhfWwxNqrNcHb"
token = QueueItToken::EnqueueToken.new(
  customer_id: 'ticketania',
  options: {
    token_identifier_prefix: token_identifier_prefix
   }
)

# token_identifier example: AnfTDnpwazllYmnmgaCJ8tErV80YHv77ni5NgqQNhfWwxNqrNcHb~e937ef0d-48ec-4ff7-866e-52033273cb3d
```

## Serialized Token
> eyJ0eXAiOiJRVDEiLCJlbmMiOiJBRVMyNTYiLCJpc3MiOjE1MzQ3MjMyMDAwMDAsImV4cCI6MTUzOTEyOTYwMDAwMCwidGkiOiJhMjFkNDIzYS00M2ZkLTQ4MjEtODRmYS00MzkwZjZhMmZkM2UiLCJjIjoidGlja2V0YW5pYSIsImUiOiJteWV2ZW50In0.0rDlI69F1Dx4Twps5qD4cQrbXbCRiezBd6fH1PVm6CnVY456FALkAhN3rgVrh_PGCJHcEXN5zoqFg65MH8WZc_CQdD63hJre3Sedu0-9zIs.aZgzkJm57etFaXjjME_-9LjOgPNTTqkp1aJ057HuEiU

The format of the token is `[header].[payload].[hash]` where each part is in Base64 (url encoded). The payload is AES 256 encrypted with the secret key supplied in the `.token(secret_key)` method. If the "e" key is provided in the header, the secret key on the event must be used. If no "e" key is provided the default key on the customer account must be used.
The token is signed with SHA 256 using the same secret key.

## Contributing
Run tests with `rake test` command.
