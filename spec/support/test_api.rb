require 'grape'

module MyApplication
  class API < Grape::API
    version 'v1' do
      resource :user do
        desc 'Get all users'
        get do
        end

        desc 'Get the specified user', :params => {
          'id' => { :desc => 'The id of the user', :type => 'integer' }
        }
        get ':id' do
        end
      end
    end

    version 'v2' do
      resource :user do
        desc 'Get all users'
        get do
        end

        desc 'Get the specified user', :params => {
          'id' => { :desc => 'The id of the user', :type => 'integer' }
        }
        get ':id' do
        end

        resource :comments do

        end
      end
    end
  end
end
