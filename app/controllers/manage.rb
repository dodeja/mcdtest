Mcdfinder.controllers :manage do

  layout :main

  get :index do
    @locations = Mcdlocation.page(params[:page], :per_page => 20)
    render "manage/index"
  end
  
  get :api do
    render "manage/api"
  end
   
  get :new_location do
    @location = Mcdlocation.new
    render "manage/new_location"
  end
  
  post :new_location do
    @location = Mcdlocation.create(params[:mcdlocation])
    if @location
      flash[:notice] = "Location created!"
      redirect url_for(:manage, :location, :id => @location.id)
    else
      flash[:error] = "Error creating location."
    end
  end
  
  get :location, :with => :id do
    @location = Mcdlocation.get(params[:id])
    render "manage/location"
  end
  
  post :location, :with => :id do
    @location = Mcdlocation.get(params[:id])
    if @location.update(params[:mcdlocation])
      flash[:notice] = "Location updated!"
    else
      flash[:error] = "Error updating location."
    end
    render "manage/location"
  end
  
  get :delete_location, :with => :id do
    @location = Mcdlocation.get(params[:id])
    if @location.destroy
      flash[:notice] = "Location deleted!"
    else
      flash[:error] = "Error deleting location."
    end
    redirect url_for(:manage, :index)
  end
  
end