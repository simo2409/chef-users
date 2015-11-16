users Cookbook
==============
This cookbook creates users in linux, generating its SSH Keys and adding
additional keys (if needed).

Requirements
------------
None

Attributes
----------
This recipe uses node['users'] as list of users that need to be created.

If node['users']['create_ssh_keys'] == true (default) it also generates
a fresh SSH Key for each created user.

If there is any node['users']['ssh_keys_to_add'] it also adds all passed
keys to every created user.

```json
"users": {
  "users": ["user1", "user2"],
  "create_ssh_keys": true,
  "ssh_keys_to_add": [
    'ssh-rsa ABC..',
    'ssh-rsa ABD..'
  ]
},
```

#### users::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['users']['users']</tt></td>
    <td>Array</td>
    <td>list of usernames to create</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['users']['create_ssh_keys']</tt></td>
    <td>Boolean</td>
    <td>if true recipe will generate a fresh SSH Key for each user</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['users']['ssh_keys_to_add']</tt></td>
    <td>Array</td>
    <td>list of existing SSH Keys to be added to every created user</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

Usage
-----
#### users::default
Just include `users` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[users]"
  ]
}
```
and specify attributes that you need (as shown before).

Contributing
------------
Need help for testing following best practises, if you can help you are welcome!

License and Authors
-------------------
License: MIT

Authors:

Simone Dall'Angelo
