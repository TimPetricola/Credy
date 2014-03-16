require_relative '../spec_helper'

silent { load 'bin/credy' }

describe Credy::CLI do

  before :all do
    @stdout = $stdout
    $stdout = StringIO.new
  end

  describe 'generate' do

    it 'works without options' do
      expect(Credy::CreditCard).to receive(:generate).with({})
      r = Credy::CLI.start ['generate']
    end

    it '--country' do
      expect(Credy::CreditCard).to receive(:generate).with(country: 'au').twice
      Credy::CLI.start ['generate', '--country', 'au']
      Credy::CLI.start ['generate', '-c', 'au']
    end

    it '--type' do
      expect(Credy::CreditCard).to receive(:generate).with(type: 'visa').twice
      Credy::CLI.start ['generate', '--type', 'visa']
      Credy::CLI.start ['generate', '-t', 'visa']
    end

    it '--number' do
      expect(Credy::CreditCard).to receive(:generate).exactly(20).and_return({number: '50076645747856835'})
      Credy::CLI.start ['generate', '--number', 10]
      Credy::CLI.start ['generate', '-n', 10]
    end

    describe 'result' do

      before :all do
        $stdout = @stdout
      end

      it 'stops if no number is found' do
        expect(Credy::CreditCard).to receive(:generate).once.and_return(nil)
        expect(STDOUT).to receive(:puts).with('No rule found for those criteria.').once
        Credy::CLI.start ['generate', '-n', 10]
      end

      describe '--details' do
        before do
          number = {number: '50076645747856835', type: 'visa', country: 'au'}
          allow(Credy::CreditCard).to receive(:generate).and_return number
        end

        it 'only returns the number' do
          expect(STDOUT).to receive(:puts).with('50076645747856835').once
          Credy::CLI.start ['generate']
        end

        it 'accepts to return more details' do
          expect(STDOUT).to receive(:puts).with('50076645747856835 (visa, au)').twice
          Credy::CLI.start ['generate', '--details']
          Credy::CLI.start ['generate', '-d']
        end
      end

    end

  end

  describe 'infos' do

    it 'calls the infos function' do
      expect(Credy::CreditCard).to receive(:infos).with '5108756163954799'
      Credy::CLI.start ['infos', '5108756163954799']
    end

    describe 'result' do
      before :all do
        $stdout = @stdout
      end

      it 'shows error if nothing found' do
        expect(Credy::CreditCard).to receive(:infos).and_return nil
        expect(STDOUT).to receive(:puts).with 'No information available for this number.'
        Credy::CLI.start ['infos', '5108756163954799']
      end

      it 'shows the card informations' do
        number = {number: '50076645747856835', type: 'visa', country: 'au'}
        expect(Credy::CreditCard).to receive(:infos).at_least(1).times.and_return number
        expect(STDOUT).to receive(:puts).with 'Type: visa'
        expect(STDOUT).to receive(:puts).with 'Country: au'
        expect(STDOUT).to receive(:puts).with 'Valid'
        Credy::CLI.start ['infos', '50076645747856835']
      end
    end

  end

  describe 'validate' do
    it 'calls the validate function' do
      expect(Credy::CreditCard).to receive(:validate).with('5108756163954799').and_return({valid: false, details: {}})
      Credy::CLI.start ['validate', '5108756163954799']
    end

    describe 'result' do
      before :all do
        $stdout = @stdout
      end

      it 'shows card validity and details' do
        validity = { valid: true, details: { luhn: true, type: true} }
        expect(Credy::CreditCard).to receive(:validate).and_return validity
        expect(STDOUT).to receive(:puts).with 'This number is valid.'
        expect(STDOUT).to receive(:puts).with '(luhn: v, type: v)'
        Credy::CLI.start ['validate', '50076645747856835']
      end

       it 'shows card validity and details for invalid number' do
        validity = { valid: false, details: { luhn: false, type: false} }
        expect(Credy::CreditCard).to receive(:validate).and_return validity
        expect(STDOUT).to receive(:puts).with 'This number is not valid.'
        expect(STDOUT).to receive(:puts).with '(luhn: x, type: x)'
        Credy::CLI.start ['validate', '5108756163954799']
      end

    end
  end

end
