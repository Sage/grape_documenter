require 'spec_helper'

describe GrapeDoc::Formatters::Textile do
  let(:mock_route) do
    mock('route', :route_method => 'GET',
                  :route_path => '/users',
                  :route_description => 'users description goes here',
                  :route_params => {:id => {:type => 'integer', :desc => 'user id'}})
  end

  let(:structure) do
    GrapeDoc::NamespaceDoc.new :version => 'v1',
        :title => 'Users',
        :root_path => '/users',
        :routes => [mock_route],
        :resources => [{ :name => 'Contacts', :path => '/contacts' }]
  end

  subject { described_class.new(structure) }

  it 'has h1 with title' do
    subject.format.should include('h1. Users')
  end

  it 'has an h2 with method and path' do
    subject.format.should include('h2. GET: /users')
  end

  it 'has an h3 and the description' do
    subject.format.should include('h3. Description')
    subject.format.should include('users description goes here')
  end

  it 'has an h3 and the route_params in a table' do
    subject.format.should include('h3. Parameters')
    subject.format.should include('|_.Name|_.Type|_.Description|')
    subject.format.should include('|id|integer|user id|')
  end
end
