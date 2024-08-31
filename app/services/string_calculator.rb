# frozen_string_literal: true

# app/services/string_calculator.rb
class StringCalculator
  def self.add(numbers)
    return 0 if numbers.empty?

    delimiter = ','
    if numbers.start_with?('//')
      delimiter = numbers[2]
      numbers = numbers[4..]
    end

    numbers = numbers.gsub("\n", delimiter)
    num_array = numbers.split(delimiter).map(&:to_i)
    negatives = num_array.select(&:negative?)
    raise "negative numbers not allowed: #{negatives.join(', ')}" if negatives.any?

    num_array.sum
  end
end
