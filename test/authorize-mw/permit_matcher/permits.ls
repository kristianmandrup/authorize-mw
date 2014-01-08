requires = require './requires'

permit-for = requires.file 'permit_for'

module.exports =
  setup:
    user-permit: ->
      permit-for 'User',
        match: (access) ->
          @matching(access).has-user!

        rules: ->

    invalid-user: ->
      permit-for 'invalid User',
        match: void
        rules: ->

    invalid-ex-user: ->
      permit-for 'User',
        ex-match: void
        rules: ->

    guest-permit: ->
      permit-for 'Guest',
        match: (access) ->
          @matching(access).has-role 'guest'

        rules: ->
          @ucan 'read', 'Book'

    admin-permit: ->
      permit-for 'Admin',
        match: (access) ->
          @matching(access).has-role 'guest'

        rules:
          admin: ->
            @ucan 'manage', 'all'

    book-permit: ->
      permit-for 'Book',
        match: (access) ->
          @matching(access).has-subject-clazz 'Book'

        rules: ->
          @ucan 'read', 'Book'

    ex-user-permit: ->
      permit-for 'ex User',
        ex-match: (access) ->
          console.log 'access', access
          @matching(access).has-role 'admin'

        rules: ->
          @ucan 'read', 'Book'

    complex-user: ->
      permit-for 'complex User',
        match: (access) ->
          @matching(access).user(type: 'person').role('admin').subject-clazz('Book').result!

        rules: ->
          @ucan 'read', 'Book'

    complex-invalid-user: ->
      permit-for 'ex User',
        match: (access) ->
          @matching(access).user(type: 'person').role('admin').subject-clazz('Book')

        rules: ->
          @ucan 'read', 'Book'
