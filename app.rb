require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS
  	"Users" 
  		(
		  	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		  	"name" VARCHAR,
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
#	unless session[:identity]
 #  	session[:previous_url] = request.path
  #  	@error = 'Извините, для записи он-лайн нужно быть зарегистрированным пользователем.'
   # 	halt erb(:login_form)
	#end

	@user_name = params[:user_name]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber_name = params[:barber_name]
	@color = params[:color]

	hh = { :user_name => 'Введите имя', 
		:phone => 'Введите телефон', 
		:date_time => 'Введите дату и время'
	}

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into
		Users 
		(
			name,
			phone,
			dateStamp,
			barber,
			color
		) 
		values ( ?, ?, ?, ?, ?)', [@user_name, @phone, @date_time, @barber_name, @color]



	@title = "Благодарим Вас, #{@user_name.capitalize}!"
	@message = "#{@barber_name} будет с нетерпением ждать Вас #{@date_time}." 
	
	erb :message
end

def get_db
		return SQLite3::Database.new 'barbershop.db'
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



