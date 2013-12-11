_ = require 'prelude-ls'

module.exports = class PermitAllower
  (@rule-repo) ->
    unless _.is-type 'Object', @rule-repo
      throw Error "PermitAllower must take a RuleRepo in constructor, was: #{@rule-repo}"

  test-access: (act, access-request) ->
    # try to find matching action/subject combi for canRule in rule-repo
    subj = @rule-repo.match-rule act, access-request
    subj? # true if not null

  # if permit disallows, then it doesn't matter if there is also a rule that allows
  # A cannot rule always wins!
  allows: (access-request) ->
    return false if @disallows access-request
    @test-access 'can', access-request

  # if no explicit cannot rule matches, we assume the user IS NOT disallowed
  disallows: (access-request) ->
    @test-access 'cannot', access-request
