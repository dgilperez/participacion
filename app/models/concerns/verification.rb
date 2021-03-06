module Verification
  extend ActiveSupport::Concern

  included do
    scope :level_three_verified, -> { where.not(verified_at: nil) }
    scope :level_two_verified, -> { where("users.confirmed_phone IS NOT NULL AND users.residence_verified_at IS NOT NULL") }
    scope :level_two_or_three_verified, -> { where("users.verified_at IS NOT NULL OR (users.confirmed_phone IS NOT NULL AND users.residence_verified_at IS NOT NULL)") }
    scope :unverified, -> { where("users.verified_at IS NULL AND (users.confirmed_phone IS NULL OR users.residence_verified_at IS NOT NULL)") }
  end

  def verification_email_sent?
    email_verification_token.present?
  end

  def verification_sms_sent?
    unconfirmed_phone.present? && sms_confirmation_code.present?
  end

  def verification_letter_sent?
    letter_requested_at.present? && letter_verification_code.present?
  end

  def residence_verified?
    residence_verified_at.present?
  end

  def sms_verified?
    confirmed_phone.present?
  end

  def level_two_verified?
    residence_verified? && sms_verified?
  end

  def level_three_verified?
    verified_at.present?
  end

  def level_two_or_three_verified?
    level_two_verified? || level_three_verified?
  end

  def unverified?
    !level_two_or_three_verified?
  end

end
