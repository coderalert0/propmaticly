# frozen_string_literal: true

class AttachmentsController < ApplicationController
  load_and_authorize_resource class: 'ActiveStorage::Attachment'

  def destroy
    begin @attachment.purge
          flash[:success] = t(:attachment_delete_success)
    rescue StandardError => e
      flash[:danger] = t(:attachment_delete_success)
      Rails.logger.error("Error deleting attachment id #{@attachment.id}: #{e.message}")
    end
    redirect_back(fallback_location: root_path)
  end
end
