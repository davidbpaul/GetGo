# class PreferencesController
class PreferencesController < ApplicationController
  def show
  end

  def new
  end

  def edit
  end

  def create
    @user = User.find(current_user.id)
    @preference = @user.preference.new(preference_params)

    if @preference.save
      redirect_to schedules_path, notice: 'Preference added!'
    else
      redirect_to new_user_preference_path, notice: 'Please try again'
    end
  end

  def update
  end

  def destroy
  end

  private

  def preference_params
    params.require(:preference).permit(:route, :from_stop, :to_stop)
  end
end
