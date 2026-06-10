require 'rails_helper'

RSpec.describe Connection, type: :model do
  let(:sender) { User.create!(email: "sender@example.com", password: "password") }
  let(:receiver) { User.create!(email: "receiver@example.com", password: "password") }

  it "is valid with valid attributes" do
    connection = Connection.new(sender: sender, receiver: receiver, status: 'pending')
    expect(connection).to be_valid
  end

  it "is invalid without a status" do
    connection = Connection.new(sender: sender, receiver: receiver, status: nil)
    expect(connection).not_to be_valid
  end

  it "cannot connect a user to themselves" do
    connection = Connection.new(sender: sender, receiver: sender, status: 'pending')
    expect(connection).not_to be_valid
    expect(connection.errors[:receiver_id]).to include("You cannot connect with yourself")
  end

  it "enforces unique sender/receiver combination" do
    Connection.create!(sender: sender, receiver: receiver, status: 'pending')
    duplicate = Connection.new(sender: sender, receiver: receiver, status: 'accepted')
    expect(duplicate).not_to be_valid
  end
end
