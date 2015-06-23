require_relative '../spec_helper'
silent { load 'bin/credy' }

describe Credy::CLI do
  before(:all) do
    @stdout, $stdout = $stdout, StringIO.new
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
      it 'stops if no number is found' do
        expect(Credy::CreditCard).to receive(:generate).once.and_return(nil)
        output = silent { Credy::CLI.start ['generate', '-n', 10] }
        expect(output).to eq "No rule found for those criteria.\n"
      end

      describe '--details' do
        before do
          number = {number: '50076645747856835', type: 'visa', country: 'au'}
          allow(Credy::CreditCard).to receive(:generate).and_return number
        end

        it 'only returns the number' do
          output = silent { Credy::CLI.start ['generate'] }
          expect(output).to eq "50076645747856835\n"
        end

        it 'accepts to return more details' do
          output = silent do
            Credy::CLI.start ['generate', '--details']
            Credy::CLI.start ['generate', '-d']
          end
          expect(output).to eq "50076645747856835 (visa, au)\n"*2
        end
      end
    end
  end

  describe 'infos' do
    it 'calls the infos function' do
      expect(Credy::CreditCard).to receive(:infos).with '5108756163954799'
      silent {
        Credy::CLI.start ['infos', '5108756163954799']
      }
    end

    describe 'result' do
      it 'shows error if nothing found' do
        expect(Credy::CreditCard).to receive(:infos).and_return nil
        output = silent { Credy::CLI.start ['infos', '5108756163954799'] }
        expect(output).to eq "No information available for this number.\n"
      end

      it 'shows the card informations' do
        number = {number: '50076645747856835', type: 'visa', country: 'au'}
        expect(Credy::CreditCard).to receive(:infos).at_least(1).times.and_return number
        output = silent { Credy::CLI.start ['infos', '50076645747856835'] }
        expect(output).to eq "Type: visa\nCountry: au\nValid\n"
      end
    end
  end

  describe 'validate' do
    it 'calls the validate function' do
      expect(Credy::CreditCard).to receive(:validate).with('5108756163954799').and_return({valid: false, details: {}})
      Credy::CLI.start ['validate', '5108756163954799']
    end

    describe 'result' do
      it 'shows card validity and details' do
        validity = { valid: true, details: { luhn: true, type: true} }
        expect(Credy::CreditCard).to receive(:validate).and_return validity
        output = silent { Credy::CLI.start ['validate', '50076645747856835'] }
        expect(output).to eq "This number is valid.\n(luhn: v, type: v)\n"
      end

       it 'shows card validity and details for invalid number' do
        validity = { valid: false, details: { luhn: false, type: false} }
        expect(Credy::CreditCard).to receive(:validate).and_return validity
        output = silent { Credy::CLI.start ['validate', '5108756163954799'] }
        expect(output).to eq "This number is not valid.\n(luhn: x, type: x)\n"
      end
    end
  end
end
