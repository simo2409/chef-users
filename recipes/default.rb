#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2015, Simone Dall Angelo
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

node[:users][:users].each do |username|
  Chef::Log.debug("Creating #{username.inspect}")
  
  # Create user
  user username do
    action :create
  end

  if node['users']['create_ssh_keys']
    # Create .ssh directory
    directory "/home/#{username}/.ssh" do
      action :create
      owner username
      group username
      mode 0700
    end

    # Create new ssh key
    execute "Generate ssh key for #{username}." do
      user username
      creates "/home/#{username}/.ssh/id_rsa.pub"
      command "ssh-keygen -t rsa -q -f /home/#{username}/.ssh/id_rsa -P \"\""
      not_if do ::File.exists?("/home/#{username}/.ssh/id_rsa") end
    end

    ruby_block "Public key for '#{username}'" do
      action :run
      block do
        # Log must be put here to be able to execute it on "execution phase" of chef
        puts "Public key for user #{username.inspect}: #{File::read("/home/#{username}/.ssh/id_rsa.pub")}"
      end
    end
  end

  if node['users']['ssh_keys_to_add'] && node['users']['ssh_keys_to_add'].any?

    # Create .ssh directory
    directory "/home/#{username}/.ssh" do
      action :create
      owner username
      group username
      mode 0700
    end
    
    node['users']['ssh_keys_to_add'].each do |key|
      # Add ssh key
      file "/home/#{username}/.ssh/authorized_keys" do
        action :create
        owner username
        group username
        mode 0600
        content key
      end
    end
  end
end
