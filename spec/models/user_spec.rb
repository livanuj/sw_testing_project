require 'rails_helper'

RSpec.describe User, type: :model do
  # Validation tests
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
end
