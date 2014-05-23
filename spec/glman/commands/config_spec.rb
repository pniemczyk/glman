require 'spec_helper'

describe Glman::Commands::Config do
  subject{ described_class.new(config_manager: config_manager) }
  let(:config_manager) { double('config_manager') }

  describe '#show' do
    let(:msg_no_configuration_yet) { 'No configuration yet' }

    it 'should display message no_configuration_yet when configuration missing' do
      config_manager.should_receive(:get).and_return({})
      Glman::DataPresenter.should_receive(:show).with(msg_no_configuration_yet, {})
      subject.show
    end

    it 'should display message no_configuration_yet when nested configuration missing' do
      config_manager.should_receive(:get).and_return({ test: 'value' })
      Glman::DataPresenter.should_receive(:show).with(msg_no_configuration_yet, {})
      subject.show(['nested'])
    end

    it 'should display nested configuration when params present' do
      expected_conf = { a: 'b'}
      nested_conf   = { next_level: expected_conf  }
      config        = { test: nested_conf }
      config_manager.should_receive(:get).and_return(config)
      Glman::DataPresenter.should_receive(:show).with(expected_conf, {})
      subject.show(['test', 'next_level'])
    end

    it 'should display base configuration when params missing' do
      config = {test: 'test'}
      config_manager.should_receive(:get).and_return(config)
      Glman::DataPresenter.should_receive(:show).with(config, {})
      subject.show
    end
  end

  context 'gitlab' do
    let(:gitlab_conf)    { double('gitlab_conf') }
    before(:each) {subject.should_receive(:gitlab_conf).and_return(gitlab_conf)}

    it '#set' do
      value = { url: 'url', private_token:  'token' }
      gitlab_conf.should_receive(:set).with(value)
      subject.set(:gitlab, value)
    end

    it '#clear' do
      gitlab_conf.should_receive(:clear)
      subject.clear(:gitlab)
    end

    it '#get' do
      gitlab_conf.should_receive(:get)
      subject.get(:gitlab)
    end
  end

  context 'users' do
    let(:users_conf)    { double('users_conf') }
    before(:each) {subject.should_receive(:users_conf).and_return(users_conf)}

    it '#set' do
      value = { 'damian@o2.pl' => {id: 1} }
      users_conf.should_receive(:set).with(value)
      subject.set(:users, value)
    end

    it '#clear' do
      users_conf.should_receive(:clear)
      subject.clear(:users)
    end

    it '#get' do
      users_conf.should_receive(:get)
      subject.get(:users)
    end
  end

  context 'aliases' do
    let(:aliases_conf)    { double('aliases_conf') }
    before(:each) {subject.should_receive(:aliases_conf).and_return(aliases_conf)}

    it '#set' do
      value = {pn: 'pniemczyk@o2.pl'}
      aliases_conf.should_receive(:set).with(value)
      subject.set(:aliases, value)
    end

    it '#clear' do
      aliases_conf.should_receive(:clear)
      subject.clear(:aliases)
    end

    it '#get' do
      aliases_conf.should_receive(:get)
      subject.get(:aliases)
    end

    it '#delete' do
      aliases_conf.should_receive(:delete).with(:pn)
      subject.delete(:aliases, :pn)
    end

    it '#add' do
      value = {pn: 'pniemczyk@o2.pl'}
      aliases_conf.should_receive(:add).with(value)
      subject.add(:aliases, value)
    end
  end

  context 'irc_notify' do
    let(:irc_notify_conf)    { double('irc_notify_conf') }
    before(:each) {subject.should_receive(:irc_notify_conf).and_return(irc_notify_conf)}

    it '#set' do
      value = {
        nick:    'glman_test',
        channel: 'test',
        server:  'irc.super.com',
        port:    9999,
        ssl:     false
      }
      irc_notify_conf.should_receive(:set).with(value)
      subject.set(:irc_notify, value)
    end

    it '#clear' do
      irc_notify_conf.should_receive(:clear)
      subject.clear(:irc_notify)
    end

    it '#get' do
      irc_notify_conf.should_receive(:get)
      subject.get(:irc_notify)
    end
  end

end