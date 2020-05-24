# frozen_string_literal: true

# rubocop:disable Style/AsciiComments
# rubocop:disable Layout/LineLength

# Сумма покупок. Пользователь вводит поочередно название товара, цену за единицу
# и кол-во купленного товара (может быть нецелым числом). Пользователь может
# ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в
# качестве названия товара.

# На основе введенных данных требуетеся:
# Заполнить и вывести на экран хеш, ключами которого являются названия товаров,
# а значением - вложенный хеш, содержащий цену за единицу товара и кол-во
# купленного товара. Также вывести итоговую сумму за каждый товар.
# Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".

user_purchases_info = {}

# Цикл для пользовательского ввода данных о покупках
loop do
  puts 'Введите название продукта:'
  product_name = gets.chomp
  break if product_name.downcase == 'стоп'

  puts 'Введите цену продукта:'
  product_price = gets.chomp.to_f

  puts 'Введите кол-во продукта:'
  product_count = gets.chomp.to_f

  user_purchases_info[product_name] = { price: product_price, count: product_count }
end

total_purchase_sum = 0

puts [('= ' * 20), 'Отчет о покупках', ('= ' * 20)].join(' ')

# Цикл формирования отчета о покупках пользователя
user_purchases_info.each do |key, value|
  purchase_sum = value[:price] * value[:count]
  total_purchase_sum += purchase_sum

  formatted_str = [
    key.ljust(25),
    "Цена: #{value[:price]}".ljust(20),
    "Кол-во: #{value[:count]}".ljust(20),
    format('Сумма: %<sum>.2f руб.', sum: purchase_sum).ljust(20)
  ].join(' | ')

  puts formatted_str
end

puts '= ' * 49
puts format('Итого: %<sum>.2f руб.', sum: total_purchase_sum)

# rubocop:enable Style/AsciiComments
# rubocop:enable Layout/LineLength
