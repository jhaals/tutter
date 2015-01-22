require 'spec_helper'
require 'json'

describe 'tutter' do

  it 'expect complain about missing project in settings' do
    post '/', params=JSON.generate({'repository' => {'full_name' => '404'}}), {'HTTP_X_GITHUB_EVENT' => 'fake'}
    expect { last_response.body match /Project does not exist in tutter.conf/ }
    expect { last_response.status == 404 }
  end

  it 'expect complain about POST data not being JSON' do
    post '/', params={'broken' => 'data'}, {'HTTP_X_GITHUB_EVENT' => 'fake'}
    expect { last_response.body match /POST data is not JSON/ }
    expect { last_response.status == 400 }
  end

  it 'expect return documentation URL' do
    get '/'
    expect { last_response.body match /Source code and documentation/ }
  end

end

describe 'tutter Hello action' do
  it 'expect complain about invalid credentials' do
    data = IO.read('spec/fixtures/new_issue.json')
    post '/', params=data, {'HTTP_X_GITHUB_EVENT' => 'fake'}
    expect { last_response.body match /Authorization to JHaals\/testing failed, please verify your access token/ }
    expect { last_response.status == 401 }
  end
end