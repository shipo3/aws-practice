require 'serverspec'
require 'net/ssh'

set :backend, :ssh

# 対象サーバ内でのsudo passwordの設定処理
# 実行時に 環境変数に ASK_SUDO_PASSWORDが設定されている場合
# コマンドライン上でパスワードを入力させる
if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  # コマンドライン上でパスワードを入力させる
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  # ASK_SUDO_PASSWORD設定がオフの場合はここに設定したパスワードを利用する
  set :sudo_password, ENV['SUDO_PASSWORD']
end
# host = ENV['TARGET_HOST']

# options = Net::SSH::Config.for(host)
# options[:user] ||= Etc.getlogin

# 接続先サーバのユーザ名
# options[:user] ||= 'ec2_user'

# set :host,        options[:host_name] || host
# set :ssh_options, options

# set :host,  '52.69.186.67'
# set :ssh_options, user: 'ec2-user', keys: '~/.ssh/id_rsa_serverspec'

# options[:user] ||= 'ec2-user'
# options[:keys] = ['/home/circleci/.ssh/id_rsa_serverspec']

# set :ssh_options, options

set :host, ENV['TARGET_HOST']
set :ssh_options, {
  user: 'ec2-user',
  keys: ['/home/circleci/.ssh/id_rsa_serverspec'],
  forward_agent: true,
  auth_methods: %w(publickey)
}