require 'spec_helper'

describe GrapeDocumenter::Generator do
  subject { described_class.new 'MyApplication::API', '/tmp/grape_documenter' }

  context 'integration test' do
    context 'for the first api version' do
      it 'stores the version' do
        subject.generate_namespace_docs.first.version.should == 'v1'
      end

      it 'stores the title' do
        subject.generate_namespace_docs.first.title.should == 'User'
      end

      it 'stores the root_path' do
        subject.generate_namespace_docs.first.root_path.should == '/user'
      end

      describe 'routes' do
        let(:routes) { subject.generate_namespace_docs.first.routes }

        describe 'index' do
          describe 'method' do
            it 'returns get' do
              routes.first.http_method.should == 'GET'
            end
          end

          describe 'description' do
            it 'returns Get all users' do
              routes.first.description.should == 'Get all users'
            end
          end

          describe 'path' do
            it 'returns /users' do
              routes.first.path.should == '/:version/user'
            end
          end
        end

        describe 'show' do
          describe 'params' do
            it 'returns id with desc and type' do
              routes[1].params.should == { 'id' => { :desc => 'The id of the user', :type => 'integer' } }
            end
          end
        end

        describe 'post' do
          describe 'optional params' do
            it 'returns first_name with desc and type' do
              routes[2].optional_params.should == { 'first_name' => { :desc => 'First name of the user', :type => 'string' } }
            end
          end
        end
      end

      it 'stores the global resources' do
        subject.generate_namespace_docs.first.resources.should == [{ :name => 'User', :path => '/user' }]
      end
    end
  end

  describe 'options' do
    describe 'prefix' do
      subject { described_class.new 'MyApplication::API', '/tmp/grape_documenter', :mounted_path => '/mounted_path' }

      it 'sets the prefix' do
        subject.mounted_path.should == '/mounted_path'
      end
    end
  end
end
