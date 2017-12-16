# frozen_string_literal: true

module Moneybird
  module Middleware
    class ErrorHandling < Faraday::Response::Middleware
      ERROR_MAP = {
        400 => Moneybird::HttpError::BadRequest,
        401 => Moneybird::HttpError::AuthorizationRequired,
        402 => Moneybird::HttpError::PaymentRequired,
        403 => Moneybird::HttpError::Forbidden,
        404 => Moneybird::HttpError::NotFound,
        405 => Moneybird::HttpError::MethodNotAllowed,
        406 => Moneybird::HttpError::NotAccepted,
        422 => Moneybird::HttpError::UnprocessableEntity,
        429 => Moneybird::HttpError::TooManyRequests,
        500 => Moneybird::HttpError::InternalServerError
      }.freeze

      def on_complete(response)
        key = response[:status].to_i
        raise ERROR_MAP[key], response if ERROR_MAP.key? key
      end
    end
  end
end
