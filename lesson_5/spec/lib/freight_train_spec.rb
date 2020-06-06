# frozen_string_literal: true

RSpec.describe FreightTrain do
  let(:carriage)           { Carriage.new 'Вагон' }
  let(:passenger_carriage) { PassengerCarriage.new 'Пассажирский вагон' }

  subject { described_class.new 'Грузовой поезд' }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  it 'should not attach carriage' do
    expect { subject.add_carriage(carriage) }
      .to raise_error(ArgumentError)
  end

  it 'should not attach passenger carriage' do
    expect { subject.add_carriage(passenger_carriage) }
      .to raise_error(ArgumentError)
  end
end
