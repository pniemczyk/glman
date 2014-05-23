require 'spec_helper'

describe Glman::Commands::Configs::UsersConfig do
  subject{ described_class.new(config_manager: config_manager) }
  let(:config_manager) { double('config_manager') }

  describe '#set' do
    before(:each) {config_manager.should_receive(:set).with({ users: set_users })}
    let(:set_users) {{'damian@o2.pl' => {id: 1} , 'pawel@o2.pl' => {id: 2}}}

    it 'should set new users' do
      subject.set(set_users)
    end
  end

  describe '#get' do
    before(:each) {config_manager.should_receive(:get).and_return(get_users)}
    let(:current_users) {{'pawel@o2.pl' => {id: 2}}}
    let(:get_users)      {{users: current_users}}

    it 'should receive current users' do
      subject.get.should eq current_users
    end

    context 'when configuration is empty' do
      let(:current_users) {Glman::Commands::Configs::UsersConfig::DEFAULT}

      it 'should receive default users' do
        subject.get.should eq current_users
      end
    end
  end

  describe '#clear' do
    before(:each) {config_manager.should_receive(:set).with({ users: set_users })}
    let(:set_users) { Glman::Commands::Configs::UsersConfig::DEFAULT }

    it 'should set users to default' do
      subject.clear
    end
  end
end
