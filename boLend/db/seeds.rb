# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(fname: 'John', lname: 'Doe', email:'abc@mail.com')
user2 = User.create(fname: 'tony', lname: 'stark', email:'tony@mail.com')
user3 = User.create(fname: 'smith', lname: 'lynn', email:'smith@mail.com')
items = Item.create([{name: 'pencil', descr: 'brand new condition', status: 'available',user_id: user.id},
	{name: 'eraser', descr: 'brand new condition', status: 'lentout',user_id: user.id},
	{name: 'ps4 console', descr: 'brand new condition', status: 'borrowed' ,user_id: user.id},
	{name: 'god of war 4', descr: 'brand new condition', status: 'borrowed' ,user_id: user.id},
	{name: 'spider-man new universe', descr: 'brand new condition', status: 'available', user_id: user.id}])
