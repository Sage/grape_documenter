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
end
