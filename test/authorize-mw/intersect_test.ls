require '../test_setup'

_         = require 'prelude-ls'
User      = require '../fixtures/user'
intersect = require('../../intersect')!

describe 'Intersect' ->
  var user-kris, guest-user, admin-user, kris-admin-user

  before ->
    kris-user         = new User name: 'kris'
    guest-user        = new User role: 'guest'
    admin-user        = new User role: 'admin'
    kris-admin-user   = new User name: 'kris', role: 'admin'

  describe 'on' ->
    specify 'does NOT intersects on object with no overlap' ->
      intersect.on({user: 'x'}, {user: 'y'}).should.be.false

    specify 'does NOT intersects on users with no overlap' ->
      intersect.on(kris-user, guest-user).should.be.false

    specify 'intersects on same object' ->
      intersect.on(kris-user, kris-user).should.be.true

    specify 'intersects on target object with partial overlap' ->
      intersect.on(kris-admin-user, admin-user).should.be.true

    specify 'does NOT intersects on src object with partial overlap on target obj' ->
      intersect.on(admin-user, kris-admin-user).should.be.false
