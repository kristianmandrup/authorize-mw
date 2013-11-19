classToType = {}
for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
  classToType["[object " + name + "]"] = name.toLowerCase()

module.exports = (obj) ->
    strType = Object::toString.call(obj)
    classToType[strType] or "object"