require 'rails_helper'

def validate(params, error_msg, bool: false)
  validator = UserValidator::UserSchema.call(params)
  expect(validator.success?).to eq(bool)
  expect(validator.errors.to_s).to include(error_msg)
end

describe UserValidator do
  params =
    {'user' => {'first_name' => 'Jon',
                'last_name' => 'Doe',
                'email_address' => 'jon@exaple.com',
                'date_of_birth' => '1990-09-12',
                'phone_number' => '789987789',
                'address_attributes' => {'street' => 'Test',
                                         'city' => 'Warsaw',
                                         'zip_code' => '00-001',
                                         'country' => 'Poland'},
                'company_attributes' => {'name' => 'Super company',
                                         'address_attributes' => {'street' => 'Foobar',
                                                                  'city' => 'Warsaw',
                                                                  'zip_code' => '00-002',
                                                                  'country' => 'Poland'}}}}
  before(:context) do
    params = params
  end

  context 'valid params' do
    it 'fill all should return true' do
      validator = UserValidator::UserSchema.call(params)
      expect(validator.success?).to eq(true)
    end

    it 'fill only require should return true' do
      params['user']['date_of_birth'] = ''
      params['user']['phone_number'] = ''
      params['user']['company_attributes']['name'] = ''
      params['user']['company_attributes']['address_attributes']['street'] = ''
      params['user']['company_attributes']['address_attributes']['city'] = ''
      params['user']['company_attributes']['address_attributes']['zip_code'] = ''
      params['user']['company_attributes']['address_attributes']['country'] = ''
      validator = UserValidator::UserSchema.call(params)
      expect(validator.success?).to eq(true)
    end
  end

  context 'first_name' do
    it 'is require' do
      params['user']['first_name'] = ''
      validate(params, 'must be filled')
    end

    it 'length less then 100' do
      params['user']['first_name'] = 'a' * 101
      validate(params, 'size cannot be greater than 100')
    end
  end

  context 'last_name' do
    it 'is require' do
      params['user']['last_name'] = ''
      validate(params, 'must be filled')
    end

    it 'length less then 100' do
      params['user']['last_name'] = 'a' * 101
      validate(params, 'size cannot be greater than 100')
    end
  end

  context 'email_address' do
    it 'is require' do
      params['user']['email_address'] = ''
      validate(params, 'must be filled')
    end

    it 'require email format' do
      wrong_emails = ['aaa', 'exasas@dad.dsad;dsas', 'www.wp.pl']
      wrong_emails.each do |email|
        params['user']['email_address'] = email
        validate(params, 'Wrong email format')
      end
    end
  end

  context 'date_of_birth' do
    it 'require date format' do
      params['user']['date_of_birth'] = 'aaa'
      validate(params, 'Wrong date')
    end

    it 'require date from past' do
      params['user']['date_of_birth'] = '2020-09-12'
      validate(params, 'Wrong date')
    end
  end

  context 'phone_number' do
    it 'require phone format' do
      wrong_numbers = ['aaa', '123-321-234', '838 345 321']
      wrong_numbers.each do |number|
        params['user']['phone_number'] = number
        validate(
          params,
          'Wrong phone number format. Use only digits with + on begining'
        )
      end
    end
  end

  context 'user address street' do
    it 'is require' do
      params['user']['address_attributes']['street'] = ''
      validate(params, 'must be filled')
    end
  end

  context 'user address city' do
    it 'is require' do
      params['user']['address_attributes']['city'] = ''
      validate(params, 'must be filled')
    end
  end

  context 'user address zip_code' do
    it 'is require' do
      params['user']['address_attributes']['zip_code'] = ''
      validate(params, 'must be filled')
    end

    it 'require zip_code format' do
      wrong_codes = ['aaa', '123-321-234', '838345']
      wrong_codes.each do |code|
        params['user']['address_attributes']['zip_code'] = code
        validate(
          params,
          'Wrong zip code format. Use 00-000 format insted'
        )
      end
    end
  end

  context 'user address country' do
    it 'is require' do
      params['user']['address_attributes']['country'] = ''
      validate(params, 'must be filled')
    end

    it 'require correct country' do
      wrong_countries = %w[aaa Warsaw 838345]
      wrong_countries.each do |country|
        params['user']['address_attributes']['country'] = country
        validate(params, 'Is not a correct country name')
      end
    end
  end

  context 'company_name' do
    it 'length less then 200' do
      params['user']['company_attributes']['name'] = 'a' * 201
      validate(params, 'size cannot be greater than 200')
    end
  end

  context 'company address zip_code' do
    it 'require zip_code format' do
      wrong_codes = ['aaa', '123-321-234', '838345']
      wrong_codes.each do |code|
        params['user']['company_attributes']['address_attributes']['zip_code'] = code
        validate(
          params,
          'Wrong zip code format. Use 00-000 format insted'
        )
      end
    end
  end

  context 'company address country' do
    it 'require correct country' do
      wrong_countries = %w[aaa Warsaw 838345]
      wrong_countries.each do |country|
        params['user']['company_attributes']['address_attributes']['country'] = country
        validate(params, 'Is not a correct country name')
      end
    end
  end
end
