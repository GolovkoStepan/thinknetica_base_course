# frozen_string_literal: true

# rubocop:disable Style/AsciiComments

# Идеальный вес.
# Программа запрашивает у пользователя имя и рост и выводит идеальный вес
# по формуле (<рост> - 110) * 1.15, после чего выводит результат пользователю
# на экран с обращением по имени. Если идеальный вес получается отрицательным,
# то выводится строка "Ваш вес уже оптимальный"

# rubocop:enable Style/AsciiComments

puts 'Ввведите ваше имя:'
user_name = gets.chomp

puts 'Ввведите ваш рост:'
height = gets.chomp.to_i

# formula
result = (height - 110) * 1.15

if result.positive?
  puts(format("#{user_name}, Ваш идеальный вес: %<result>.1f", result: result))
else
  puts("#{user_name}, Ваш вес уже оптимальный.")
end