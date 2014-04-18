authorize = require 'authorize-mw'

Middleware  = require 'middleware' .Middleware
AuthorizeMw = authorize.AuthorizeMw
Permit      = authorize.Permit
permit-for  = authorize.permit-for

class Book extends Base
  (obj) ->
    super ...

book = new Book title: title

class GuestUser extends User
  (obj) ->
    super ...

  role: 'guest'

guest-user   = new GuestUser name: 'unknown'

GuestPermit = class GuestPermit extends Permit
  match: (access) ->
    @matches(access).user role: 'guest'

guest-permit = permit-for(GuestPermit, 'guest books',
      rules:
        ctx:
          area:
            guest: ->
              @ucan 'publish', 'Paper'
            admin: ->
              @ucannot 'publish', 'Paper'

        read: ->
          @ucan 'read' 'Book'
        write: ->
          @ucan 'write' 'Book'
        default: ->
          @ucan 'read' 'any'
)

basic-authorize-mws = new AuthorizeMw current-user: guest-user

auth-middleware = new Middleware 'model' data: books.hello
auth-middleware.use authorize: basic-authorize-mws

read-books-request =
  action      :   'read'
  collection  :   'books'

allowed = auth-middleware.run read-books-request