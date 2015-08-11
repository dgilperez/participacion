FactoryGirl.define do

  factory :user do
    first_name       'Manuela'
    last_name        'Carmena'
    sequence(:email) { |n| "manuela#{n}@madrid.es" }
    password         'judgmentday'
    confirmed_at     { Time.now }
  end

  factory :debate do
    sequence(:title) {|n| "Debate #{n} title"}
    description      'Debate description'
    terms_of_service '1'
    association :author, factory: :user
  end

  factory :vote do
    association :votable, factory: :debate
    association :voter, factory: :user
    vote_flag true
  end

  factory :comment do
    commentable
    user
    body 'Comment body'

    trait :hidden do
      hidden_at Time.now
    end
  end

  factory :commentable do
    debate
  end

  factory :administrator do
    user
  end

  factory :moderator do
    user
  end

end
