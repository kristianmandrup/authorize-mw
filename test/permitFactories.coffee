permitFor 'admin publishers at midnight', ->
  match(access) ->
    ['admin', 'publisher'].include access.user.role and midnight()?

  # we will execute all methods under rules :)
  rules:
    manage: ->
      can 'manage', ['post', 'comment']
    publish: ->
      can 'publish', ['post']

# factory to create permit class (see below)
permitFor 'project admins', ->
  # shorthand to avoid writing match function always, if just simple hash comparison
  # access hash must include the following values
  includes:
  {'user.role': 'admin', model: 'project'}

  # and must NOT include the following
  excludes:
  {context: 'dashboard'}

  rules: ->
    can 'manage', @model

# In effect if access hash contains the following, the permit applies
# { user: {role: 'admin'}, model: 'project'}

# for any user trying to access project model
permitFor model: 'project', ->
  can ['read', 'edit'], [@model, projectManager] # -> adds 4 can-rules (all combis)

# can read any model
permitFor '*', ->
  can 'read', '*'