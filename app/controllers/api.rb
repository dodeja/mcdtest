Mcdfinder.controllers :api do

  get :locate do
    # url is generated as "/user/#{params[:user_id]}/product"
    # url_for(:product, :index, :user_id => 5) => "/user/5/product"
    results = Mcdlocation.locate(:query => params[:query], :radius => params[:radius])
    content_type :json
    results.to_json
  end
  
  get :geocode do
    content_type :json
    Net::HTTP.get("maps.googleapis.com", "/maps/api/geocode/json?address=#{params[:query]}&sensor=false")
  end
  
  get :hello do
    content_type :json
    {:result => "hello"}.to_json
  end
end