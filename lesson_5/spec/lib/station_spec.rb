# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe Station do
  let(:station_name) { 'Тестовая стацния' }
  subject { described_class.new(station_name) }

  it 'should create class instance' do
    expect(subject.class).to eq(described_class)
  end

  it 'should take train' do
    subject.take_train(Train.new('Поезд'))
    expect(subject.trains.count).to eq(1)
  end

  context 'trains processing' do
    let(:passenger_train) { PassengerTrain.new('Пассажирский поезд') }
    let(:freight_train)   { FreightTrain.new('Грузовой поезд') }

    before do
      subject.take_train(passenger_train)
      subject.take_train(freight_train)
    end

    it 'should raise ArgumentError for wrong arguments' do
      expect { subject.take_train(Object.new) }
        .to raise_error(ArgumentError)
    end

    it 'should return all trains' do
      expect(subject.trains).to eq([passenger_train, freight_train])
    end

    it 'should return only passenger trains' do
      expect(subject.trains(for_type: PassengerTrain)).to eq([passenger_train])
    end

    it 'should return only passenger trains' do
      expect(subject.trains(for_type: FreightTrain)).to eq([freight_train])
    end

    it 'should send train' do
      subject.send_train(passenger_train)
      expect(subject.trains).to eq([freight_train])
    end
  end
end

# rubocop:enable Metrics/BlockLength
