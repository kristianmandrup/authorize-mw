rek      = require 'rekuire'
requires = rek 'requires'

Permit        = requires.file 'permit'
permit-class  = requires.fix  'permit-class'
permit-for    = requires.file 'permit-for'

GuestPermit = permit-class.GuestPermit

module.exports =
  guest: (debug) ->
    permit-for GuestPermit, 'guest books', (->
      rules:
        ctx:
          area:
            visitor: ->
              @ucan 'publish', 'Paper'
        read: ->
          @ucan 'read' 'Book'
        write: ->
          @ucan 'write' 'Book'
        default: ->
          @ucan 'read' 'any'
      ), debug

  admin: (debug) ->
    permit-for Permit, 'admin books', (->
      rules:
        ctx:
          area:
            admin: ->
              @ucan 'review', 'Paper'
        subject:
          paper: ->
            @ucan 'approve', 'Paper'
    ), debug

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
