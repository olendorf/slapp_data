# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home page features' do
  let(:user) { create(:user) }
  let(:admin) { FactorBot.create :admin }
  let(:owner) { create(:owner) }

  context 'when user is not logged in' do
    it 'user should see sign in link' do
      visit root_path
      expect(page).to have_link('Login', href: new_user_session_path)
    end

    it 'user cannot visit admin pages' do
      visit admin_root_path
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end

  context 'when admin logs in' do
    before do
      visit static_pages_index_path
      click_on('Login')
      fill_in('Avatar name', with: owner.avatar_name)
      fill_in('Password', with: 'Pa$sW0rd')
      click_on('Log in')
    end

    it 'and visits admin pages' do
      expect(page).to have_current_path('/')
    end

    it 'and visists home page' do
      visit static_pages_index_path
      expect(page).to have_content(owner.avatar_name)
      expect(page).to have_link('Logout', href: destroy_user_session_path)
      expect(page).to have_link('Admin stuff', href: admin_dashboard_path)
    end

    it 'user signs out' do
      visit static_pages_index_path
      click_on('Logout')
      expect(page).to have_content('Signed out successfully.')
      expect(page).to have_current_path(root_path)
    end
  end
end
