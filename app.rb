require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'



configure do
  enable :sessions
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
=begin Ортодоксальный вараинт, который работает выдавая отделные сообщения об Ошибке
	# для каждой пары ключ-значение
	hh.each do |key, value|
		if params[key] == ''
			@error = hh[key]
			return erb :visit
		end
	end
=end

# Более крутой вараинт написания того, что выше, в одну строку

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	f = File.open './public/users.txt', 'a'
	f.write "\nUser: #{@user_name}, Phone: #{@phone}, Date and time: #{@date_time}, Barber: #{@barber_name}, Choosen color: #{@color}"
	f.close

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
=begin	erb :message
    require 'pony'
	Pony.mail(
	    :sender_name => params[:name],
	    :mail => params[:mail],
	    :body => params[:body],
	    :to => 'bold.disney@gmail.com',
	    :subject => params[:name],
	    :body => params[:message],
	    :port => '587',
	    :via => :smtp,
	    :via_options => { 
		    :address              => 'smtp.gmail.com', 
		    :port                 => '587', 
		    :enable_starttls_auto => true, 
		    :user_name            => 'bold.disney', 
		    :password             => 'my_password', 
		    :authentication       => :plain, 
		    :domain               => 'localhost.localdomain'
	  		}
	)
	redirect '/success' 
=end
end



