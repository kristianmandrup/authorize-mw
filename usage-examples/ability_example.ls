authorize = require 'authorize-mw'

Ability     = authorize.Ability

user = (name) ->
  new User name

book = (title) ->
  new Book title

ability = (user) ->
  new Ability user

a-book = book 'some book'
current-user = user 'kris'

if ability(current-user).allowed-for action: 'read', subject: a-book
  # do the read book action
  ...