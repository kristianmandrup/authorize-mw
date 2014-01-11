rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

Permit          = requires.file 'permit'
PermitRegistry  = requires.file 'permit-registry'

Book            = requires.fix 'book'
permit-clazz    = requires.fix 'permit-class'

create-permit   = requires.fac 'create-permit'

AdminPermit     = permit-clazz.AdminPermit
GuestPermit     = permit-clazz.GuestPermit

describe 'Permit' ->
  var book
  requests  =
    admin: {}
  permits   = {}
  users     = {}

  before ->
    book := new Book 'a book'
    requests.admin.read-book :=
      user:
        role: 'admin'
      action: 'read'
      subject: book

  describe 'Rules application' ->
    # auto applies static rules by default (in init) as part of construction!
    describe 'static rules application' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest := create-permit.guest!

      after ->
        PermitRegistry.clear-all!

      specify 'registers a read-any rule (using default)' ->
        permits.guest.can-rules!['read'].should.eql ['*']

    describe 'dynamic rules application - action rules' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest := create-permit.guest!

        # dynamic application when access-request passed
        rule-applier = permits.guest.rule-applier requests.admin.read-book

        rule-applier.apply-action-rules 'read'

      after ->
        PermitRegistry.clear-all!

      specify 'registers a read-book rule' ->
        permits.guest.can-rules!['read'].should.include 'Book'

    describe 'dynamic rules application' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest := create-permit.guest!

        # dynamic application when access-request passed
        permits.guest.apply-rules requests.admin.read-book, 'force'

      after ->
        PermitRegistry.clear-all!

      specify 'registers a read-book rule' ->
        permits.guest.can-rules!['read'].should.include 'Book'

      specify 'does NOT register a write-book rule' ->
        ( -> permits.guest.can-rules!['write'].should).should.throw

      context 'dynamic rules applied twice' ->
        before ->
          permits.guest := create-permit.guest!

          # dynamic application when access-request passed
          permits.guest.apply-rules requests.admin.read-book

        after ->
          PermitRegistry.clear-all!

          # dynamic application when access-request passed
          permits.guest.apply-rules requests.admin.read-book
          permits.guest.apply-rules requests.admin.read-book

          specify 'still registers only a SINGLE read-book rule' ->
            permits.guest.can-rules!['read'].should.eql ['Book']
