create-user =
  name: ->
    new User name: name

  kris: ->
    @name 'kris'

  javier: ->
    @name 'javier'

  role: (role) ->
    new User name: 'kris', role: role

  guest: ->
    @role 'guest'

  admin: ->
    @role 'admin'

  auth: ->
    @role 'auth'

  name-role: (name, role) ->
    new User name: name, role: role

module.exports = create-user