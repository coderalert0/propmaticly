# frozen_string_literal: true

module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def file_icon_class(file)
    case File.extname(file.filename.to_s).downcase
    when '.pdf'
      'bi bi-file-earmark-pdf'
    when '.jpg', '.jpeg', '.png', '.gif'
      'bi bi-file-earmark-image'
    when '.doc', '.docx'
      'bi bi-file-earmark-word'
    when '.xls', '.xlsx'
      'bi bi-file-earmark-excel'
    else
      'bi bi-file-earmark'
    end
  end
end
