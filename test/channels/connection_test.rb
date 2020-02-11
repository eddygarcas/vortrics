require 'test_helper'
class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase

  test "connects with device" do
    user = FactoryBot.create(:user)
    connect_with_user(user)
    assert_equal connection.current_user, user
  end

  test "unauthorized without device" do
    assert_raises ActionCable::Connection::Authorization::UnauthorizedError do
      connect_with_user nil
    end
  end

  private

  def connect_with_user(user)
    connect env: { 'warden' => FakerEnv.new(user)}
  end

  class FakerEnv
    attr_reader :user
    def initialize user
      @user = user
    end
  end
end