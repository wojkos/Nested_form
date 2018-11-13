class UserValidator
  UserSchema = Dry::Validation.Params do
    required(:user).schema do
      required(:first_name).filled
    end
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