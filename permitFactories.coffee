_ = require 'lodash'
Allower = require './allower'
permitFor = require './permitFor'

myPermit = permitFor 'a man walking into the bar', ->
  # return true if this permit applies for this access obj
  match: (access) ->
    access is 'x'

  # we will execute all methods under rules :)
  rules:
    manage: ->
      can 'manage', ['post', 'comment']
    publish: ->
      can 'publish', ['post']

my2Permit = permitFor 'a sexy woman',
  # return true if this permit does not apply (should be excluded!) this access obj
  exMatch: (access) ->
    access is 'y'

# true since match returns true :)
console.log myPermit.matches('x')

# false since exMatch (exclude match) returns true!
console.log my2Permit.matches('y')

# console.log Permit.permits

allower = new Allower

allow = Allower.allows 'x'

console.log "ALLOW x: #{allow}"

PermitFilter = require './permitFilter'

filtered = PermitFilter.filter 'x'

console.log "applies for x: #{filtered.map('name')}"


