require 'spec_helper'

describe Glman::Commands::Configs::GitlabConfig do
  subject{ described_class.new(config_manager: config_manager) }
  let(:config_manager) { double('config_manager') }

  describe '#set' do
    context 'error' do
      it 'should raise GitlabConfigurationError when data is not Hash' do
        msg = 'incorrect data'
        -> {subject.set('bad')}.should raise_error(described_class::GitlabConfigurationError, msg)
      end

      it 'should raise GitlabConfigurationError when url is incorrect' do
        msg = 'url is incorrect'
        -> {subject.set(url: '@')}.should raise_error(described_class::GitlabConfigurationError, msg)
      end

      it 'should raise GitlabConfigurationError when private_token missing' do
        msg = 'private_token missing'
        -> {subject.set(url: 'http://test.com')}.should raise_error(described_class::GitlabConfigurationError, msg)
        -> {subject.set(url: 'http://test.com', private_token: '  ')}.should raise_error(described_class::GitlabConfigurationError, msg)
      end

    end

    context 'successed' do
      before(:each) {config_manager.should_receive(:set).with({ gitlab: set_gitlab })}
      let(:set_gitlab) {{url: 'http://localhost', private_token: '1234'}}

      it 'should set new gitlab' do
        subject.set(set_gitlab)
      end
    end
  end

  describe '#get' do
    before(:each) {config_manager.should_receive(:get).and_return(get_gitlab)}
    let(:current_config) {{url: 'http://localhost', private_token: '1234'}}
    let(:get_gitlab)     {{gitlab: current_config}}

    it 'should receive current gitlab' do
      subject.get.should eq current_config
    end

    context 'when configuration is empty' do
      let(:current_config) {Glman::Commands::Configs::GitlabConfig::DEFAULT}

      it 'should receive default gitlab' do
        subject.get.should eq current_config
      end
    end
  end

  describe '#clear' do
    before(:each) {config_manager.should_receive(:set).with({ gitlab: set_gitlab })}
    let(:set_gitlab) { Glman::Commands::Configs::GitlabConfig::DEFAULT }

    it 'should set to default' do
      subject.clear
    end
  end
end
