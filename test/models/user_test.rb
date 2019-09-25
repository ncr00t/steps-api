require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "user1", email: "user1@gmail.com",
                     password: "123456", password_confirmation: "123456")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should not be nil" do
    @user.email = nil
    assert_not @user.valid?
    assert_not_nil @user.errors[:email]
  end

  test "name should not be nil" do
    @user.name = nil
    assert_not @user.valid?
    assert_not_nil @user.errors[:name]
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_address = "user@example.com"
    @user.email = valid_address
    assert @user.valid?, "#{valid_address} should be valid"
  end

  test "email validation should reject invalid addresses" do
    invalid_address = "foo@bar+baz.com"
    @user.email = invalid_address
    assert_not @user.valid?, "#{invalid_address} should be invalid"
  end

  test "password should be present" do
    @user.password = "  "
    assert_not @user.valid?
  end

  test "password should have a minimum length 8 symbols" do
    @user.password = "a" * 3
    assert_not @user.valid?
  end
end
