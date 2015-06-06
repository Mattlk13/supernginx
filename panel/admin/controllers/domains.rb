Panel::Admin.controllers :domains do
  get :index do
    @title = "Domains"
    @domains = Domain.all
    render 'domains/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'domain')
    @domain = Domain.new
    render 'domains/new'
  end

  post :create do
    @domain = Domain.new(params[:domain])
    if @domain.save
      @title = pat(:create_title, :model => "domain #{@domain.id}")
      flash[:success] = pat(:create_success, :model => 'Domain')
      params[:save_and_continue] ? redirect(url(:domains, :index)) : redirect(url(:domains, :edit, :id => @domain.id))
    else
      @title = pat(:create_title, :model => 'domain')
      flash.now[:error] = pat(:create_error, :model => 'domain')
      render 'domains/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "domain #{params[:id]}")
    @domain = Domain.find(params[:id])
    if @domain
      render 'domains/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'domain', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "domain #{params[:id]}")
    @domain = Domain.find(params[:id])
    if @domain
      if @domain.update_attributes(params[:domain])
        flash[:success] = pat(:update_success, :model => 'Domain', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:domains, :index)) :
          redirect(url(:domains, :edit, :id => @domain.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'domain')
        render 'domains/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'domain', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Domains"
    domain = Domain.find(params[:id])
    if domain
      if domain.destroy
        flash[:success] = pat(:delete_success, :model => 'Domain', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'domain')
      end
      redirect url(:domains, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'domain', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Domains"
    unless params[:domain_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'domain')
      redirect(url(:domains, :index))
    end
    ids = params[:domain_ids].split(',').map(&:strip)
    domains = Domain.find(ids)
    
    if domains.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Domains', :ids => "#{ids.to_sentence}")
    end
    redirect url(:domains, :index)
  end
end
