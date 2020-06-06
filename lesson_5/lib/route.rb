# frozen_string_literal: true

require_relative 'common/instance_counter'

# rubocop:disable Style/AsciiComments

# Класс "Маршрут"
class Route
  include Common::InstanceCounter

  attr_accessor :name
  attr_accessor :start_station
  attr_accessor :end_station
  attr_reader   :way_stations

  def initialize(name:, start_station:, end_station:)
    unless start_station.is_a?(Station) && end_station.is_a?(Station)
      raise ArgumentError
    end

    # Имеет начальную и конечную станцию, а также список промежуточных станций.
    # Начальная и конечная станции указываютсся при создании маршрута
    @start_station = start_station
    @end_station   = end_station
    @name          = name
    @way_stations  = []

    send(:register_instance)
  end

  # Может добавлять промежуточную станцию в список
  def add_way_station(station)
    raise ArgumentError unless station.is_a? Station

    @way_stations << station
  end

  # Может удалять промежуточную станцию из списка
  def remove_way_station(station)
    @way_stations.delete(station)
  end

  # Может выводить список всех станций по-порядку от начальной до конечной
  def all_stations
    [@start_station] + @way_stations + [@end_station]
  end
end

# rubocop:enable Style/AsciiComments
