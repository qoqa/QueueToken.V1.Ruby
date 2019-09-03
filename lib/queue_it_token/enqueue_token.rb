require 'digest'
require 'securerandom'

class EnqueueToken
  attr_reader :customer_id, :event_id, :ip_address, :ip_forwared_for, :validity, :payload, :token_identifier,
              :issued_at, :expire_at

  def initialize(customer_id:, event_id: nil, ip_address: nil, ip_forwared_for: nil, validity: nil, payload: nil,
                 token_identifier_prefix: nil)
    @customer_id = customer_id
    @event_id = event_id
    @ip_address = ip_address
    @validity = validity
    @payload = payload || EnqueueTokenPayload.new
    @token_identifier = [token_identifier_prefix, SecureRandom.uuid].compact.join('~')
    @issued_at = (Time.now.to_f * 1000).to_i
    @expire_at = @issued_at + validity unless validity.nil?
  end

  def token(secret_key)
    "#{token_serialized(secret_key)}.#{hash(secret_key)}"
  end

  private

  def token_serialized(secret_key)
    "#{header_serialized}.#{@payload.encrypted_and_encoded(secret_key, @token_identifier)}"
  end

  def header_serialized
    headers = {
      typ: 'QT1',
      enc: 'AES256',
      iss: @issued_at,
      ti: @token_identifier,
      c: @customer_id
    }
    headers[:exp] = @expire_at unless @expire_at.nil?
    headers[:e] = @event_id unless @event_id.nil?
    headers[:ip] = @ip_address unless @ip_address.nil?
    headers[:xff] = @ip_forwared_for unless @ip_forwared_for.nil?

    urlsafe_encode64(headers.to_json)
  end

  def hash(secret_key)
    urlsafe_encode64(Digest::SHA256.digest("#{token_serialized(secret_key)}#{secret_key}"))
  end
end