require_relative '../spec_helper'

describe Credy::CreditCard do

  subject { Credy::CreditCard }

  describe '.number' do 

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

    before do
      Credy::Rules.stub(:all).and_return rules
    end

    it 'returns a number, type and country' do
      subject.number[:number].should_not be_nil
      subject.number[:type].should_not be_nil
      subject.number[:country].should_not be_nil
    end

    it 'accepts the :type option' do
      number = subject.number type: 'visa'
      number[:type].should == 'visa'
    end

    it 'accepts the :country option' do
      number = subject.number country: 'ch'
      number[:country].should == 'ch'
    end

    it 'accepts several options at the same time' do
      number = subject.number type: 'mastercard', country: 'au'
      number[:type].should == 'mastercard'
      number[:country].should == 'au'
    end

    it 'returns nil if nothing is found' do
      number = subject.number type: 'foo', country: 'bar'
      number.should be_nil
    end

  end

end