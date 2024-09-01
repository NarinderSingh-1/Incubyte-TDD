# frozen_string_literal: true

# app/services/string_calculator.rb
class StringCalculator
  DEFAULT_DELIMITER = ','
  MAX_NUMBER = 1000

  def self.add(numbers)
    return 0 if numbers.empty?

    delimiters, numbers = extract_delimiters_and_numbers(numbers)
    num_array = split_numbers(numbers, delimiters)
    validate_numbers(num_array)

    num_array.sum
  end

  class << self
    private

    def extract_delimiters_and_numbers(numbers)
      if numbers.start_with?('//')
        delimiter_spec, numbers = numbers.split("\n", 2)
        delimiters = parse_delimiters(delimiter_spec)
      else
        delimiters = [DEFAULT_DELIMITER]
      end
      [delimiters, numbers]
    end

    def parse_delimiters(delimiter_spec)
      if delimiter_spec.start_with?('//[')
        delimiter_spec.scan(/\[(.*?)\]/).flatten
      else
        [delimiter_spec[2]]
      end
    end

    def split_numbers(numbers, delimiters)
      numbers.gsub("\n", delimiters[0])
             .split(Regexp.union(delimiters))
             .map(&:to_i)
             .reject { |n| n > MAX_NUMBER }
    end

    def validate_numbers(numbers)
      negatives = numbers.select(&:negative?)
      raise "negative numbers not allowed: #{negatives.join(', ')}" if negatives.any?
    end
  end
end
