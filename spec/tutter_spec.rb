require 'spec_helper'
require 'json'

describe 'tutter' do

  it 'should complain about missing project in settings' do
    post '/', params=JSON.generate({'repository' => {'full_name' => '404'}})
    last_response.body.should match /Project does not exist in tutter.conf/
  end

  it 'should return documentation URL' do
    get '/'
    last_response.body.should match /Source code and documentation/
  end

end
