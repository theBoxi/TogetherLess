class HomeController < ApplicationController
  def show
    if user_signed_in?
      @logs = Log.where(user_id: current_user.id, date: (Time.now - 1.week)..(Time.now)).order("date").reverse_order
      render :show_loged_in
    end
  end
end
