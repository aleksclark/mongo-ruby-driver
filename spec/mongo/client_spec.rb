require 'spec_helper'

describe Mongo::Client do

  describe '#[]' do

    let(:client) do
      described_class.new(['127.0.0.1:27017'])
    end

    shared_examples_for 'a collection switching object' do

      before do
        client.use(:dbtest)
      end

      it 'returns the new collection' do
        expect(collection.name).to eq('users')
      end
    end

    context 'when provided a string' do

      let(:collection) do
        client['users']
      end

      it_behaves_like 'a collection switching object'
    end

    context 'when provided a symbol' do

      let(:collection) do
        client[:users]
      end

      it_behaves_like 'a collection switching object'
    end

    context 'when a database has not been selected' do

      it 'raises an error' do
        expect do
          client[:users]
        end.to raise_error(Mongo::Client::NoDatabase)
      end
    end
  end

  describe '#initialize' do

    context 'when providing no options' do

      let(:client) do
        described_class.new(['127.0.0.1:27017'])
      end

      it 'sets the options to empty' do
        expect(client.options).to be_empty
      end

      it 'sets the cluster' do
        expect(client.cluster).to be_a(Mongo::Cluster)
      end
    end

    context 'when providing options' do

      context 'when no database is provided' do

        let(:client) do
          described_class.new(['127.0.0.1:27017'], :read => :secondary)
        end

        it 'sets the options on the client' do
          expect(client.options).to eq(:read => :secondary)
        end
      end

      context 'when a database is provided' do

        let(:client) do
          described_class.new(['127.0.0.1:27017'], :database => :testdb)
        end

        it 'sets the current database' do
          expect(client[:users].name).to eq('users')
        end
      end
    end
  end

  describe '#use' do

    let(:client) do
      described_class.new(['127.0.0.1:27017'])
    end

    shared_examples_for 'a database switching object' do

      it 'returns the new database' do
        expect(database.name).to eq('testdb')
      end
    end

    context 'when provided a string' do

      let(:database) do
        client.use('testdb')
      end

      it_behaves_like 'a database switching object'
    end

    context 'when provided a symbol' do

      let(:database) do
        client.use(:testdb)
      end

      it_behaves_like 'a database switching object'
    end
  end
end