require 'spec_helper'
require 'json'

describe 'Tutter' do
  it 'Complains about missing Github header' do
    post '/', JSON.generate(repository: { full_name: '404' })
    expect(last_response.body).to match(/Invalid request/)
    expect(last_response.status).to be 500
  end

  it 'Complains about missing project in settings' do
    post '/', JSON.generate(repository: { full_name: '404' }), 'HTTP_X_GITHUB_EVENT' => 'fake'
    expect(last_response.body).to match(/Project does not exist in tutter.conf/)
    expect(last_response.status).to be 404
  end

  it 'Complains about missing repository name in json payload' do
    post '/', JSON.generate(repository: {}), 'HTTP_X_GITHUB_EVENT' => 'issue_comment'
    expect(last_response.body).to match(/Bad request/)
    expect(last_response.status).to be 400
  end

  it 'Complains about event not configured for project' do
    post '/', JSON.generate(repository: { full_name: 'JHaals/testing' }), 'HTTP_X_GITHUB_EVENT' => 'fake'
    expect(last_response.body).to match(/No Actions for fake in tutter.conf/)
    expect(last_response.status).to be 404
  end

  it 'Complains about POST data not being JSON' do
    post '/', { broken: 'data' }, 'HTTP_X_GITHUB_EVENT' => 'fake'
    expect(last_response.body).to match(/POST data is not JSON/)
    expect(last_response.status).to be 400
  end

  it 'Responds to Github ping event' do
    post '/', JSON.generate({}), 'HTTP_X_GITHUB_EVENT' => 'ping'
    expect(last_response.body).to match(/Tutter likes this hook!/)
    expect(last_response.status).to be 200
  end

  it 'Returns documentation URL' do
    get '/'
    expect(last_response.body).to match(/Source code and documentation/)
  end

  it 'Retruns only one response in repsonses due to first action failiure' do
    data = IO.read('spec/fixtures/new_issue.json')
    post '/', data, 'HTTP_X_GITHUB_EVENT' => 'issue'
    body = JSON.parse(last_response.body)
    expect(body["responses"]["thanks"]["message"]).to match(/Authorization to JHaals\/testing failed, please verify your access token/)
    expect(body["responses"].length).to be(1)
    expect(last_response.status).to be 401
  end
end

describe 'Tutter Thanks action' do
  it 'Complains about invalid credentials' do
    data = IO.read('spec/fixtures/new_issue.json')
    post '/', data, 'HTTP_X_GITHUB_EVENT' => 'issue'
    body = JSON.parse(last_response.body)
    expect(body["responses"]["thanks"]["message"]).to match(/Authorization to JHaals\/testing failed, please verify your access token/)
    expect(last_response.status).to be 401
  end
  it 'Will not thank user for anything else that opening an issue' do
    data = IO.read('spec/fixtures/closed_issue.json')
    post '/', data, 'HTTP_X_GITHUB_EVENT' => 'issue'
    body = JSON.parse(last_response.body)
    expect(body["responses"]["thanks"]["message"]).to match(/Web hook from GitHub for JHaals\/testing does not have status opened. We don't thank people for closing issues/)
    expect(last_response.status).to be 200
  end
end

describe 'Tutter Sassy action' do
  it 'Complains about invalid credentials' do
    data = IO.read('spec/fixtures/issue_comment.json')
    post '/', data, 'HTTP_X_GITHUB_EVENT' => 'issue_comment'
    body = JSON.parse(last_response.body)
    expect(body["responses"]["sassy"]["message"]).to match(/Authorization to JHaals\/testing failed, please verify your access token/)
    expect(last_response.status).to be 401
  end
  it 'Fails gracefully when it dosent know what to do' do
    data = IO.read('spec/fixtures/closed_issue.json')
    post '/', data, 'HTTP_X_GITHUB_EVENT' => 'issue_comment'
    body = JSON.parse(last_response.body)
    expect(body["responses"]["sassy"]["message"]).to match(/Web hook from GitHub for JHaals\/testing does not have status created. Dont know what to do./)
    expect(last_response.status).to be 200
  end
end
