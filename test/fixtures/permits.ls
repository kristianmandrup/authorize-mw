rek      = require 'rekuire'
requires = rek 'requires'

Permit    = requires.file 'permit'

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


module.exports =
  AdminPermit : AdminPermit
  GuestPermit : GuestPermit
  setup       : setup