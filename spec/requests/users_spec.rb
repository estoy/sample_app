require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    describe "failure" do
    
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "inv"
          fill_in "Email",        :with => "inv"
          fill_in "Password",     :with => "inv"
          fill_in "Confirmation", :with => "inv"
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
          # How to test for empty password fields?
        end.should_not change(User, :count)
      end
    end

    describe "success" do
    
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end

  end

  describe "sign in/out" do
  
    describe "failure" do
      it "should not sign a user in" do
        integration_sign_in User.new :email => "", :password => ""
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
  
    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        integration_sign_in user
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end

  describe "users list" do
    it "should show delete links to admins" do
      admin = Factory(:user, :email => "admin@example.com", :admin => true)
      integration_sign_in(admin)
      visit users_path
      response.should have_selector("a", :content => "delete")
    end

    it "should not show delete links to non-admins" do
      user = Factory(:user)
      integration_sign_in user
      visit users_path
      response.should_not have_selector("a", :content => "delete")
    end
  end
end

