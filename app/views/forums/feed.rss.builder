xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@forum.name} - #{@domain.title}"
    xml.description @forum.content
    xml.pubdDate @forum.created_at.to_s(:rfc822)
    xml.lastBuildDate @forum.updated_at.to_s(:rfc822)
    xml.link forum_url(@forum)

    @topics.each do |topic|
      xml.item do
        xml.title "#{topic.name} #{t('common.by')} #{topic.user.try(&:name) || 'Anonymous'}"
        xml.description topic.preview
        xml.link topic_url(topic)
        xml.pubDate topic.updated_at.to_s(:rfc822)
      end
    end
  end
end
