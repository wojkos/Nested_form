class UserValidator
  include ValidatorRegex
  UserSchema = Dry::Validation.Params do
    configure do
      config.messages_file =
        File.join(Rails.root, 'config', 'locales', 'validation_errors.en.yml')

      def country?(value)
        COUNTRY_LIST.include? value.to_s
      end

      def email?(value)
        !EMAIL_REGEX.match(value).nil?
      end

      def correct_date?(value)
        if !DATE_REGEX.match(value).nil?
          Date.strptime(value, '%Y-%m-%d') < Date.today
        else
          false
        end
      end

      def phone?(value)
        !PHONE_REGEX.match(value).nil?
      end

      def zip_code?(value)
        !ZIP_CODE_REGEX.match(value).nil?
      end
    end
    required(:user).schema do
      required(:first_name).filled(max_size?: 100)
      required(:last_name).filled(max_size?: 100)
      required(:email_address).filled(:email?)
      required(:date_of_birth).maybe(:correct_date?)
      required(:phone_number).maybe(:phone?)
      required(:address_attributes).schema do
        required(:street).filled
        required(:city).filled
        required(:zip_code).filled(:zip_code?)
        required(:country).filled(:country?)
      end
      required(:company_attributes).schema do
        required(:name) { max_size?(200) }
        required(:address_attributes).schema do
          required(:street).maybe(:str?)
          required(:city).maybe(:str?)
          required(:zip_code).maybe(:zip_code?)
          required(:country).maybe(:country?)
        end
      end
    end
  end
end
