rek      = require 'rekuire'
requires = rek 'requires'

requires.test 'test_setup'

Permit          = requires.file 'permit'

Book            = requires.fix 'book'
permits         = requires.fix 'permits'

setup           = permits.setup
AdminPermit     = permits.AdminPermit
GuestPermit     = permits.GuestPermit

describe 'Permit' ->
  var guest-permit, book, access-request

  before ->
    book := new Book 'a book'
    access-request :=
      user:
        role: 'admin'
      action: 'read'
      subject: book

  describe 'Rules application' ->
    # auto applies static rules by default (in init) as part of construction!
    describe 'static rules application' ->
      before-each ->
        guest-permit := setup.guest-permit!

      after-each ->
        Permit.clear-all!

      specify 'registers a read-any rule (using default)' ->
        guest-permit.can-rules!['read'].should.eql ['any']

    describe 'dynamic rules application' ->
      before-each ->
        guest-permit := setup.guest-permit!

        # dynamic application when access-request passed
        guest-permit.apply-rules access-request

      after-each ->
        Permit.clear-all!

      specify 'registers a read-book rule' ->
        guest-permit.can-rules!['read'].should.eql ['Book']

      specify 'does NOT register a write-book rule' ->
        ( -> guest-permit.can-rules!['write'].should).should.throw

      context 'dynamic rules applied twice' ->
        before-each ->
          guest-permit := setup.guest-permit!

          # dynamic application when access-request passed
          guest-permit.apply-rules access-request

        after-each ->
          Permit.clear-all!

          # dynamic application when access-request passed
          guest-permit.apply-rules access-request
          guest-permit.apply-rules access-request

          specify 'still registers only a SINGLE read-book rule' ->
            guest-permit.can-rules!['read'].should.eql ['Book']
