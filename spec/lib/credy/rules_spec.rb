require_relative '../../spec_helper'

describe Credy::Rules do

  subject { Credy::Rules }

  describe '.flatten' do

    it 'flattens a rules hash' do
      subject.stub(:all).and_return({
        'visa' => {
          'length' => [13, 16],
          'countries' => {
            'ch' => '404159',
            'au' => '401795'
          }
        },
        'mastercard' => {
          'length' => 16,
          'countries' => {
            'au' => '401795'
          }
        },
      })

      subject.flatten.should == [
        {:prefix=>"404159", :length=>[13, 16], :type=>"visa", :country=>"ch"},
        {:prefix=>"401795", :length=>[13, 16], :type=>"visa", :country=>"au"},
        {:prefix=>"401795", :length=>16, :type=>"mastercard", :country=>"au"}
      ]
    end

    it 'works with string prefixes' do
      subject.stub(:all).and_return({
        'visa' => {
          'length' => [13, 16],
          'countries' => {
            'au' => '401795'
          }
        }
      })

      subject.flatten.should == [
        {:prefix=>"401795", :length=>[13, 16], :type=>"visa", :country=>"au"}
      ]
    end

    it 'works with integer prefixes' do
      subject.stub(:all).and_return({
        'visa' => {
          'length' => [13, 16],
          'countries' => {
            'au' => 401795
          }
        }
      })

      subject.flatten.should == [
        {:prefix=>"401795", :length=>[13, 16], :type=>"visa", :country=>"au"}
      ]
    end

    it 'works with an array of prefixes' do
      subject.stub(:all).and_return({
        'visa' => {
          'length' => [13, 16],
          'countries' => {
            'au' => ['401795', '404137']
          }
        }
      })

      subject.flatten.should == [
        {:prefix=>"401795", :length=>[13, 16], :type=>"visa", :country=>"au"},
        {:prefix=>"404137", :length=>[13, 16], :type=>"visa", :country=>"au"}
      ]
    end

  end

end