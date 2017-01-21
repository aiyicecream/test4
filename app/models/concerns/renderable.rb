module Renderable
  extend ActiveSupport::Concern
  include AutoHtml

  included do
    before_save :render_content, if: Proc.new{|model| model.content.present?}
  end

  private

  def render_content
    self.rendered_content = render_tags(self.content)
    self.rendered_content = render_markdown(self.rendered_content)
    self.rendered_content = render_media(self.rendered_content)
  end

  def render_tags content
    @user_ids = Array.new
    content.gsub(/(^|\s)@([[:alnum:]_-]+)/u) { |tag|
      if user = User.where(name: $2).first
        @user_ids << user.id
        "#{$1}[@#{$2}](#{Rails.application.routes.url_helpers.user_path(user)})"
      else
        tag
      end
    }.gsub(/(^|\s)#([[:alnum:]_-]+)/u) { |tag|
      "#{$1}[##{$2}](#{Rails.application.routes.url_helpers.messages_path(q: $2)})"
    }
  end

  def render_markdown content
    require 'redcarpet'

    renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      no_images: true,
      safe_links_only: true,
      with_toc_data: true
    )

    extensions = {
      autolink: false,
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      space_after_headers: true,
      strikethrough: true,
      superscript: true,
      tables: true
    }

    Redcarpet::Markdown.new(renderer, extensions).render(content)
  end

  def render_media content
    auto_html(content) {
      image
      youtube
      dailymotion
      flickr
      gist
      google_map
      google_video
      soundcloud
      twitter
      vimeo
      link rel: 'nofollow', target: '_blank'
    }
  end
end
