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
    Credy::Rules.stub(:all).and_return rules
  end

  describe '.generate' do 

    it 'returns a number, type and country' do
      subject.generate[:number].should_not be_nil
      subject.generate[:type].should_not be_nil
      subject.generate[:country].should_not be_nil
    end

    it 'accepts the :type option' do
      number = subject.generate type: 'visa'
      number[:type].should == 'visa'
    end

    it 'accepts the :country option' do
      number = subject.generate country: 'ch'
      number[:country].should == 'ch'
    end

    it 'accepts several options at the same time' do
      number = subject.generate type: 'mastercard', country: 'au'
      number[:type].should == 'mastercard'
      number[:country].should == 'au'
    end

    it 'generates the right number of digits' do
      number = subject.generate type: 'mastercard'
      number[:number].length.should == 16
    end

    it 'generate a number with the right prefix' do
      number = subject.generate type: 'mastercard', country: 'au'
      number[:number].should =~ /^401795/
    end

    it 'returns nil if nothing is found' do
      number = subject.generate type: 'foo', country: 'bar'
      number.should be_nil
    end

  end

  describe '.validate' do

    it 'returns the correct information according to the card number' do
      infos = subject.validate '5108756163954799'
      infos[:type].should == 'mastercard'
      infos[:country].should == 'us'
    end

  end

end