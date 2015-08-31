Panel::App.controllers :panel do

    helpers do
      def puppetapply
        command = "sudo /opt/puppetlabs/puppet/bin/puppet apply --color=false --modulepath=/etc/puppetlabs/code/localmodules:/etc/puppetlabs/code/modules --hiera_config=/etc/puppetlabs/code/hiera.yaml /etc/puppetlabs/code/manifests/site.pp"
        system ( command )
      end
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
        ##This shall be a class, writes the new domain in the hiera yaml file puppet/hieradata/domains.yaml and redirects to /
        @newdomain=params[:domain]
        @port=params[:port].to_i
        #do proper logging (fixme)
        puts @newdomain
        require 'yaml'
        @domainsfile = '/vagrant/puppet/hieradata/domains.yaml'
        domains = YAML::load_file(@domainsfile) #Load
        new_domain_fields = {"hostname"=>@newdomain, "port"=>@port}
        domains['domains'][@newdomain]= new_domain_fields
        File.open(@domainsfile, 'w') {|f| f.write domains.to_yaml } #Store
        #create the domain in the model
        Domain.create(:domain => @newdomain, :users => session[:name], :ip => "default", :arecord => "default")
        puppetapply
        redirect_to '/'
      end
    end
    get :delete_domain, :map => '/delete_domain' do
      if params[:domain].blank?
        puts "no domain deleted"
        redirect_to '/'
      else
        ##This shall be a class, writes the new domain in the hiera yaml file puppet/hieradata/domains.yaml and redirects to /
        @deldomain=params[:domain]
        #do proper logging (fixme)
        puts @deldomain
        require 'yaml'
        @domainsfile = '/vagrant/puppet/hieradata/domains.yaml'
        domains = YAML::load_file(@domainsfile) #Load
        domains['domains'].delete(@deldomain)
        File.open(@domainsfile, 'w') {|f| f.write domains.to_yaml } #Store
        #create the domain in the model
        Domain.delete_all(:domain => @deldomain, :users => session[:name])
        stop_dockercontainer = system( "docker stop #{@deldomain}" )
        puts "container #{@deldomain} stoped" if delete_dockercontainer = true
        delete_dockercontainer = system( "docker rm #{@deldomain}" )
        puts "container #{@deldomain} deleted" if delete_dockercontainer = true
        puppetapply()
        redirect_to '/'
      end
    end
    
    get :login, :map => '/login' do
      protected!
      session[:name] = @auth.credentials.first
      render 'login', :layout => 'panel_layout'
    end

end
