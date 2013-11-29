module.exports = (items) ->
    switch type(items)
      when 'function'
        items()
      when 'string'
        [items]
      when 'array'
        items.map(
          (item) -> @normalize item
        )
      else
        throw new Error("#{action} can't be normalized, must be a Function, String or Array")
