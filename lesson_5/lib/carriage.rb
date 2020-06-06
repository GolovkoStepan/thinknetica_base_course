# frozen_string_literal: true

require_relative 'common/company'

# rubocop:disable Style/AsciiComments

# Класс "Вагон"
class Carriage
  include Common::Company

  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

# rubocop:enable Style/AsciiComments
