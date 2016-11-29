class UsersController < ApplicationController

  before_action :authorise, :only => [:edit, :update]

  def index
    @users = User.all
  end

  def show
    # We'll use this to display the index of the user (professional's) appointments index
    if @current_user
      @user = User.find_by :id => params[:id]
    else
      flash[:error] = "You must sign in to continue"
      redirect_to login_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path( @user )
    else
      render :new
    end
  end

  def edit
    # @user = User.find_by :id => params[:id]
    @user = @current_user
  end

  def update
    # @user = User.find_by :id => params[:id]
    @user = @current_user
    if @user.update user_params
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    # user = User.find_by :id => params[:id]
    user = @current_user
    user.destroy
    redirect_to users_path
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation, :is_professional, :profession)
    end

    def authorise
      unless @current_user.present?
        flash[:error] = "You need to be logged in"
        redirect_to login_path
      end
    end

end