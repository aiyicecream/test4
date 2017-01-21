xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@topic.name} - #{@domain.title}"
    xml.description t('common.description')
    xml.pubdDate @topic.created_at.to_s(:rfc822)
    xml.lastBuildDate @topic.updated_at.to_s(:rfc822)
    xml.image @topic.user.avatar.exists? ? "#{root_url.chop}#{@topic.user.avatar}" : @topic.user.gravatar_url(d: 'retro')
    xml.link topic_url(@topic)

    @messages.each do |message|
      xml.item do
        xml.title message.user.name
        xml.link topic_url(@topic, goto: message.id)
        xml.description truncate(message.content, length: 100, separator: ' ', omission: '...')
        xml.pubDate message.created_at.to_s(:rfc822)
      end
    end
  end
end
