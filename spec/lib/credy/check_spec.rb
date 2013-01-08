require_relative '../../spec_helper'

describe Credy::Check do

  describe '.luhn' do

    it 'returns true for correct data' do
      Credy::Check.luhn(49927398716).should be_true
      Credy::Check.luhn(1234567812345670).should be_true
    end

    it 'returns false for non correct data' do
      Credy::Check.luhn(49927398717).should be_false
      Credy::Check.luhn(1234567812345678).should be_false
    end

  end

end