require 'spec_helper'

describe GrapeDocumenter::NamespaceDoc do
  describe 'attrubutes' do
    subject do
      described_class.new :title => 'some title',
                          :routes => 'some routes',
                          :root_path => 'some root path',
                          :version => 'some version',
                          :resources => 'some resources'
    end

    it 'stores title' do
      subject.title.should == 'some title'
    end

    it 'stores routes' do
      subject.routes.should == 'some routes'
    end

    it 'stores root_path' do
      subject.root_path.should == 'some root path'
    end

    it 'stores version' do
      subject.version.should == 'some version'
    end

    it 'stores resources' do
      subject.resources.should == 'some resources'
    end
  end
end
