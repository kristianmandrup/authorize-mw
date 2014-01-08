rek      = require 'rekuire'
requires = rek 'requires'

Ability  = requires.file 'ability'

users    = requires.fix 'users'

ability = (user) ->
  new Ability user

module.exports =
  kris  : ability users.kris!
  guest : ability users.guest!
  admin : ability users.admin!
