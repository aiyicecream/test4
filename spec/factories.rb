FactoryGirl.define do
  factory :user do
    name { Faker::Name.name[0..24] }
    email { Faker::Internet.email }
    password 'password'
    human true

    factory :admin do
      sysadmin true
    end
  end

  factory :access_control do
    user_type 'All'
    user_id 0
  end

  factory :forum do
    name { Faker::Lorem.sentence(2)[0..24] }
    after :create do |forum, evaluator|
      FactoryGirl.create_list(:access_control, 1, object_type: 'Forum', object_id: forum.id, access: 'view')
      FactoryGirl.create_list(:access_control, 1, object_type: 'Forum', object_id: forum.id, access: 'read')
      FactoryGirl.create_list(:access_control, 1, object_type: 'Forum', object_id: forum.id, access: 'write')
    end
  end

  factory :topic do
    user
    forum
    name { Faker::Lorem.sentence(2)[0..24] }
    after :create do |topic, evaluator|
      FactoryGirl.create_list(:message, 1, topic: topic, user: evaluator.user)
      FactoryGirl.create_list(:access_control, 1, object_type: 'Topic', object_id: topic.id, access: 'view')
      FactoryGirl.create_list(:access_control, 1, object_type: 'Topic', object_id: topic.id, access: 'read')
      FactoryGirl.create_list(:access_control, 1, object_type: 'Topic', object_id: topic.id, access: 'write')
    end
  end

  factory :message, aliases: [:first_message, :last_message] do
    user
    topic
    content { Faker::Lorem.paragraph }
  end

  factory :small_message do
    user
    message
    content { Faker::Lorem.sentence(2) }
  end

  factory :group do
    user
    name { Faker::Lorem.sentence(2)[0..24] }
    status 'private'
    user_ids ''

    factory :public_group do
      status 'public'
    end
  end
end
