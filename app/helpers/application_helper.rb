# frozen_string_literal: true

module ApplicationHelper

  require 'uri'
  require "redcarpet"
  require "coderay"

  class HTMLwithCoderay < Redcarpet::Render::HTML
      def block_code(code, language)
          language = language.split(':')[0]

          case language.to_s
          when 'rb'
              lang = 'ruby'
          when 'yml'
              lang = 'yaml'
          when 'css'
              lang = 'css'
          when 'html'
              lang = 'html'
          when ''
              lang = 'md'
          else
              lang = language
          end

          CodeRay.scan(code, lang).div
      end
  end

  def markdown(text)
      html_render = HTMLwithCoderay.new(filter_html: true, hard_wrap: true)
      options = {
          autolink: true,
          space_after_headers: true,
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          tables: true,
          hard_wrap: true,
          xhtml: true,
          lax_html_blocks: true,
          strikethrough: true
      }
      markdown = Redcarpet::Markdown.new(html_render, options)
      markdown.render(text).html_safe
  end

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
