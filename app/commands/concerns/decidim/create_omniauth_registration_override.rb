# frozen_string_literal: true

module Decidim
  # Normalizes the email verified by the identity provider before it is used to
  # look up the user.
  #
  # `CreateOmniauthRegistration#create_or_find_user` matches the existing user
  # with `User.find_or_initialize_by(email: verified_email)`, an exact SQL
  # comparison, while Devise stores emails downcased. When the SAML `mail`
  # attribute arrives with uppercase letters (or trailing whitespace) the lookup
  # misses, the command tries to create a duplicate user and the case-insensitive
  # uniqueness validation rejects it, so the person is locked out with "Another
  # account is using the same email address" and never gets an identity linked.
  #
  # This module is prepended so `initialize` can normalize the value before the
  # original implementation stores it.
  module CreateOmniauthRegistrationOverride
    def initialize(form, verified_email = nil)
      super(form, verified_email&.strip&.downcase)
    end
  end
end
