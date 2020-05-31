# frozen_string_literal: true

RSpec.describe PassengerTrain do
  let(:carriage)       { Carriage.new 'Вагон' }
  let(:cargo_carriage) { CargoCarriage.new 'Грузовой вагон' }

  subject { described_class.new 'Пассажирский поезд' }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  it 'should not attach carriage' do
    expect { subject.add_carriage(carriage) }
      .to raise_error(ArgumentError)
  end

  it 'should not attach cargo carriage' do
    expect { subject.add_carriage(cargo_carriage) }
      .to raise_error(ArgumentError)
  end
end
