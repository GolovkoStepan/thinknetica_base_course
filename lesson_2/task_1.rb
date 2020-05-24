# frozen_string_literal: true

# rubocop:disable Style/AsciiComments

# Сделать хеш, содеращий месяцы и количество дней в месяце.
# В цикле выводить те месяцы, у которых количество дней ровно 30
MONTHS = {
  'Январь' => 31,
  'Февраль' => 28,
  'Март' => 31,
  'Апрель' => 30,
  'Май' => 31,
  'Июнь' => 30,
  'Июль' => 31,
  'Август' => 31,
  'Сентябрь' => 30,
  'Октябрь' => 31,
  'Ноябрь' => 30,
  'Декабрь' => 31
}.freeze

MONTHS.each { |key, value| puts key if value == 30 }

# Заполнить массив числами от 10 до 100 с шагом 5
index = 10
arr = []

while index < 100
  arr << index
  index += 5
end

puts arr.inspect

# Заполнить массив числами фибоначчи до 100

# Это классический способ получения числа Фибоначчи рекурсией.
# Лаконичный, но не опитмальный.
# def fib_num(num)
#   num < 3 ? 1 : fib_num(num - 1) + fib_num(num - 2)
# end

# Более оптимальный вариант с циклом
def fib_num(num)
  el_one = 1
  el_two = 1
  index = 0

  while index < num - 2
    sum = el_one + el_two
    el_one = el_two
    el_two = sum
    index += 1
  end

  el_two
end

# Тут, конечно, можно использовать итератор map вместо each.
# Но такой способ мне кажется более наглядным
arr = (1..100).each_with_object([]) { |i, a| a << fib_num(i) }
puts arr.inspect

# Заполнить хеш гласными буквами, где значением будет
# являтся порядковый номер буквы в алфавите (a - 1).
VOWELS = %w[а е ё и о у ы э ю я].freeze

hash = ('а'..'я').each_with_object({}).with_index do |(letter, h), i|
  h[letter] = i if VOWELS.include? letter
end

# В данном решении не все корректно, так как буква ё отсутвтует в
# массиве, полученным с помощью диапазона ('а'..'я'), но если просто
# создать хеш с буквами и индексами - это как-то слижком просто кажется
puts hash.inspect

# rubocop:enable Style/AsciiComments
