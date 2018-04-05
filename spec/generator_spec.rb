require 'spec_helper'

describe GrapeDocumenter::Generator do
  subject { described_class.new 'MyApplication::API', '/tmp/grape_documenter' }

  context 'integration test' do
    context 'for the first api version' do
      it 'stores the version' do
        expect(subject.generate_namespace_docs.first.version).to eq('v1')
      end

      it 'stores the title' do
        expect(subject.generate_namespace_docs.first.title).to eq('User')
      end

      it 'stores the root_path' do
        expect(subject.generate_namespace_docs.first.root_path).to eq('/user')
      end

      describe 'routes' do
        let(:routes) { subject.generate_namespace_docs.first.routes }

        describe 'index' do
          describe 'method' do
            it 'returns get' do
              expect(routes.first.http_method).to eq('GET')
            end
          end

          describe 'description' do
            it 'returns Get all users' do
              expect(routes.first.description).to eq('Get all users')
            end
          end

          describe 'path' do
            it 'returns /users' do
              expect(routes.first.path).to eq('/:version/user')
            end
          end

          describe 'path' do
            it 'returns /users' do
              expect(routes.first.path).to eq('/:version/user')
            end
          end

          describe 'action_params' do
            it 'returns /users' do
              allow(subject).to receive(:endpoint_action).and_return 'custom_action'
              expect(routes.first.action_params).to eq('custom_action')
            end
          end
        end

        describe 'show' do
          describe 'params' do
            it 'returns id with desc and type' do
              expect(routes[1].params).to eq({ 'id' => { :desc => 'The id of the user', :type => 'integer' } })
            end
          end
        end

        describe 'post' do
          describe 'optional params' do
            it 'returns first_name with desc and type' do
              expect(routes[2].optional_params).to eq({ 'first_name' => { :desc => 'First name of the user', :type => 'string' } })
            end
          end
        end
      end

      it 'stores the global resources' do
        expect(subject.generate_namespace_docs.first.resources).to eq([{ :name => 'User', :path => '/user' }])
      end
    end
  end

  describe 'options' do
    describe 'prefix' do
      subject { described_class.new 'MyApplication::API', '/tmp/grape_documenter', :mounted_path => '/mounted_path' }

      it 'sets the prefix' do
        expect(subject.mounted_path).to eq('/mounted_path')
      end
    end
  end
end
