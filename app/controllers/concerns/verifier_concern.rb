module VerifierConcern
  extend ActiveSupport::Concern

  def verifier
    @verify ||= ActiveSupport::MessageVerifier.new(ENV['secret_key_base'], url_safe: true)
  end
end
