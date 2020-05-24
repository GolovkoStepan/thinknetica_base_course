# frozen_string_literal: true

# rubocop:disable Style/AsciiComments
# rubocop:disable Layout/LineLength

# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
# (Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)

MONTHS_DAY_COUNTS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31].freeze

# Метод определения високосного года
def year_leap?(year)
  return false unless (year % 4).zero?

  !((year % 100).zero? && year % 400 != 0)
end

# Получаем данные для расчетов
puts 'Введите день:'
day = gets.chomp.to_i

puts 'Введите месяц:'
mouth = gets.chomp.to_i

puts 'Введите год:'
year = gets.chomp.to_i

# Получаем кол-во дней за месяцы до указанного + указанный день
days_count = MONTHS_DAY_COUNTS[0..mouth - 2].sum + day

# Добавляем день, если год - високосный
days_count += 1 if mouth > 2 && year_leap?(year)

# Выводим на экран результат расчетов
puts "Порядковый номер даты: #{days_count}"

# rubocop:enable Style/AsciiComments
# rubocop:enable Layout/LineLength
