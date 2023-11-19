# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:

#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: "FUKA", email: "F@K", password: "000000" ,profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/FUKAMARU.jpg"), filename:"FUKAMARU.jpg"))
User.create(name: "GABA", email: "G@A", password: "000000")
User.create(name: "GABU", email: "G@U", password: "000000")

Book.create!(title: "FUKAMARU", body: "OREWAFUKMARU",user_id: 1)
Book.create!(title: "GABAITO", body: "OREWAGABAITO",user_id: 2)
Book.create!(title: "GABURIASU", body: "OREWAGABURIASU",user_id: 3)
