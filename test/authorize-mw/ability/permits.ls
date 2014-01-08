rek      = require 'rekuire'
requires = rek 'requires'

permit        = requires.fix 'permit'

module.exports =
  user   : permit.matching.user!
  guest  : permit.matching.role.guest!
  admin  : permit.matching.role.admin!
  auth   : permit.matching.ctx.auth!
