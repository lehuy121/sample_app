class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t ".not_found"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, t(".cant_be empty"))
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t ".password_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:warning] = t ".email_not_found"
    redirect_to signup_path
  end

  def valid_user
    return if (@user.activated? && @user.authenticated?(:reset, params[:id]))

    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t ".password_reset_expired"
      redirect_to new_password_reset_url
    end
  end
end
