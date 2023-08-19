require 'spec_helper'

listen_port = 80

#Nginxがインストールされていること
describe package('nginx') do
  it { should be_installed }
end

#Unicornがインストールされていること
describe command('gem list unicorn') do
  its(:stdout) { should match /unicorn/ }
  its(:exit_status) { should eq 0 }
end

#Nginx設定ファイルに指定した記述があること
describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
  its(:content) { should match /user ec2-user;/ }
end

#mysqlが実行されていること
describe service('mysqld') do
  it { should be_running }
end

#nginxが実行されていること
describe service('nginx') do
  it { should be_running }
end

#特定のポートがリッスンしていること
describe port(listen_port) do
  it { should be_listening }
end

#レスポンスが200であること
describe command('curl http://127.0.0.1:#{listen_port}/_plugin/head/ -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end


