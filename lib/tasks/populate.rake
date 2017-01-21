namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    def rand_time(from, to=Time.now)
      Time.at(rand_in_range(from.to_f, to.to_f))
    end

    def rand_in_range(from, to)
      rand * (to - from) + from
    end

    # 0 =>  500 users,  10000 messages
    # 1 => 5000 users, 500000 messages
    force = 1
    users = 500 * (10 ** force)

    [Bookmark, Follow, Forum, Message, Notification, SmallMessage, Topic, User].each(&:delete_all)

    uid = 1
    User.populate (users) do |u|
      u.name = Faker::Name.name
      u.email = Faker::Internet.email
      u.location = Faker::Address.country
      u.website = Faker::Internet.url
      u.birthdate = rand_time(70.year.ago, 15.year.ago)
      u.gender = (['male']*20 +  ['female']*20 + ['other']*5 + [nil]*55).sample
      puts "User #{uid}"
      uid = uid + 1
    end

    fid = tid = mid = 1
    Forum.populate 5 do |f|
      f.name = Faker::Lorem.words(1 + rand(2)).join ' '
      f.topics_count = f.messages_count = 0
      f.updated_at = Time.now
      updater_id = nil
      parent_id = fid
      fid = fid + 1
      Forum.populate 2 + rand(5) do |c| # avg 4
        c.name = Faker::Lorem.words(1 + rand(2)).join ' '
        c.parent_id = parent_id
        c.updated_at = Time.now
        c.topics_count = 1 + rand(10 ** (1 + rand(2 + force))) # avg 28 - 185
        f.topics_count = f.topics_count + c.topics_count
        c.messages_count = 0
        updater_id = nil
        Topic.populate c.topics_count do |t|
          t.name = Faker::Lorem.sentence
          t.forum_id = fid
          t.messages_count = 1 + rand(10 ** rand(3 + force)) # avg 18 - 140
          c.messages_count = c.messages_count + t.messages_count
          f.messages_count = f.messages_count + t.messages_count
          t.first_message_id = t.user_id = updater_id = nil
          t.created_at = rand_time(1.year.ago)
          Message.populate t.messages_count do |m|
            if !t.first_message_id
              t.first_message_id = mid
              m.created_at = t.created_at
            else
              m.created_at = rand_time(t.created_at)
            end
            m.content = Faker::Lorem.sentences(1 + rand(3)).join ' '
            m.rendered_content = "<p>#{m.content}</p>"
            m.user_id = 1 + rand(users)
            t.user_id = m.user_id unless t.user_id
            updater_id = m.user_id
            m.topic_id = tid
            m.forum_id = fid
            mid = mid + 1
          end
          t.updated_at = rand_time(t.created_at)
          t.last_message_id = mid - 1
          t.updater_id = updater_id
          tid = tid + 1
          puts "#{fid}.#{tid}"
        end
        c.updater_id = updater_id
        fid = fid + 1
      end
      f.updater_id = updater_id
    end

    Forum.find_each(&:save)
    User.all.each{|o|
      User.update_counters o.id, messages_count: o.messages.count
      User.update_counters o.id, topics_count: o.topics.count
      o.save validate: false
    }
  end
end
