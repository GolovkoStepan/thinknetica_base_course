# frozen_string_literal: true

require_relative 'common/instance_counter'

# rubocop:disable Style/AsciiComments

# Класс "Станция"
class Station
  include Common::InstanceCounter

  attr_reader :name

  def initialize(name)
    # Имеет название, которое указывается при создании
    @name   = name
    @trains = []

    self.class.send(:add_instance, self)
  end

  # Может принимать поезда (по одному за раз)
  def take_train(train)
    raise ArgumentError unless train.is_a? Train

    @trains << train
  end

  # Может возвращать список всех поездов на станции
  # Может возвращать список поездов на станции по типу
  def trains(for_type: Train)
    raise ArgumentError unless for_type.is_a? Class
    return @trains if for_type == Train

    @trains.select { |train| train.is_a? for_type }
  end

  # Может отправлять поезда (по одному за раз, при этом,
  # поезд удаляется из списка поездов, находящихся на станции).
  def send_train(train)
    @trains.delete(train)
  end

  class << self
    def all
      @instances || []
    end

    private

    def add_instance(instance)
      @instances ||= []
      @instances << instance
    end
  end
end

# rubocop:enable Style/AsciiComments
