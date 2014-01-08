rek      = require 'rekuire'
requires = rek 'requires'

Permit        = requires.file 'permit'
permit-for    = requires.file 'permit-for'

class AdminPermit extends Permit
  includes: ->
    'user':
      'role': 'admin'

  # and must NOT include the following
  excludes: ->
    'context': 'dashboard'

class GuestPermit extends Permit
  (name, desc) ->
    super ...

  match: (access) ->
    true

setup =
  guest-permit: ->
    permit-for GuestPermit, 'books', ->
      rules:
        read: ->
          @ucan 'read' 'Book'
        write: ->
          @ucan 'write' 'Book'
        default: ->
          @ucan 'read' 'any'

  matching:
    user: ->
      permit-for 'User',
        match: (access) ->
          @matching(access).has-user!
        rules: ->
          @ucan ['read', 'edit'], 'book'

    ctx:
      auth: ->
        permit-for 'auth',
          match: (access) ->
            @matching(access).has-ctx auth: 'yes'

          rules: ->
            @ucan 'manage', 'book'

    role:
      guest: ->
        permit-for 'Guest',
          match: (access) ->
            @matching(access).has-role 'guest'

          rules: ->
            @ucan 'read', 'book'

      admin: ->
        permit-for 'admin',
          match: (access) ->
            @matching(access).has-role 'admin'

          rules: ->
            @ucan 'write', 'book'
            @ucan 'manage', '*'

module.exports =
  AdminPermit : AdminPermit
  GuestPermit : GuestPermit
  setup       : setup