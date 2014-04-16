require 'spec_helper'

describe Glman::Commands::Config do
  subject{ described_class.new(config_manager: config_manager) }
  let(:config_manager) { double('config_manager') }

  describe '#show_configuration' do
    let(:msg_no_configuration_yet) { 'No configuration yet' }

    it 'should display message no_configuration_yet when configuration missing' do
      config_manager.should_receive(:get).and_return({})
      Glman::DataPresenter.should_receive(:show).with(msg_no_configuration_yet, {})
      subject.show_configuration
    end
  end
end