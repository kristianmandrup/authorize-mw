rek      = require 'rekuire'
requires = rek 'requires'

Permit        = requires.file 'permit'

module.exports =
  AdminPermit : class AdminPermit extends Permit
    includes: ->
      'user':
        'role': 'admin'

    # and must NOT include the following
    excludes: ->
      'context': 'dashboard'

  GuestPermit : class GuestPermit extends Permit
    (name, desc) ->
      super ...

    match: (access) ->
      true
