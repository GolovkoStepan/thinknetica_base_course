# frozen_string_literal: true

RSpec.describe Carriage do
  subject { described_class.new 'Вагон' }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end
end
