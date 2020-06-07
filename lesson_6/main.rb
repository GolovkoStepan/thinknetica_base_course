# frozen_string_literal: true

require 'tty-prompt'

Dir[File.join(__dir__, '/lib/*.rb')].sort.each(&method(:require))

# rubocop:disable Metrics/AbcSize
# rubocop:disable Layout/LineLength
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/MethodLength

# Railway simulator console client
class RailwayConsoleClient
  attr_accessor :stations
  attr_accessor :trains
  attr_accessor :routes

  MAIN_MENU_CONFIGURATION = {
    'Создать новую станцию' => :create_station,
    'Создать новый поезд' => :create_train,
    'Управление маршрутами' => :routes_processing,
    'Управление поездами' => :trains_processing,
    'Просмотр информации' => :railway_state_info,
    'Завершить программу' => :complete_main_menu_loop
  }.freeze

  def initialize
    @prompt   = TTY::Prompt.new
    @stations = []
    @trains   = []
    @routes   = []
  end

  def run_main_menu_loop
    loop do
      @prompt.select('Главное меню') do |menu|
        MAIN_MENU_CONFIGURATION.each do |key, value|
          menu.choice key, -> { send(value) }
        end
      end
    end
  end

  private

  def create_station
    station_name = @prompt.ask('Введите название станции:')
    @stations << Station.new(station_name)

    wait_and_clear msg: "Станция [#{station_name}] создана"
  end

  def create_train
    train_class = @prompt.select('Выберите тип поезда') do |menu|
      menu.choice 'Пассажирский поезд', value: PassengerTrain
      menu.choice 'Грузовой поезд',     value: FreightTrain
      menu.choice 'Назад',              value: nil
    end

    return wait_and_clear wait_for: 0 unless train_class[:value]

    begin
      train_name = @prompt.ask('Введите название поезда:')
      train = train_class[:value].new(train_name)
    rescue TrainErrors::NumberEmpty
      puts 'Номер поезда не может быть пустым'
      retry
    rescue TrainErrors::NumberWrongFormat
      puts 'Неверный формат номера. Допустимые форматы: 23232, F3D-1D, DAG2F, 22-432 и т.д.'
      retry
    end

    company_name = @prompt.ask('Введите название компании:')
    train.company_name = company_name

    @trains << train

    wait_and_clear msg: "Поезд [#{train_name}] создан"
  end

  def routes_processing
    @exit_flag = true
    while @exit_flag
      @prompt.select('Выберите действие') do |menu|
        menu.choice 'Создать новый маршрут',      -> { create_new_route }, ({ disabled: '(станции не созданы)' } if @stations.empty?)
        menu.choice 'Добавить станции в маршрут', -> { add_way_stations_to_route }, ({ disabled: '(маршруты не созданы)' } if @routes.empty?)
        menu.choice 'Назад',                      -> { @exit_flag = false }
      end
    end

    wait_and_clear wait_for: 0
  end

  # rubocop:disable Metrics/CyclomaticComplexity

  def trains_processing
    return wait_and_clear msg: 'Поездов нет' if @trains.empty?

    choices = @trains.map { |s| { name: s.number, value: s } }
    train   = @prompt.select('Выберите поезд', choices)

    @exit_flag = true
    while @exit_flag
      @prompt.select('Выберите действие') do |menu|
        menu.choice 'Назначить маршрут',      -> { assign_route_to train: train }, ({ disabled: '(маршруты не созданы)' } if @routes.empty?)
        menu.choice 'Начать движение вперед', -> { move_ahead train: train }, ({ disabled: '(маршрут не назначен)' } unless train.route_present?)
        menu.choice 'Начать движение назад',  -> { move_back train: train }, ({ disabled: '(маршрут не назначен)' } unless train.route_present?)
        menu.choice 'Добавить вагон',         -> { add_carriage(train: train) }
        menu.choice 'Удалить вагон',          -> { remove_carriage(train: train) }, ({ disabled: '(вагонов нет)' } unless train.carriages_present?)
        menu.choice 'Назад',                  -> { @exit_flag = false }
      end
    end

    wait_and_clear wait_for: 0
  end

  # rubocop:enable Metrics/CyclomaticComplexity

  def add_carriage(train:)
    choices = [
      { name: 'Пассажирский', value: PassengerCarriage },
      { name: 'Грузовой',     value: CargoCarriage },
      { name: 'Назад',        value: nil }
    ]
    choices[0].merge!(disabled: '(недоступен для данного типа поезда)') unless train.is_a? PassengerTrain
    choices[1].merge!(disabled: '(недоступен для данного типа поезда)') unless train.is_a? FreightTrain
    carriage_type = @prompt.select('Выберите тип вагона', choices)

    return wait_and_clear wait_for: 0 if carriage_type.nil?

    carriage_name = @prompt.ask('Введите название вагона:')
    train.add_carriage(carriage_type.new(carriage_name))
    wait_and_clear msg: "Вагон [#{carriage_name} добавлен]"
  end

  def remove_carriage(train:)
    choices  = train.carriages.map { |carriage| { name: carriage.name, value: carriage } }
    carriage = @prompt.select('Выберите вагон для удаления', choices)

    train.remove_carriage(carriage)

    wait_and_clear msg: "Вагон [#{carriage.name} удален]"
  end

  def assign_route_to(train:)
    choices  = @routes.map { |route| { name: route.name, value: route } }
    route    = @prompt.select('Выберите маршрут', choices)
    train.assign_route route

    wait_and_clear msg: 'Маршрут назначен'
  end

  def move_ahead(train:)
    return wait_and_clear msg: 'Поезд находится на конечной станции' if train.next_station.nil?

    wait_and_clear msg: "Поезд движется к станции #{train.next_station.name}"
    train.speed_up
    train.move_ahead
    train.brake
  end

  def move_back(train:)
    return wait_and_clear msg: 'Поезд находится на начальной станции' if train.previous_station.nil?

    wait_and_clear msg: "Поезд движется к станции #{train.previous_station.name}"
    train.speed_up
    train.move_back
    train.brake
  end

  def create_new_route
    return wait_and_clear msg: 'Станций нет' if @stations.empty?

    choices       = @stations.map { |s| { name: s.name, value: s } }
    start_station = @prompt.select('Выберите начальную станцию', choices)
    choices       = (@stations - [start_station]).map { |s| { name: s.name, value: s } }
    end_station   = @prompt.select('Выберите конечную станцию', choices)
    route_name    = @prompt.ask('Введите название маршрута')

    @routes << Route.new(name: route_name,
                         start_station: start_station,
                         end_station: end_station)

    wait_and_clear msg: "Маршрут #{route_name} создан"
  end

  def add_way_stations_to_route
    choices  = @routes.map { |route| { name: route.name, value: route } }
    route    = @prompt.select('Выберите маршрут', choices)
    stations = @stations - ([route.start_station, route.end_station] + route.way_stations)
    return wait_and_clear msg: 'Все станции уже добавлены' if stations.empty?

    choices  = stations.map { |s| { name: s.name, value: s } }
    stations = @prompt.multi_select('Выберите станции', choices)
    stations&.each { |station| route.add_way_station station }

    msg = stations.empty? ? 'Вы не выбрали станции' : 'Станции добавлены'
    wait_and_clear msg: msg
  end

  def railway_state_info
    puts '=== Станции и поезда'
    @stations.each do |station|
      formatted_str = [
        "Станция: [#{station.name}]".ljust(50),
        "Поезда: #{station.trains&.map(&:number)&.join(', ')}"
      ].join('')

      puts formatted_str
    end

    puts "\n=== Поезда"
    @trains.each do |train|
      formatted_str = [
        "Поезд [#{train.number}]".ljust(25),
        "Компания - производитель: #{train.company_name}".ljust(40),
        "Маршрут: #{train.route&.name}".ljust(25),
        "Текущая станция: #{train.current_station&.name}".ljust(35),
        "Вагоны: #{train.carriages&.map(&:name)&.join(', ')}"
      ].join('')

      puts formatted_str
    end

    @prompt.keypress "\nДля выхода нажмите любую клавишу..."
    wait_and_clear wait_for: 0
  end

  def wait_and_clear(wait_for: 1, msg: '')
    puts msg
    sleep wait_for
    system 'clear'
  end

  def complete_main_menu_loop
    wait_and_clear msg: 'Завершение программы'
    abort
  end
end

# rubocop:enable Metrics/AbcSize
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/MethodLength

RailwayConsoleClient.new.run_main_menu_loop
