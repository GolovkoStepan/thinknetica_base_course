# frozen_string_literal: true

# rubocop:disable Style/AsciiComments
# rubocop:disable Layout/LineLength

# Прямоугольный треугольник.
# Программа запрашивает у пользователя 3 стороны треугольника и
# определяет, является ли треугольник прямоугольным
# (используя теорему Пифагора www-formula.ru), равнобедренным
# (т.е. у него равны любые 2 стороны)  или равносторонним (все 3 стороны равны)
# и выводит результат на экран. Подсказка: чтобы воспользоваться теоремой
# Пифагора, нужно сначала найти самую длинную сторону (гипотенуза) и сравнить
# ее значение в квадрате с суммой квадратов двух остальных сторон. Если
# все 3 стороны равны, то треугольник равнобедренный и равносторонний,
# но не прямоугольный.

# равнобедренный
def isosceles_triangle?(a_side, b_side, c_side)
  b_side == c_side || a_side == b_side || a_side == c_side
end

# равносторонний
def equilateral_triangle?(a_side, b_side, c_side)
  a_side == b_side && b_side == c_side
end

# прямоугольный
def right_triangle?(a_side, b_side, c_side)
  hypotenuse = [a_side, b_side, c_side].max
  cathetus   = [a_side, b_side, c_side].reject { |el| el == hypotenuse }

  hypotenuse * hypotenuse == cathetus.map { |el| el * el }.sum
end

puts 'Введите стороны треугольника'

puts 'Сторона A:'
a_side = gets.chomp.to_f

puts 'Сторона B:'
b_side = gets.chomp.to_f

puts 'Сторона C:'
c_side = gets.chomp.to_f

if equilateral_triangle?(a_side, b_side, c_side)
  puts 'Треугольник равносторонний и равнобедренный.'
  abort
end

puts 'Треугольник равнобедренный.' if isosceles_triangle?(a_side, b_side, c_side)
puts 'Треугольник прямоугольный.'  if right_triangle?(a_side, b_side, c_side)

# rubocop:enable Style/AsciiComments
# rubocop:enable Layout/LineLength
