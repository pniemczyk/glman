require 'spec_helper'

describe Glman::InitRequired do

  class TestInitRequiredClass
    include Glman::InitRequired

    attr_required :a
  end

  it 'Test class should have propery a' do
    subject = TestInitRequiredClass.new(a: 'test')
    subject.a.should eq 'test'
  end

  it 'should raise InitializationError when required attr missing on initialization' do
    -> { TestInitRequiredClass.new }.should raise_error
  end
end