rek      = require 'rekuire'
requires = rek 'requires'

create-permit  = requires.fac 'create-permit'

module.exports =
  user   : create-permit.matching.user!
  guest  : create-permit.matching.role.guest!
  admin  : create-permit.matching.role.admin!
  auth   : create-permit.matching.ctx.auth!
