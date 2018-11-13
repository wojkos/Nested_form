class UsersController < ApplicationController
  before_action :set_user, only: [:new]

  def index
    @users = User.all
  end

  def new; end

  def create
    @user = User.new
    validation = UserValidator::UserSchema.with(record: @user)
                                          .call(params.permit!.to_h)
    if validation.success?
      @user.attributes = validation.output[:user]
      @user.save
      redirect_to users_path, notice: 'Form send!'
    else
      redirect_to new_user_path, alert: validation.errors.to_s
    end
  end

  private

  def set_user
    @user = User.new
    @user.address = Address.new
    @user.company = Company.new
    @user.company.address = Address.new
    @user
  end
end
