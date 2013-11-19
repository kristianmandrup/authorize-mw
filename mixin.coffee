module.exports = class Mixin
  @use = (mixins...) ->
    for mixin in mixins
      # Notice that now we expect the mixin to be an object.
      @::[key] = value for key, value of mixin
    @
  use: (mixins...) ->
    for mixin in mixins
      # Notice that now we expect the mixin to be an object.
      @[key] = value for key, value of mixin
    @