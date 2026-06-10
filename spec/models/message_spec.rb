require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:sender) { User.create!(email: "sender2@example.com", password: "password") }
  let(:receiver) { User.create!(email: "receiver2@example.com", password: "password") }

  it "is valid with valid attributes" do
    message = Message.new(sender: sender, receiver: receiver, content: "Hello world!")
    expect(message).to be_valid
  end

  it "is invalid without content" do
    message = Message.new(sender: sender, receiver: receiver, content: "")
    expect(message).not_to be_valid
  end
end
