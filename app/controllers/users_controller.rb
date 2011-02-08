class UsersController < ApplicationController
  #before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  #Listing 12.29
  before_filter :authenticate, :except => [:show, :new, :create]
  
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :signedin_user,:only => [:new, :create]
  
  def index
    @title = "All users"
    # @users = User.all
    # Paginate:
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      # Handle a successful save.
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    # already called in correct_user method:
    # @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    # already called in correct_user method:
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if (user.id != current_user.id)
      user.destroy
      flash[:success] = "User destroyed."
    else
      flash[:notice] = "User cannot destroy themselves"
    end

    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  private
    # Refactored and moved to sessions_helper
#    def authenticate
#      deny_access unless signed_in?
#    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signedin_user
      # new/create actions are for non-signed-in users, e.g. current_user.nil == true
      redirect_to(root_path) unless current_user.nil?
    end
end
