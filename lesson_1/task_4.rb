# frozen_string_literal: true

# rubocop:disable Style/AsciiComments
# rubocop:disable Layout/LineLength

# Квадратное уравнение.
# Пользователь вводит 3 коэффициента a, b и с.
# Программа вычисляет дискриминант (D) и корни
# уравнения (x1 и x2, если они есть) и выводит значения
# дискриминанта и корней на экран. При этом возможны следующие варианты:
#   Если D > 0, то выводим дискриминант и 2 корня
#   Если D = 0, то выводим дискриминант и 1 корень (т.к. корни в этом случае равны)
#   Если D < 0, то выводим дискриминант и сообщение "Корней нет"

def find_discriminant(co_a:, co_b:, co_c:)
  co_b * co_b - 4 * (co_a * co_c)
end

def find_roots(discriminant:, co_a:, co_b:)
  if discriminant.positive?
    discriminant_sqrt = Math.sqrt(discriminant)

    [((-co_b + discriminant_sqrt) / 2 * co_a),
     ((-co_b - discriminant_sqrt) / 2 * co_a)]
  elsif discriminant.zero?
    [(-co_b / 2 * co_a)]
  else
    []
  end
end

puts 'Введите значение коэффициента а:'
coefficient_a = gets.chomp.to_f

puts 'Введите значение коэффициента b:'
coefficient_b = gets.chomp.to_f

puts 'Введите значение коэффициента c:'
coefficient_c = gets.chomp.to_f

discriminant = find_discriminant(co_a: coefficient_a, co_b: coefficient_b, co_c: coefficient_c)
roots        = find_roots(discriminant: discriminant, co_a: coefficient_a, co_b: coefficient_b)

puts "Значение дискриминанта: #{discriminant}"

case roots.count
when 1
  puts "Корень: [#{roots.first}]"
when 2
  puts "Корни: #{roots.inspect}"
else
  puts 'Корней нет'
end


# rubocop:enable Style/AsciiComments
# rubocop:enable Layout/LineLength
