require 'spec/spec_helper'

RSpec.describe User, type: :model do
  context "validation test" do
    it "ensures name is present" do
      user = User.new(email:"user1@gmail.com")
      except(user.valid?).to eq(false )
    end

    it "ensures email is present" do
      user = User.new(name:"user1")
      except(user.valid?).to eq(false )
    end

    it "name should be present" do
      user = User.new(name: "")
      expect(user.valid?).to eq(false )
    end

    it "email should be present" do
      user = User.new(password: "")
      user.valid?
      user.errors[:email].should_not be_empty
    end

    it "password should be present" do
      user = User.new(email: "")
      user.valid?
      user.errors[:password].should_not be_empty
    end

    it "ensures name presence" do
      user = User.new(name: "", email:"user1@gmail.com", password: "123456", password_confirmation: "123456").save
      expect(user).to eq(false)
    end

    test "ensures email presence" do
      user = User.new(name: "user1", email: " ", password: "123456", password_confirmation: "123456").save
      except(user).to eq(false)
    end

    test "should save successfully" do
      user = User.new(name: "user1", email: "user1@gmail.com", password: "123456", password_confirmation: "123456").save
      except(user).to eq(true)
    end
  end
end
