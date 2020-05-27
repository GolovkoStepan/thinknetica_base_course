# frozen_string_literal: true

# rubocop:disable Style/AsciiComments

# Класс "Станция"
class Station
  attr_reader :name

  def initialize(name)
    # Имеет название, которое указывается при создании
    @name   = name
    @trains = []
  end

  # Может принимать поезда (по одному за раз)
  def take_train(train)
    raise ArgumentError unless train.is_a? Train

    @trains << train
  end

  # Может возвращать список всех поездов на станции
  # Может возвращать список поездов на станции по типу
  def trains(for_type: :all)
    raise ArgumentError unless for_type.is_a? Symbol
    return @trains if for_type == :all

    @trains.select { |train| train.type == for_type }
  end

  # Может отправлять поезда (по одному за раз, при этом,
  # поезд удаляется из списка поездов, находящихся на станции).
  def send_train(train)
    @trains.delete(train)
  end

  def to_s
    @name
  end
end

# Класс "Маршрут"
class Route
  attr_accessor :start_station
  attr_accessor :end_station

  def initialize(start_station:, end_station:)
    unless start_station.is_a?(Station) && end_station.is_a?(Station)
      raise ArgumentError
    end

    # Имеет начальную и конечную станцию, а также список промежуточных станций.
    # Начальная и конечная станции указываютсся при создании маршрута
    @start_station = start_station
    @end_station   = end_station
    @way_stations  = []
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

# Класс "Поезд"
class Train
  TRAIN_TYPES = %i[passenger cargo].freeze
  MAX_SPEED   = 100

  # Тип поезда
  attr_accessor :type
  # Номер поезда
  attr_accessor :number
  # Может возвращать текущую скорость
  attr_reader :speed
  # Может возвращать количество вагонов
  attr_reader :carriages_count
  # Текущая станция
  attr_reader :current_station

  def initialize(number:, type:, carriages_count:)
    raise ArgumentError unless TRAIN_TYPES.include? type

    # Имеет номер (произвольная строка)
    @number = number
    # Тип (грузовой, пассажирский)
    @type = type
    # Количество вагонов
    @carriages_count = carriages_count
    # Текущая скорость
    @speed = 0
  end

  # Может набирать скорость
  def speed_up
    @speed = 100
  end

  # Может тормозить (сбрасывать скорость до нуля)
  def brake
    @speed = 0
  end

  # Может прицеплять вагон
  def add_carriage
    @carriages_count += 1 if @speed.zero?
  end

  # Может отцеплять вагон
  def remove_carriage
    @carriages_count -= 1 if @speed.zero?
  end

  # Может принимать маршрут следования (объект класса Route)
  def assign_route(route)
    raise ArgumentError unless route.is_a? Route

    @route = route
    # При назначении маршрута поезду, поезд
    # автоматически помещается на первую станцию в маршруте.
    @route.start_station.take_train(self)
    @current_station = @route.start_station
  end

  # Перемещение на одну станцию вперед
  def move_ahead
    move to_station: :next_station
  end

  # Перемещение на одну станцию назад
  def move_back
    move to_station: :previous_station
  end

  # Предыдущая станция
  def previous_station
    find_station(-1)
  end

  # Следующая станция
  def next_station
    find_station(1)
  end

  private

  def move(to_station:)
    return unless @route && @speed == MAX_SPEED
    return unless respond_to? to_station

    station = send(to_station)
    return unless station

    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
  end

  def find_station(prev_or_next)
    return unless @route

    index = @route.all_stations.index(@current_station) + prev_or_next
    return if index.negative? || index >= @route.all_stations.count

    @route.all_stations[index]
  end
end

# rubocop:enable Style/AsciiComments

station_one = Station.new('Станция 1')
station_two = Station.new('Станция 2')
station_three = Station.new('Станция 3')

route_one = Route.new(start_station: station_one, end_station: station_three)
route_one.add_way_station(station_two)

train_one = Train.new(number: 'Поезд 1', type: :cargo, carriages_count: 5)
train_one.assign_route(route_one)

train_one.speed_up

train_one.move_ahead
train_one.move_ahead
train_one.move_back

puts train_one.current_station
