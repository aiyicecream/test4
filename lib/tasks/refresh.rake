namespace :refresh do
  desc "Refresh all counters"
  task :counters => :environment do
    puts "Orphan deletion..."

    n = Message.where("topic_id NOT IN (?)", Topic.all.map(&:id)).delete_all
    puts "#{n} messages without topic deleted"

    n = Message.where("forum_id NOT IN (?)", Forum.all.map(&:id)).delete_all
    puts "#{n} messages without forum deleted"

    n = Topic.where("forum_id NOT IN (?)", Forum.all.map(&:id)).delete_all
    puts "#{n} topics without forum deleted"

    puts "Topics messages_count..."
    Topic.update_all("messages_count=(Select count(*) from messages m where m.topic_id=topics.id)")

    puts "Forum topics_count and messages_count ans last_message_id..."
    Forum.all.each{|f|
      Forum.update_counters f.id, messages_count: Message.where(forum_id: f.children.map(&:id) << f.id).count - f.messages_count
      Forum.update_counters f.id, topics_count: Topic.where(forum_id: f.children.map(&:id) << f.id).count - f.topics_count
      f.update_column :last_message_id, f.all_messages.last.try(:id)
    }

    puts "Topic last_message_id"
    Topic.all.each{|t|
      t.update_column :last_message_id, t.messages.last.try(:id)
    }

    puts "Domain messages_count..."
    Domain.update_all("messages_count=(Select count(*) from messages m where m.domain_id=domains.id)")

    puts "Domain topics_count..."
    Domain.update_all("topics_count=(Select count(*) from topics t where t.domain_id=domains.id)")

    puts "Domain users_count..."
    Domain.update_all("users_count=(Select count(*) from users u where u.domain_id=domains.id)")

    puts "User messages_count..."
    User.update_all("messages_count=(Select count(*) from messages m where m.user_id=users.id)")

    puts "User topics_count..."
    User.update_all("topics_count=(Select count(*) from topics t where t.user_id=users.id)")

    puts "Done!"
  end
end
