require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid.com",
                                         password: "foo",
                                         password_confirmation: "bar" } 
                               }
    end
    assert_template 'users/new'
    assert_select ".alert.alert-danger", {count: 1, text: "The form contains 3 errors."}
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                        email: "user@invalid.com",
                                        password: "password",
                                        password_confirmation: "password" } 
                                }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in? 
  end

  test "flash shows information on succesful signup" do
    post users_path, params: { user: { name: "Example User",
                                    email: "user@invalid.com",
                                    password: "password",
                                    password_confirmation: "password" } 
                              }
    follow_redirect!
    # assert_equal flash[:success], "Welcome to the Sample App!"
    assert_select ".alert.alert-success"
  end
end
