FactoryBot.define do
  factory :book_comment do
    comment { Faker::Lorem.characters(number: 10) }
    book
    user
  end
end
