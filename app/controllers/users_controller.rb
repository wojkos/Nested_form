class UsersController < ApplicationController
  def new
    @user = User.new
    @user.company = Company.new
    @user.address = Address.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to new_user_path, notice: 'Form send!' }
      else
        format.html { render :new }
      end
    end
  end

  def user_params
    params.require(:user).permit(:first_name,
                                :last_name,
                                :email_address,
                                :date_of_birth,
                                :phone_number,
                                company_attributes: [:id, :name],
                                address_attributes: [:id, :street, :city, :zip_code, :country])
  end
end
