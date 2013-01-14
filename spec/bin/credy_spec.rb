require_relative '../spec_helper'

silent { load 'bin/credy' }

describe Credy::CLI do

  before :all do
    @stdout = $stdout
    $stdout = StringIO.new
  end

  describe 'generate' do

    it 'works without options' do
      Credy::CreditCard.should_receive(:number).with({})
      r = Credy::CLI.start ['generate']
    end

    it '--country' do 
      Credy::CreditCard.should_receive(:number).with(country: 'au').twice
      Credy::CLI.start ['generate', '--country', 'au']
      Credy::CLI.start ['generate', '-c', 'au']
    end

    it '--type' do 
      Credy::CreditCard.should_receive(:number).with(type: 'visa').twice
      Credy::CLI.start ['generate', '--type', 'visa']
      Credy::CLI.start ['generate', '-t', 'visa']
    end

    it '--number' do
      Credy::CreditCard.should_receive(:number).exactly(20).and_return({number: '50076645747856835'})
      Credy::CLI.start ['generate', '--number', 10]
      Credy::CLI.start ['generate', '-n', 10]
    end

    describe 'result' do

      before :all do
        $stdout = @stdout
      end

      it 'stops if no number is found' do
        Credy::CreditCard.should_receive(:number).once.and_return(nil)
        STDOUT.should_receive(:puts).with('No rule found for those criteria.').once
        Credy::CLI.start ['generate', '-n', 10]
      end

      describe '--details' do
        before do
          number = {number: '50076645747856835', type: 'visa', country: 'au'}
          Credy::CreditCard.should_receive(:number).any_number_of_times.and_return number
        end

        it 'only returns the number' do
          STDOUT.should_receive(:puts).with('50076645747856835').once
          Credy::CLI.start ['generate']
        end

        it 'accepts to return more details' do
          STDOUT.should_receive(:puts).with('50076645747856835 (visa, au)').twice
          Credy::CLI.start ['generate', '--details']
          Credy::CLI.start ['generate', '-d']
        end
      end

    end

  end

end