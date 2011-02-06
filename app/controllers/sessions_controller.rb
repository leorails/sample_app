class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      # Sign the user in and redirect to the user's show page.
      sign_in user
      # redirect_to user will go to user's profile page, not very friendly if user requested users/1/edit before logging in
      # redirect_to user
      redirect_back_or user #this will go to the page user requested before logging in.
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
