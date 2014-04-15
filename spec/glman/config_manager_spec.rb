require 'spec_helper'

describe Glman::ConfigManager do

  # subject { described_class.new }
  let(:config_file) { double('config_file') }
  let(:config)      { nil }

  before(:each) do
    subject.stub(:config_file).and_return(config_file)
    File.stub(:exist?).and_return(true)
    YAML.stub(:load_file).and_return(config)
  end

  describe '#get' do
    describe 'returns empty hash' do
      it 'when config file missing' do
        File.stub(:exist?).and_return(false)
        subject.get.should eq({})
      end

      it 'when raise error on configuration loading' do
        YAML.stub(:load_file).and_return('bad_data')

        subject.get.should eq({})
      end
    end

    describe 'returns configuration as hash' do
      let(:config) {{ 'test' => 'works' }}
      it 'when present' do
        subject.get.should eq config
      end
    end
  end

  describe '#set' do

  end
end