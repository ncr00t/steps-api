require 'rails_helper'

RSpec.describe User, type: :model do
  context "validation test" do

    it "ensures name presence" do
      user = User.new(name: "", email:"user1@gmail.com").save
      expect(user).to eq(false)
    end

    test "ensures email presence" do
      user = User.new(name: "user1", email: " ").save
      except(user).to eq(false)
    end

    test "should save successfully" do
      user = User.new(name: "user1", email: "user1@gmail.com").save
      except(user).to eq(true)
    end
  end
end
