require 'spec_helper'

describe Glman::Commands::Configs::NotifyIrcConfig do
  subject{ described_class.new(config_manager: config_manager) }
  let(:config_manager) { double('config_manager') }

  describe '#set' do
    before(:each){ config_manager.should_receive(:get).and_return(old_config) }

    let(:old_config) do
      {
        notify: {
          email: {some: 'test'},
          irc: old_irc_config
        }
      }
    end

    let(:old_irc_config) do
      {
        nick:    'glman_test',
        channel: 'test',
        server:  'irc.super.com',
        port:    9999,
        ssl:     false
      }
    end

    let(:set_part_config) {{ channel: 'test-new', port: 1234, ssl: false }}
    let(:set_full_config) do
      {
        nick:    'super_man',
        channel: 'heroses',
        server:  'irc.cool.com',
        port:    912,
        ssl:     true
      }
    end

    it 'should set part configuration' do
      config = old_irc_config.merge(set_part_config)
      config_manager.should_receive(:set).with(notify: { email: {some: 'test'}, irc: config})
      subject.set(set_part_config)
    end

    it 'should set full configuration' do
      config_manager.should_receive(:set).with(notify: { email: {some: 'test'}, irc: set_full_config})
      subject.set(set_full_config)
    end
  end

  describe '#get' do
    before(:each) {config_manager.should_receive(:get).and_return(notify: {irc: current_config})}
    let(:current_config) do
      {
        nick:    'glman_test',
        channel: 'test',
        server:  'irc.super.com',
        port:    9999,
        ssl:     false
      }
    end

    it 'should receive current itc configuration' do
      subject.get.should eq current_config
    end

    context 'when configuration is empty' do
      let(:current_config) {Glman::Commands::Configs::NotifyIrcConfig::DEFAULT}

      it 'should receive default users' do
        subject.get.should eq current_config
      end
    end
  end

  describe '#clear' do
    before(:each) do
      config_manager.should_receive(:set).with({ notify: {irc: new_config} })
      config_manager.should_receive(:get).and_return({})
    end

    let(:new_config) { Glman::Commands::Configs::NotifyIrcConfig::DEFAULT }

    it 'should set users to default' do
      subject.clear
    end
  end
end
