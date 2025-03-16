# frozen_string_literal: true

module Attachable
  extend ActiveSupport::Concern

  included do
    validates :attachments, content_type: ['image/png', 'image/jpeg', 'image/gif', 'application/pdf', 'application/msword'],
                            size: { less_than: 5.megabytes }
  end
end
