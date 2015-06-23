require_relative '../../spec_helper'

describe Credy::Rules do
  subject { Credy::Rules }

  describe '.raw' do
    it { should respond_to :raw }

    it 'is a hash' do
      expect(subject.raw).to be_a Hash
    end
  end

  describe '.all' do
    it 'is a array' do
      expect(subject.all).to be_a Array
    end

    it 'contains a set of rules' do
      allow(subject).to receive(:raw).and_return({
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
      allow(subject).to receive(:raw).and_return({
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
      allow(subject).to receive(:raw).and_return({
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
      allow(subject).to receive(:raw).and_return({
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
      allow(subject).to receive(:raw).and_return({
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
      expect(subject.filter(type: 'visa').length).to eq 2
      expect(subject.filter(type: 'mastercard').length).to eq 1
    end

    it 'accepts the :country option' do
      expect(subject.filter(country: 'ch').length).to eq 1
      expect(subject.filter(country: 'au').length).to eq 2
    end

    it 'accepts several options at the same time' do
      rules = subject.filter type: 'visa', country: 'au'
      expect(rules.length).to eq 1
    end

    it 'returns an empty array if nothing is found' do
      rules = subject.filter type: 'foo', country: 'bar'
      expect(rules).to be_a Array
      expect(rules).to be_empty
    end
  end
end
