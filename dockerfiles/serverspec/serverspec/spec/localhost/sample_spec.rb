require 'serverspec'

set :backend, :exec

describe file('example-voting-app/result/Dockerfile') do
  its(:content) { should match /^FROM node:5.11.0-slim/ }
  its(:content) { should match /^LABEL Version 0.1/ }
end
