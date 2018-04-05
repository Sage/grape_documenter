require 'spec_helper'

describe GrapeDocumenter::RouteDoc do
  let(:mock_route) do
    double('route', :route_method => 'GET',
                  :route_path => '/users',
                  :route_description => 'users description goes here',
                  :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                  :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
  end

  subject { described_class.new mock_route  }

  describe 'attributes' do
    it 'returns the method' do
      # cant use #method as reserved word
      expect(subject.http_method).to eq('GET')
    end

    it 'returns the path' do
      expect(subject.path).to eq('/users')
    end

    it 'returns the description' do
      expect(subject.description).to eq('users description goes here')
    end

    it 'returns the params' do
      expect(subject.params).to eq({'id' => {:type => 'integer', :desc => 'user id'}})
    end

    it 'returns the params' do
      expect(subject.optional_params).to eq({'foo' => {:type => 'string', :desc => 'fooness'}})
    end
  end

  context 'with mounted_path' do
    subject { described_class.new(mock_route, :mounted_path => '/foo')  }

    it 'returns the path with mounted path' do
      expect(subject.path).to eq('/foo/users')
    end
  end

  describe 'inferred_title' do
    context 'when it is an index action' do
      let(:mock_route) do
        double('route', :route_method => 'GET',
                      :route_path => '/users',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To get a list of all Users' do
        expect(subject.inferred_title).to eq('To get a list of Users')
      end

      context 'when nested' do
        it 'is To get a list of all Users' do
          expect(subject.inferred_title).to eq('To get a list of Users')
        end
      end
    end

    context 'when it is an show action' do
      let(:mock_route) do
        double('route', :route_method => 'GET',
                      :route_path => '/users/:id',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To get a User' do
        expect(subject.inferred_title).to eq('To get a User')
      end

      context 'when nested' do
        let(:mock_route) do
          double('route', :route_method => 'GET',
                        :route_path => '/some_resource/:their_id/users/:id',
                        :route_description => 'users description goes here',
                        :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                        :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
        end

        subject { described_class.new mock_route  }

        it 'is To get a User' do
          expect(subject.inferred_title).to eq('To get a User')
        end
      end

      context 'when resource begins with harsh vowel' do
        let(:mock_route) do
          double('route', :route_method => 'GET',
                        :route_path => '/some_resource/:their_id/account/:id',
                        :route_description => 'users description goes here',
                        :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                        :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
        end

        subject { described_class.new mock_route  }

        it 'is To get a User' do
          expect(subject.inferred_title).to eq('To get an Account')
        end
      end

      context 'when resource contains an underscore' do
        let(:mock_route) do
          double('route', :route_method => 'GET',
                        :route_path => '/some_resource/:their_id/user_type/:id',
                        :route_description => 'users description goes here',
                        :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                        :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
        end

        subject { described_class.new mock_route  }

        it 'is To get a User' do
          expect(subject.inferred_title).to eq('To get a User type')
        end
      end
    end

    context 'when it is a create action' do
      let(:mock_route) do
        double('route', :route_method => 'POST',
                      :route_path => '/users',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To create a User' do
        expect(subject.inferred_title).to eq('To create a User')
      end
    end

    context 'when it is an update action' do
      let(:mock_route) do
        double('route', :route_method => 'PUT',
                      :route_path => '/users/:id',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To get a User' do
        expect(subject.inferred_title).to eq('To update a User')
      end
    end

    context 'when it is an destroy action' do
      let(:mock_route) do
        double('route', :route_method => 'DELETE',
                      :route_path => '/users/:id',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To delete a User' do
        expect(subject.inferred_title).to eq('To delete a User')
      end
    end
  end

  describe 'inferred_rails_action' do
    context 'when index' do
      before :each do
        allow(mock_route).to receive(:route_method).and_return('GET')
      end

      it 'returns index' do
        expect(subject.inferred_rails_action).to eq('index')
      end
    end

    context 'when show' do
      before :each do
        allow(mock_route).to receive(:route_method).and_return('GET')
        allow(mock_route).to receive(:route_path).and_return('/users/:id')
      end

      it 'returns show' do
        expect(subject.inferred_rails_action).to eq('show')
      end
    end

    context 'when create' do
      before :each do
        allow(mock_route).to receive(:route_method).and_return('POST')
      end

      it 'returns create' do
        expect(subject.inferred_rails_action).to eq('create')
      end
    end

    context 'when update' do
      before :each do
        allow(mock_route).to receive(:route_method).and_return('PUT')
      end

      it 'returns update' do
        expect(subject.inferred_rails_action).to eq('update')
      end
    end

    context 'when destroy' do
      before :each do
        allow(mock_route).to receive(:route_method).and_return('DELETE')
      end

      it 'returns destroy' do
        expect(subject.inferred_rails_action).to eq('destroy')
      end
    end

    context 'when custom route' do
      subject { described_class.new mock_route, :action => 'custom_route' }

      it 'returns custom route' do
        expect(subject.inferred_rails_action).to eq('custom_route')
      end
    end
  end
end
