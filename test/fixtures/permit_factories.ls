bar-permit = permit-for 'a man walking into the bar', ->
  # return true if this permit applies for this access obj
  match: (access) ->
    access.user.gender is 'male' and access.ctx.place is 'bar'

  # we will execute all methods under rules :)
  rules:
    manage: ->
      can 'manage' ['post', 'comment']
    publish: ->
      can 'publish' ['post']

sexy-permit = permit-for 'a sexy woman',
  # return true if this permit does not apply (should be excluded!) this access obj
  match: (access) ->
    user = access.user
    user.gender is 'female' and user.looks is 'sexy'

  rules:
    manage: ->
      can 'manipulate' ['person']


# factory to create permit class (see below)
project-admin-permit = permit-for 'project admins' ->
  # shorthand to avoid writing match function always, if just simple hash comparison
  # access hash must include the following values
  includes:
    {'user.role': 'admin', model: 'project'}

  # and must NOT include the following
  excludes:
    {context: 'dashboard'}

  rules: ->
    can 'manage' @model

# The permits visible to the outside (those that require this module!)
module.exports = {
  sexy-permit: sexy-permit
  bar-permit: bar-permit
  project-admin-permit: project-admin-permit
}