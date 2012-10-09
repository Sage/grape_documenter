require 'spec_helper'

describe GrapeDocumenter::Formatters::Textile do
  let(:mock_route) do
    mock('route', :route_method => 'GET',
                  :route_path => '/users',
                  :route_description => 'users description goes here',
                  :route_params => {
                    'id' => {:type => 'integer', :desc => 'user id'},
                    'parameter[with][sub][elements]' => {:type => 'thing', :desc => 'stuff'}
                  },
                  :route_optional_params => {'foo' => {:type => 'string', :desc => 'fooness'}})
  end

  let(:structure) do
    GrapeDocumenter::NamespaceDoc.new :version => 'v1',
        :title => 'Users',
        :root_path => '/users',
        :routes => [GrapeDocumenter::RouteDoc.new(mock_route)],
        :resources => [{ :name => 'Contacts', :path => '/contacts' }]
  end

  subject { described_class.new(structure) }

  it 'has h1 with title' do
    subject.format.should include('h1. Users')
  end

  it 'has an h3 with method and path' do
    subject.format.should include('h3. GET: /users')
  end

  it 'has the description' do
    subject.format.should include('users description goes here')
  end

  it 'has an h4 and the params in a table' do
    subject.format.should include('h4. Required Parameters')
    subject.format.should include('|_.Name|_.Type|_.Description|')
    subject.format.should include("|\\3. id|\n||integer|user id|")
  end

  it 'has an h4 and the optional_params in a table' do
    subject.format.should include('h4. Optional Parameters')
    subject.format.should include('|_.Name|_.Type|_.Description|')
    subject.format.should include("|\\3. foo|\n||string|fooness|")
  end
end
