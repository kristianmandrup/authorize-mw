requires  = require './requires'

module.exports =
  AuthorizeMw :  requires.mw 'authorize-mw'
  Authorizer :   requires.lib 'authorizer'
  Ability :      requires.lib 'ability'
  Allower :      requires.lib 'allower'
  Permit :       requires.lib 'permit'
  permit-for:    requires.permit 'permit-for'
