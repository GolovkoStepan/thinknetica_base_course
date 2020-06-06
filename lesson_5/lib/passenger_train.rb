# frozen_string_literal: true

# rubocop:disable Style/AsciiComments

require_relative 'train'

# Класс "Пассажирский поезд"
class PassengerTrain < Train
  # Может прицеплять пассажирский вагон
  def add_carriage(carriage)
    raise ArgumentError unless carriage.is_a? PassengerCarriage

    super(carriage)
  end
end

# rubocop:enable Style/AsciiComments
