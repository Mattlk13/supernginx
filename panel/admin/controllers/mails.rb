Panel::Admin.controllers :mails do
  get :index do
    @title = "Mails"
    @mails = Mail.all
    render 'mails/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'mail')
    @mail = Mail.new
    render 'mails/new'
  end

  post :create do
    @mail = Mail.new(params[:mail])
    if @mail.save
      @title = pat(:create_title, :model => "mail #{@mail.id}")
      flash[:success] = pat(:create_success, :model => 'Mail')
      params[:save_and_continue] ? redirect(url(:mails, :index)) : redirect(url(:mails, :edit, :id => @mail.id))
    else
      @title = pat(:create_title, :model => 'mail')
      flash.now[:error] = pat(:create_error, :model => 'mail')
      render 'mails/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "mail #{params[:id]}")
    @mail = Mail.find(params[:id])
    if @mail
      render 'mails/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'mail', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "mail #{params[:id]}")
    @mail = Mail.find(params[:id])
    if @mail
      if @mail.update_attributes(params[:mail])
        flash[:success] = pat(:update_success, :model => 'Mail', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:mails, :index)) :
          redirect(url(:mails, :edit, :id => @mail.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'mail')
        render 'mails/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'mail', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Mails"
    mail = Mail.find(params[:id])
    if mail
      if mail.destroy
        flash[:success] = pat(:delete_success, :model => 'Mail', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'mail')
      end
      redirect url(:mails, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'mail', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Mails"
    unless params[:mail_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'mail')
      redirect(url(:mails, :index))
    end
    ids = params[:mail_ids].split(',').map(&:strip)
    mails = Mail.find(ids)
    
    if mails.each(&:destroy)
    
      flash[:success] = pat(:destroy_many_success, :model => 'Mails', :ids => "#{ids.to_sentence}")
    end
    redirect url(:mails, :index)
  end
end
