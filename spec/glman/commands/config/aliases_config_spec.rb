require 'spec_helper'

describe Glman::Commands::Configs::AliasesConfig do
  subject{ described_class.new(config_manager: config_manager) }
  let(:config_manager) { double('config_manager') }

  describe '#add' do
    before(:each) do
      config_manager.should_receive(:set).with({ aliases: set_aliases })
      config_manager.should_receive(:get).and_return(get_aliases)
    end
    let(:alias_name)  {:dj}
    let(:email)       {'damian@o2.pl'}
    let(:input_hash)  {{email: email, alias_name: alias_name}}
    let(:new_alias)   {{alias_name => email}}
    let(:old_aliases) {{pn: 'pniemczyk@o2.pl'}}
    let(:get_aliases) {{aliases: old_aliases}}
    let(:set_aliases) {old_aliases.merge(new_alias)}

    it 'should add new alias to existings' do
      subject.add(input_hash)
    end
  end

  describe '#delete' do
    before(:each) do
      config_manager.should_receive(:set).with({ aliases: set_aliases })
      config_manager.should_receive(:get).and_return(get_aliases)
    end

    let(:alias_to_delete) {'pn'}
    let(:get_aliases)     {{aliases: {dj: 'damian@o2.pl', pn: 'pawel@o2.pl'}}}
    let(:set_aliases)     {{dj: 'damian@o2.pl'}}

    it 'should delete alias from existings' do
      subject.delete(alias_to_delete)
    end
  end


  describe '#set' do
    before(:each) {config_manager.should_receive(:set).with({ aliases: set_aliases })}
    let(:set_aliases) {{dj: 'damian@o2.pl', pn: 'pawel@o2.pl'}}

    it 'should set new aliases' do
      subject.set(set_aliases)
    end
  end

  describe '#get' do
    before(:each) {config_manager.should_receive(:get).and_return(get_aliases)}
    let(:current_aliasses) {{pn: 'pawel@o2.pl'}}
    let(:get_aliases)      {{aliases: current_aliasses}}

    it 'should receive current aliases' do
      subject.get.should eq current_aliasses
    end

    context 'when configuration is empty' do
      let(:current_aliasses) {Glman::Commands::Configs::AliasesConfig::DEFAULT}

      it 'should receive default aliases' do
        subject.get.should eq current_aliasses
      end
    end
  end

  describe '#clear' do
    before(:each) {config_manager.should_receive(:set).with({ aliases: set_aliases })}
    let(:set_aliases) { nil }

    it 'should set aliases to default' do
      subject.clear
    end
  end
end
