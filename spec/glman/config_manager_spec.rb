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
    it 'raise ConfigSetError when argument is not a hash kind' do
      -> { subject.set('bad_arg') }.should raise_error Glman::ConfigManager::SetConfigError
    end

    describe 'raise BaseConfigValidationError when base configuration is missing' do
      it 'gitlab key missing' do
        subject.should_receive(:get).and_return({})
        msg = 'gitlab key missing'
        -> { subject.set({}) }.should raise_error Glman::ConfigManager::BaseConfigValidationError, msg
      end

      it 'gitlab#private_token key missing' do
        subject.should_receive(:get).and_return({gitlab: {}})
        msg = 'gitlab#private_token key missing'
        -> { subject.set({}) }.should raise_error Glman::ConfigManager::BaseConfigValidationError, msg
      end

      it 'gitlab#url key missing' do
        subject.should_receive(:get).and_return({gitlab: {private_token: 'token'}})
        msg = 'gitlab#url key missing'
        -> { subject.set({}) }.should raise_error Glman::ConfigManager::BaseConfigValidationError, msg
      end
    end

    describe 'save' do
      let(:config)         {{gitlab: {private_token: 'token', url:'test'}}}
      let(:new_setting)    {{new_key: 'test_val'}}
      let(:updated_config) {config.merge(new_setting)}

      it 'updated configuration' do
        subject.should_receive(:get).and_return(config)
        subject.should_receive(:save_configuration).with(updated_config)
        subject.set(new_setting)
      end
    end
  end
end