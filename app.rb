require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
  enable :sessions
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'CREATE TABLE IF NOT EXISTS
  "Users" 
  (
  	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
  	"user_name" VARCHAR,
  	"phone" VARCHAR, 
  	"dateStamp" VARCHAR, 
  	"barber" VARCHAR, 
  	"color" VARCHAR
  	)'
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Привет незнакомец!'
  end
end

get '/index' do
	erb :index
end

get '/about' do
	erb :about
end
get '/ref' do
	erb :ref
end

get '/visit' do
	erb :visit
end

get '/login_form' do
	erb :login_form
end

post '/visit' do

	@user_name = params[:user_name]
	@phone = params[:phone]
	@dateStamp = params[:dateStamp]
	@barber_name = params[:barber_name]
	@color = params[:color]

	hh = { :user_name => 'Введите имя', 
		:phone => 'Введите телефон', 
		:dateStamp => 'Введите дату и время'
	}
# Более крутой вараинт написания того, что выше, в одну строку

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
    db.execute 'insert into
			Users
			(
					user_name,
					phone,
					dateStamp,
					barber,
					color
			)
			values ( ?, ?, ?, ?, ?)' , [@user_name, @phone, @dateStamp, @barber_name, @color]

	@title = "Благодарим Вас, #{@user_name.capitalize}!"
	@message = "#{@barber_name} будет с нетерпением ждать Вас #{@date_time}." 
	
	erb :message

end

get '/contacts' do
	erb :contacts
end

post '/contacts' do

	@user_message = params[:user_message]

	message_book = File.open './public/message_book.txt', 'a' 
	message_book.write "\n#{@user_message}"
	message_book.close

	@title = "Благодрим за сообщение!"
	@message = "Если того требует Ваше обращение и если вы оставили нам свои контакты, то мы обязательно свяжемся с Вами. Ну или не свяжемся. Как пойдет."

	erb :message

end

get '/showusers' do
	db = get_db
	@results = db.execute 'SELECT * FROM Users order by id desc' 

	erb :showusers
	
end