Mcdfinder.controllers :manage do
  layout :main

  get :index do
    protected!
    if params[:nid]
      @locations = Mcdlocation.all(:natid => params[:nid]).page(params[:page], :per_page => 20)
    else
      @locations = Mcdlocation.page(params[:page], :per_page => 20)
    end
    render "manage/index"
  end
  
  get :api do
    protected!
    render "manage/api"
  end
   
  get :new_location do
    protected!
    @location = Mcdlocation.new
    render "manage/new_location"
  end
  
  post :new_location do
    protected!
    @location = Mcdlocation.create(params[:mcdlocation])
    if @location
      flash[:notice] = "Location created!"
      redirect url_for(:manage, :location, :id => @location.id)
    else
      flash[:error] = "Error creating location."
    end
  end
  
  get :location, :with => :id do
    protected!
    @location = Mcdlocation.get(params[:id])
    render "manage/location"
  end
  
  post :location, :with => :id do
    protected!
    @location = Mcdlocation.get(params[:id])
    params[:mcdlocation][:loc] = "#{params[:mcdlocation][:loc_street_address]}, #{params[:mcdlocation][:loc_city]}, #{params[:mcdlocation][:loc_state]} #{params[:mcdlocation][:loc_zip]}"
    if @location.update(params[:mcdlocation])
      flash[:notice] = "Location updated!"
    else
      flash[:error] = "Error updating location."
    end
    render "manage/location"
  end
  
  get :delete_location, :with => :id do
    protected!
    @location = Mcdlocation.get(params[:id])
    if @location.destroy
      flash[:notice] = "Location deleted!"
    else
      flash[:error] = "Error deleting location."
    end
    redirect url_for(:manage, :index)
  end
end

