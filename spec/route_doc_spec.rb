require 'spec_helper'

describe GrapeDocumenter::RouteDoc do
  let(:mock_route) do
    mock('route', :route_method => 'GET',
                  :route_path => '/users',
                  :route_description => 'users description goes here',
                  :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                  :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
  end

  subject { described_class.new mock_route  }

  describe 'attributes' do
    it 'returns the method' do
      # cant use #method as reserved word
      subject.http_method.should == 'GET'
    end

    it 'returns the path' do
      subject.path.should == '/users'
    end

    it 'returns the description' do
      subject.description.should == 'users description goes here'
    end

    it 'returns the params' do
      subject.params.should == {'id' => {:type => 'integer', :desc => 'user id'}}
    end

    it 'returns the params' do
      subject.optional_params.should == {'foo' => {:type => 'string', :desc => 'fooness'}}
    end
  end

  context 'with mounted_path' do
    subject { described_class.new(mock_route, :mounted_path => '/foo')  }

    it 'returns the path with mounted path' do
      subject.path.should == '/foo/users'
    end
  end

  describe :inferred_title do
    context 'when it is an index action' do
      let(:mock_route) do
        mock('route', :route_method => 'GET',
                      :route_path => '/users',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To get a list of all Users' do
        subject.inferred_title.should == 'To get a list of Users'
      end

      context 'when nested' do
        it 'is To get a list of all Users' do
          subject.inferred_title.should == 'To get a list of Users'
        end
      end
    end

    context 'when it is an show action' do
      let(:mock_route) do
        mock('route', :route_method => 'GET',
                      :route_path => '/users/:id',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To get a User' do
        subject.inferred_title.should == 'To get a User'
      end

      context 'when nested' do
        let(:mock_route) do
          mock('route', :route_method => 'GET',
                        :route_path => '/some_resource/:their_id/users/:id',
                        :route_description => 'users description goes here',
                        :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                        :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
        end

        subject { described_class.new mock_route  }

        it 'is To get a User' do
          subject.inferred_title.should == 'To get a User'
        end
      end

      context 'when resource begins with harsh vowel' do
        let(:mock_route) do
          mock('route', :route_method => 'GET',
                        :route_path => '/some_resource/:their_id/account/:id',
                        :route_description => 'users description goes here',
                        :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                        :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
        end

        subject { described_class.new mock_route  }

        it 'is To get a User' do
          subject.inferred_title.should == 'To get an Account'
        end
      end

      context 'when resource contains an underscore' do
        let(:mock_route) do
          mock('route', :route_method => 'GET',
                        :route_path => '/some_resource/:their_id/user_type/:id',
                        :route_description => 'users description goes here',
                        :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                        :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
        end

        subject { described_class.new mock_route  }

        it 'is To get a User' do
          subject.inferred_title.should == 'To get a User type'
        end
      end
    end

    context 'when it is a create action' do
      let(:mock_route) do
        mock('route', :route_method => 'POST',
                      :route_path => '/users',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To create a User' do
        subject.inferred_title.should == 'To create a User'
      end
    end

    context 'when it is an update action' do
      let(:mock_route) do
        mock('route', :route_method => 'PUT',
                      :route_path => '/users/:id',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To get a User' do
        subject.inferred_title.should == 'To update a User'
      end
    end

    context 'when it is an destroy action' do
      let(:mock_route) do
        mock('route', :route_method => 'DELETE',
                      :route_path => '/users/:id',
                      :route_description => 'users description goes here',
                      :route_params => {'id' => {:type => 'integer', :desc => 'user id'}},
                      :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
      end

      subject { described_class.new mock_route  }

      it 'is To delete a User' do
        subject.inferred_title.should == 'To delete a User'
      end
    end
  end

  describe :inferred_rails_action do
    context 'when index' do
      before :each do
        mock_route.stub(:route_method).and_return('GET')
      end

      it 'returns index' do
        subject.inferred_rails_action.should == 'index'
      end
    end

    context 'when show' do
      before :each do
        mock_route.stub(:route_method).and_return('GET')
        mock_route.stub(:route_path).and_return('/users/:id')
      end

      it 'returns show' do
        subject.inferred_rails_action.should == 'show'
      end
    end

    context 'when create' do
      before :each do
        mock_route.stub(:route_method).and_return('POST')
      end

      it 'returns create' do
        subject.inferred_rails_action.should == 'create'
      end
    end

    context 'when update' do
      before :each do
        mock_route.stub(:route_method).and_return('PUT')
      end

      it 'returns update' do
        subject.inferred_rails_action.should == 'update'
      end
    end

    context 'when destroy' do
      before :each do
        mock_route.stub(:route_method).and_return('DELETE')
      end

      it 'returns destroy' do
        subject.inferred_rails_action.should == 'destroy'
      end
    end
  end
end
