class UserValidator
  UserSchema = Dry::Validation.Schema do
    # regular expression for phone validations
    PHONE_REGEX = /\A\+\d*/
    configure do
      # we need this to perform database-related validation, i.e. uniqueness
      option :record
      # custom error messages
      config.messages_file = File.join(Rails.root, 'config',
                                       'locales', 'validation_errors.en.yml')
      # sanitize input hash permitting only whitelisted parameters.
      # All parameters in this file will be whitelisted,
      # others will be filtered out
      config.input_processor = :sanitizer

      # universal uniqueness predicate
      def unique?(attr_name, value)
        !record.class.where.not(id: record.id).where(attr_name => value).exists?
      end

      # checking if value matches PHONE_REGEX
      def phone?(value)
        !PHONE_REGEX.match(value).nil?
      end
    end

    # wrap schema in :user, mimicking strong_parameters require method
    required(:user).schema do
      required(:full_name).filled
      required(:phone).filled(:phone?, unique?: :phone)
      optional(:password).filled(min_size?: 8)
      optional(:password_confirmation).filled
      optional(:email).filled(unique?: :email)

      # custom rules for password confirmation
      rule(password_confirmed?: [:password, :password_confirmation]) do |password, password_confirmation|
        password.filled?.then(password_confirmation.eql?(password))
      end

      rule(password_confirmation_filled?: [:password, :password_confirmation]) do |password, password_confirmation|
        password.filled?.then(password_confirmation.filled?)
      end
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