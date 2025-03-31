class Admin::UsersController < AdminController
  before_action :set_user, only: %i[ edit update destroy ]
  before_action :set_permission_sets, only: %i[ new edit update create ]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "User created successfully"
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "#{@user.email} updated successfully"
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted successfully"
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def set_permission_sets
    @permission_sets = PermissionSet.descendants.map { |p| [ p.name, p.name ] }
  end

  def user_params
    permitted = params.require(:user).permit(:email, :password, :password_confirmation, permission_sets: [])
    permitted[:permission_sets] &= PermissionSet.descendants.map(&:name)
    permitted
  end
end
