class UsersController < ApplicationController
  before_action :set_user, only: [:new]

  def index
    @users = User.all
  end
  
  def new; end

  def create
    @user = User.new
    validation = UserValidator::UserSchema.with(record: @user).call(params.permit!.to_h)
    if validation.success?
      @user.attributes = validation.output[:user]
      @user.save
      redirect_to new_user_path, notice: 'Form send!'
    else
      p 'error'
      set_user
      respond_to do |format|
        format.json { render json: validation.errors }
      end
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
  # def user_params
  #   params.require(:user).permit(:first_name,
  #                               :last_name,
  #                               :email_address,
  #                               :date_of_birth,
  #                               :phone_number,
  #                               company_attributes: [:id, :name, address_attributes: [:id, :street, :city, :zip_code, :country]],
  #                               address_attributes: [:id, :street, :city, :zip_code, :country])
  # end
end
