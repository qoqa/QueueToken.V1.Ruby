require 'minitest/autorun'
require 'queue_it_token'

class EnqueueTokenTest < Minitest::Test
  def test_minimum_header
    expected_signed_token = 'eyJ0eXAiOiJRVDEiLCJlbmMiOiJBRVMyNTYiLCJpc3MiOjE1MzQ3MjMyMDAwMDAsInRpIjoiYTIxZDQyM2EtNDNm' \
                            'ZC00ODIxLTg0ZmEtNDM5MGY2YTJmZDNlIiwiYyI6InRpY2tldGFuaWEifQ..ChCRF4bTbt4zlOcvXLjQYouhgqgi' \
                            'NNNZqcci8VWoZIU'

    enqueue_token = EnqueueToken.new(
      customer_id: 'ticketania',
      token_identifier: 'a21d423a-43fd-4821-84fa-4390f6a2fd3e',
      issued: 1_534_723_200_000
    )

    token = enqueue_token.token('5ebbf794-1665-4d48-80d6-21ac34be7faedf9e10b3-551a-4682-bb77-fee59d6355d6')
    assert_equal expected_signed_token, token
  end
end
