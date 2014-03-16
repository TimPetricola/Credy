require_relative '../../spec_helper'

describe Credy::Rules do

  subject { Credy::Rules }

  describe '.raw' do
    it { should respond_to :raw }
    its(:raw) { should be_a Hash }
  end

  describe '.all' do

    its(:all) { should be_a Array }

    it 'contains a set of rules' do
      subject.stub(:raw).and_return({
        'visa' => {
          'length' => [13, 16],
          'countries' => {
            'ch' => '404159',
            'au' => '401795'
          }
        },
        'mastercard' => {
          'length' => 16,
          'prefix' => '51'
        }
      })

      expect(subject.all).to eq [
        {prefix:"404159", length:[13, 16], type:"visa", country:"ch"},
        {prefix:"401795", length:[13, 16], type:"visa", country:"au"},
        {prefix:"51", length:16, type:"mastercard"}
      ]
    end

    it 'works with string prefixes' do
      subject.stub(:raw).and_return({
        'visa' => {
          'length' => [13, 16],
          'countries' => {
            'au' => '401795'
          }
        }
      })

      expect(subject.all).to eq [
        {prefix:"401795", length:[13, 16], type:"visa", country:"au"}
      ]
    end

    it 'works with integer prefixes' do
      subject.stub(:raw).and_return({
        'visa' => {
          'length' => [13, 16],
          'countries' => {
            'au' => 401795
          }
        }
      })

      expect(subject.all).to eq [
        {prefix:"401795", length:[13, 16], type:"visa", country:"au"}
      ]
    end

    it 'works with an array of prefixes' do
      subject.stub(:raw).and_return({
        'visa' => {
          'length' => [13, 16],
          'countries' => {
            'au' => ['401795', '404137']
          }
        }
      })

      expect(subject.all).to eq [
        {prefix:"401795", length:[13, 16], type:"visa", country:"au"},
        {prefix:"404137", length:[13, 16], type:"visa", country:"au"}
      ]
    end

  end

  describe '.filter' do

    before do
      subject.stub(:raw).and_return({
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
    end

    it { should respond_to :filter }

    it 'returns everything if no filter is provided' do
      expect(subject.filter).to be_a Array
      expect(subject.filter).to eq subject.all
    end

    it 'filters by type' do
      expect(subject.filter(type: 'visa')).to have(2).items
      expect(subject.filter(type: 'mastercard')).to have(1).item
    end

    it 'accepts the :country option' do
      expect(subject.filter(country: 'ch')).to have(1).item
      expect(subject.filter(country: 'au')).to have(2).items
    end

    it 'accepts several options at the same time' do
      rules = subject.filter type: 'visa', country: 'au'
      expect(rules).to have(1).item
    end

    it 'returns an empty array if nothing is found' do
      rules = subject.filter type: 'foo', country: 'bar'
      expect(rules).to be_a Array
      expect(rules).to be_empty
    end

  end

end
