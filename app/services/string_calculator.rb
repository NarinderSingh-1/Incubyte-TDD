# frozen_string_literal: true

# app/services/string_calculator.rb
class StringCalculator
  def self.add(numbers)
    return 0 if numbers.empty?

    delimiters = [',']
    if numbers.start_with?('//')
      delimiter_spec, numbers = numbers.split("\n", 2)
      delimiters = parse_delimiters(delimiter_spec)
    end

    # Replace newlines with the first delimiter for initial splitting
    numbers = numbers.gsub("\n", delimiters[0])
    num_array = numbers.split(Regexp.union(delimiters)).map(&:to_i)

    # Filter out numbers greater than 1000
    num_array.reject! { |n| n > 1000 }

    negatives = num_array.select(&:negative?)
    raise "negative numbers not allowed: #{negatives.join(', ')}" if negatives.any?

    num_array.sum
  end

  private

  def self.parse_delimiters(delimiter_spec)
    if delimiter_spec.start_with?('//[')
      delimiter_spec.scan(/\[(.*?)\]/).flatten
    else
      [delimiter_spec[2]]
    end
  end
end
