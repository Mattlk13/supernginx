Panel::App.controllers :panel do

    helpers do
      def protected!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Please authenticate"'
        halt 401, "Not authorized\n"
      end
    
      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @password = BCrypt::Password.new(Account.where(:name => @auth.credentials.first).first.crypted_password) if (defined? @auth.credentials.first and not Account.find_by_name(@auth.credentials.first).blank?)
        @auth.provided? and @auth.basic? and @password == @auth.credentials.last if defined? @password
      end
    end

    get :index, :map => '/' do
      if authorized?
        @name = session[:name]
        @check = Domain.find_by_users(@name).blank?
        @domains = Domain.where(:users => @name).all if not Domain.find_by_users(@name).blank?
        @id = params[:domain] if not params[:domain].blank?
        @mails = Mail.all
        puts @id if not @id.blank?
        render 'index', :layout => 'panel_layout'
      else
        redirect_to '/login'
      end
    end 

    get :mail, :map => '/mail' do
      puts 'hi'
      render 'mail'
    end
    
    get :login, :map => '/login' do
      protected!
      session[:name] = @auth.credentials.first
      render 'login', :layout => 'panel_layout'
    end

end
