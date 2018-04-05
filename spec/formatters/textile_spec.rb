require 'spec_helper'

describe GrapeDocumenter::Formatters::Textile do
  let(:mock_route) do
    double('route', :route_method => 'GET',
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
    expect(subject.format).to include('h1. Users')
  end

  it 'has an h3 with method and path' do
    expect(subject.format).to include('h3. GET: /users')
  end

  it 'has the description' do
    expect(subject.format).to include('users description goes here')
  end

  it 'has an h4 and the params in a table' do
    expect(subject.format).to include('h4. Required Parameters')
    expect(subject.format).to include('|_.Name|_.Type|_.Description|')
    expect(subject.format).to include("|\\3. id|\n||integer|user id|")
  end

  it 'has an h4 and the optional_params in a table' do
    expect(subject.format).to include('h4. Optional Parameters')
    expect(subject.format).to include('|_.Name|_.Type|_.Description|')
    expect(subject.format).to include("|\\3. foo|\n||string|fooness|")
  end

  it 'has placeholder for example requests' do
    expect(subject.format).to include 'h4. Example Request'
    expect(subject.format).to include 'users__request__get__index'
  end

  it 'has placeholder for example responses' do
    expect(subject.format).to include 'h4. Example Response'
    expect(subject.format).to include 'users__response__get__index'
  end
end
