require 'rails_helper'

RSpec.feature 'Fill user form' do
  before do
    visit '/'
  end
  scenario 'with valid inputs' do
    fill_in 'First name', with: 'Jon'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email address', with: 'jon@example.com'
    fill_in 'user_address_attributes_street', with: 'Example'
    fill_in 'user_address_attributes_city', with: 'Warsaw'
    fill_in 'user_address_attributes_zip_code', with: '00-000'
    fill_in 'user_address_attributes_country', with: 'Poland'
    click_button 'Submit'
    expect(current_path).to eq(users_path)
    expect(page).to have_content('Form send!')
    expect(User.count).to eq(1)
  end

  scenario 'with invalid inputs' do
    fill_in 'First name', with: 'Jon'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email address', with: 'jon'
    click_button 'Submit'
    expect(page).to have_content('must be filled')
    expect(User.count).to eq(0)
  end

  scenario 'with no inputs' do
    click_button 'Submit'
    expect(page).to have_content('must be filled')
    expect(User.count).to eq(0)
  end
end
