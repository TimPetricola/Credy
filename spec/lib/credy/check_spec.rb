require_relative '../../spec_helper'

describe Credy::Check do
  describe '.luhn' do
    it 'returns true for correct data' do
      expect(Credy::Check.luhn(49927398716)).to be_truthy
      expect(Credy::Check.luhn(1234567812345670)).to be_truthy
    end

    it 'returns false for non correct data' do
      expect(Credy::Check.luhn(49927398717)).to be_falsey
      expect(Credy::Check.luhn(1234567812345678)).to be_falsey
    end
  end
end
