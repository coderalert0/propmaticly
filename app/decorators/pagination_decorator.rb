# frozen_string_literal: true

class PaginationDecorator < Draper::CollectionDecorator
  delegate :current_page, :total_pages, :limit_value, :total_count, :num_pages, :next_page, :prev_page
end
