rek      = require 'rekuire'
requires = rek 'requires'

deep-extend = require 'deep-extend'

permit        = requires.fix 'permit'

module.exports =
    empty  : {}
    user   : request.user-access user-kris
    guest  : request.role-access 'guest'
    admin  : request.role-access 'admin'

    kris   :
      user:
        name: 'kris'
      action: 'read'
      ctx:
        auth: true

    kris-admin   : deep-extend {}, @admin, @kris
