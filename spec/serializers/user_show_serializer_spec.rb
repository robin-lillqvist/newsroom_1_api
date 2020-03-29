# frozen_string_literal: true

RSpec.describe UserShowSerializer, type: :serializer do
  let!(:user) { create(:user) }
  let(:serialization) { UserShowSerializer.new(user) }
  subject { JSON.parse(serialization.to_json) }

  it 'contains id, email, premium_user, role' do
    expected_keys = %w[id email premium_user]
    expect(subject.keys).to match expected_keys
  end
end
