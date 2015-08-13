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
        @mails = Mail.all
        render 'index', :layout => 'panel_layout'
      else
        redirect_to '/login'
      end
    end 

    get :mail, :map => '/mail' do
      @mailaddress = params[:mailaddress] if not params[:mailaddress].blank?
      puts 'rendering mail content'
      render 'mail'
    end
    get :domain, :map => '/domain' do
      @domain = params[:domain] if not params[:domain].blank?
      puts 'rendering domain content'
      render 'domain'
    end
    get :new_domain, :map => '/new_domain' do
      if params[:domain].blank?
        puts 'rendering new_domain content'
        render 'new_domain'
      else
        @newdomain=params[:domain]
        @port=params[:port]
        puts @newdomain
        require 'yaml'
        domains = YAML::load_file('/vagrant/puppet/hieradata/domains.yaml') #Load
        new_domain_fields = {"hostname"=>@newdomain, "port"=>@port}
        domains['domains'][@newdomain]= new_domain_fields
        File.open('/vagrant/puppet/hieradata/domains.yaml', 'w') {|f| f.write domains.to_yaml } #Store
        redirect_to '/'
      end
    end
    
    get :login, :map => '/login' do
      protected!
      session[:name] = @auth.credentials.first
      render 'login', :layout => 'panel_layout'
    end

end
