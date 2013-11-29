require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
intersect = require './intersect'

describe 'Intersect' ->
  var user

  before ->
    user-kris         = new User name: 'kris'
    guest-user        = new User role: 'guest'
    admin-user        = new User role: 'admin'
    kris-admin-user   = new User name: 'kris', role: 'admin'

    intersect   = intersect!

  describe 'on' ->
    specify 'does NOT intersects on object with no overlap' ->
      intersect.on({user: 'x'}, {user: 'y'}).should.be false

    specify 'does NOT intersects on users with no overlap' ->
      intersect.on(user-kris, guest-user).should.be false

    specify 'intersects on same object' ->
      intersect.on(user-kris, user-kris).should.be true

    specify 'intersects on target object with partial overlap' ->
      intersect.on(user-kris-admin, admin-user).should.be true

    specify 'does NOT intersects on src object with partial overlap on target obj' ->
      intersect.on(admin-user, user-kris-admin).should.be false
