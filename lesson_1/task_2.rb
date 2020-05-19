# frozen_string_literal: true

# rubocop:disable Style/AsciiComments

# Площадь треугольника.
# Площадь треугольника можно вычислить, зная его
# основание (a) и высоту (h) по формуле: 1/2*a*h.
# Программа должна запрашивать основание и высоту
# треугольника и возвращать его площадь

# rubocop:enable Style/AsciiComments

puts 'Введите основание треугольника:'
base = gets.chomp.to_i

puts 'Введите высоту треугольника:'
height = gets.chomp.to_i

# formula
result = 1.0 / 2 * base * height

puts "Площадь треугольника равна: #{result}"