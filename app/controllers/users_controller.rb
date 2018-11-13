class UsersController < ApplicationController
  def new
    @user = User.new
    @user.address = Address.new
    @user.company = Company.new
    @user.company.address = Address.new
  end

  def create
    @user = User.new
    p '+'*10
    p params.permit!.to_h
    
    validation = UserValidator::UserSchema.with(record: @user).call(params.permit!.to_h)
    p validation
    if validation.success?
      @user.attributes = validation.output[:user]
      @user.save
      redirect_to new_user_path, notice: 'Form send!'
    else
      redirect_to new_user_path, warning: "#{validation.errors}"
    end
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
