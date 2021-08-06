# frozen_string_literal: true

module ApplicationHelper
  require 'uri'

  def show_contents_with_uri(contents)
    texts = safe_join(contents.split("\n"), tag(:br))
    texts.gsub(URI.regexp(%w[http https])) do |text|
      "<object><a href='#{text}' target='_blank' rel='noopener noreferrer'>#{text}</a></object>"
    end
  end

  def show_contents_with_link_preview(post)
    texts = safe_join(post.content.split("\n"), tag(:br))
    texts.gsub(URI.regexp(%w[http https])) do |text|
      "<object><a id='url' href='#{text}' target='_blank' rel='noopener noreferrer'>#{text}</a></object>"
    end
  end

  def date_format(datetime)
    time_ago_in_words(datetime) + '前'
  end
end
