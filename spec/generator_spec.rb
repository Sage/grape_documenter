require 'spec_helper'

describe GrapeDoc::Generator do
  subject { described_class.new 'MyApplication::API', '/tmp/grape_doc' }

  context 'for a given api version' do
    it 'stores the version' do
      subject.generate_namespace_docs.first.version.should == 'v1'
    end

    it 'stores the title' do
      subject.generate_namespace_docs.first.title.should == 'User'
    end

    it 'stores the root_path' do
      subject.generate_namespace_docs.first.root_path.should == '/user'
    end

    it 'stores the routes' do
      subject.generate_namespace_docs.first.routes.should == MyApplication::API.routes.select{|r| r.route_version == 'v1'}
    end

    it 'stores the global resources' do
      subject.generate_namespace_docs.first.resources.should == [{ :name => 'User', :path => '/user' }]
    end
  end
end
