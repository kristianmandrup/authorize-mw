users =
  kris: ->
    new User name: 'kris'

  role: (role) ->
    new User name: 'kris', role: role

  name-role: (name, role) ->
    new User name: name, role: role

  guest: ->
    @role 'guest'

  admin: ->
    @role 'admin'

  auth: ->
    @role 'auth'

modules.exports = users