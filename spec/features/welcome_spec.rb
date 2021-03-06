require 'rails_helper'

feature "Welcome screen" do

  scenario 'a regular users sees it the first time he logs in' do
    user = create(:user)

    login_through_form_as(user)

    expect(current_path).to eq(welcome_path)
  end

  scenario 'it is not shown more than once' do
    user = create(:user, sign_in_count: 2)

    login_through_form_as(user)

    expect(current_path).to eq(proposals_path)
  end

  scenario 'is not shown to organizations' do
    organization = create(:organization)

    login_through_form_as(organization.user)

    expect(current_path).to eq(proposals_path)
  end

  scenario 'it is not shown to level-2 users' do
    user = create(:user, residence_verified_at: Time.now, confirmed_phone: "123")

    login_through_form_as(user)

    expect(current_path).to eq(proposals_path)
  end

  scenario 'it is not shown to level-3 users' do
    user = create(:user, verified_at: Time.now)

    login_through_form_as(user)

    expect(current_path).to eq(proposals_path)
  end

end
