# frozen_string_literal: true

RSpec.describe ArticleShowSerializer, type: :serializer do
  let!(:article) { create(:article) }
  let(:serialization) { ArticleShowSerializer.new(article) }
  subject { JSON.parse(serialization.to_json) }

  it 'contains id, title, lead, content, image, category and premium' do
    expected_keys = %w[id title lead content category image premium]
    expect(subject.keys).to match expected_keys
  end
end