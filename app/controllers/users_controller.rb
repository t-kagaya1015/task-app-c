class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  
  def index
    @users = User.all
  end 
  
  def show
    @user = User.find(params[:id])
  end

  def new
    if logged_in? && !current_user.admin?
      flash[:info] = 'すでにログインしています。'
      redirect_to current_user
    end
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      rediract_to @user
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
 def update
  @user = User.find(params[:id])
  if @user.update_attributes(user_params)
    flash[:success] = "ユーザー情報を更新しました。"
    redirect_to @user
  else
    render :edit      
  end
 end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeフィルター
    
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end
    
 # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end