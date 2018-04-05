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
      expect(subject.title).to eq('some title')
    end

    it 'stores routes' do
      expect(subject.routes).to eq('some routes')
    end

    it 'stores root_path' do
      expect(subject.root_path).to eq('some root path')
    end

    it 'stores version' do
      expect(subject.version).to eq('some version')
    end

    it 'stores resources' do
      expect(subject.resources).to eq('some resources')
    end
  end
end
