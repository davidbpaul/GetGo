# class PreferencesController
class PreferencesController < ApplicationController
  def show
    @user = User.find params[:user_id]
    @preference = @user.preference


  end

  def new
    # url = 'https://getgo-api.herokuapp.com/agencies/GO/routes'
    url = 'http://localhost:3000/agencies/GO/routes'
    response = HTTParty.get(url)
    response_body = JSON.parse response.body
    @routes = []
    response_body['routes'].each do |route|
      option = route['id'] + ' ' + route['long_name']
      @routes << [option, route['id']]
    end
  end

  def edit
    url = 'http://localhost:3000/agencies/GO/routes'
    response = HTTParty.get(url)
    response_body = JSON.parse response.body
    @routes = []
    response_body['routes'].each do |route|
      option = route['id'] + ' ' + route['long_name']
      @routes << [option, route['id']]
    end
  end

  def create
    @user = current_user
    @preference = Preference.find_or_initialize_by(user_id: @user.id)
    @preference.attributes = preference_params
    if @preference.save
      redirect_to schedules_index_path, notice: 'Preference added!'
    else
      redirect_to new_user_preference_path, notice: 'Please try again'
    end

    # preference = Preference.new preference_params
    # preference.user_id = params[:user_id]
    # if preference.save
    #   redirect_to schedules_index_path
    # else
    #   redirect_to new_user_preference_path
    # end
  end

  def update
    preference = Preference.find_by(user_id: params[:user_id])
    preference.update(user_id: params[:user_id])
    preference.update preference_params
    redirect_to schedules_index_path
  end

  def destroy
    # user = User.find params[:user_id]
    # # preference = Preference.find_by_user_id params[:user_id]
    # preference = user.preference
    # preference.destroy
    # redirect_to schedules_index_path

    Preference.where(user_id: params[:user_id]).destroy_all
    redirect_to schedules_index_path
  end

  private

  def preference_params
    params.require(:preference).permit(:route, :route_variant, :from_stop, :to_stop)
  end
end
