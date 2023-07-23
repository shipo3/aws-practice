require 'serverspec'
require 'net/ssh'

set :backend, :ssh
set :host, ENV['TARGET_HOST']
set :ssh_options, {
  user: ENV['SSH_USER'],
  keys: [ENV['SSH_KEY_PATH']],
  forward_agent: true,
}

RSpec.configure do |c|
  c.before :all do
    block = self.class.metadata[:example_group_block]
    if block
      file_path = block.source_location.first
      c.host  = File.basename(File.dirname(file_path))
    end
  end
end
