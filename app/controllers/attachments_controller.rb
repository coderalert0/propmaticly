# frozen_string_literal: true

class AttachmentsController < ApplicationController
  load_and_authorize_resource class: 'ActiveStorage::Attachment'

  def destroy
    flash[:success] = t(:attachment_delete_success) if @attachment.purge
    redirect_back(fallback_location: root_path)
  end
end
