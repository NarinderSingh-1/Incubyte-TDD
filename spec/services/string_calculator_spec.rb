# frozen_string_literal: true

# spec/services/string_calculator_spec.rb
require 'rails_helper'

RSpec.describe StringCalculator do
  describe '.add' do
    context 'basic functionality' do
      it 'returns 0 for an empty string' do
        expect(StringCalculator.add('')).to eq(0)
      end

      it 'returns the number itself when only one number is provided' do
        expect(StringCalculator.add('5')).to eq(5)
      end

      it 'returns the sum of two numbers' do
        expect(StringCalculator.add('1,2')).to eq(3)
      end

      it 'handles any amount of numbers' do
        expect(StringCalculator.add('1,4,2,5,3,6')).to eq(21)
      end
    end

    context 'handles new lines' do
      it 'handles new lines between numbers (instead of commas)' do
        expect(StringCalculator.add("1\n2,3")).to eq(6)
      end
    end

    context 'negative numbers' do
      it 'raises an exception for negative numbers' do
        expect { StringCalculator.add('1,-2,3') }.to raise_error('negative numbers not allowed: -2')
      end

      it 'shows all negative numbers in the exception message' do
        expect { StringCalculator.add('1,-2,-3') }.to raise_error('negative numbers not allowed: -2, -3')
      end
    end

    context 'custom delimiters' do
      it 'supports different delimiters' do
        expect(StringCalculator.add("//;\n1;2")).to eq(3)
      end

      it 'supports delimiters of any length' do
        expect(StringCalculator.add("//[***]\n1***2***3")).to eq(6)
      end

      it 'supports multiple delimiters' do
        expect(StringCalculator.add("//[*][%]\n1*2%3")).to eq(6)
      end

      it 'supports multiple delimiters with length longer than one character' do
        expect(StringCalculator.add("//[***][%%]\n1***2%%3")).to eq(6)
      end
    end

    it 'ignores numbers greater than 1000' do
      expect(StringCalculator.add('2,1001')).to eq(2)
      expect(StringCalculator.add('5,1501')).to eq(5)
    end
  end
end
