# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

default_password = { password: 'password', password_confirmation: 'password' }
default_user = User.create_with(default_password).find_or_create_by(email: 'default@gmail.com')

default_block = default_user.blocks.create(title: 'Стартовая колода', user: default_user)

words_path = "#{Rails.root}/db/seed/words.yml"
words = YAML.load File.read(words_path) # ['original' => 'translated', ...]
words.each do |original, translated|
  default_block.cards.create(original_text: original, translated_text: translated)
end
