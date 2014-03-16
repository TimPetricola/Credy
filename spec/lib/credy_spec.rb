require_relative '../spec_helper'

describe Credy::CreditCard do

  subject { Credy::CreditCard }

  let(:rules) do
    {
      'visa' => {
        'length' => [13, 16],
        'countries' => {
          'ch' => '404159',
          'au' => ['401795', '404137']
        }
      },
      'mastercard' => {
        'length' => 16,
        'countries' => {
          'au' => '401795',
          'us' => ['504837', '510875']
        }
      },
    }
  end

  before(:each) do
    Credy::Rules.stub(:raw).and_return rules
  end

  describe '.generate' do

    it 'returns a number, type and country' do
      expect(subject.generate[:number]).not_to be_nil
      expect(subject.generate[:type]).not_to be_nil
      expect(subject.generate[:country]).not_to be_nil
    end

    it 'accepts the :type option' do
      number = subject.generate type: 'visa'
      expect(number[:type]).to eq 'visa'
    end

    it 'accepts the :country option' do
      number = subject.generate country: 'ch'
      expect(number[:country]).to eq 'ch'
    end

    it 'accepts several options at the same time' do
      number = subject.generate type: 'mastercard', country: 'au'
      expect(number[:type]).to eq 'mastercard'
      expect(number[:country]).to eq 'au'
    end

    it 'generates the right number of digits' do
      number = subject.generate type: 'mastercard'
      expect(number[:number].length).to be 16
    end

    it 'generate a number with the right prefix' do
      number = subject.generate type: 'mastercard', country: 'au'
      expect(number[:number]).to match /^401795/
    end

    it 'returns nil if nothing is found' do
      number = subject.generate type: 'foo', country: 'bar'
      expect(number).to be_nil
    end

  end

  describe '.infos' do

    it 'returns the correct information according to the card number' do
      infos = subject.infos '5108756163954792'
      expect(infos[:type]).to eq 'mastercard'
      expect(infos[:country]).to eq 'us'
    end

  end

  describe '.validate' do

    it 'returns a hash' do
      r = subject.validate '5108756163954792'
      expect(r[:valid]).to be_true
      expect(r[:details][:luhn]).to be_true
      expect(r[:details][:type]).to be_true
    end

    it 'checks against luhn algorithm' do
      r = subject.validate '5108756163954791'
      expect(r[:valid]).to be_false
      expect(r[:details][:luhn]).to be_false
    end

    it 'checks against card type' do
      r = subject.validate '99999999999999999999992'
      expect(r[:valid]).to be_false
      expect(r[:details][:type]).to be_false
    end

  end

end
