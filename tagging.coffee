exports = {}
window.tagging = exports
objects = [
  {
    name: "Object 1",
    tags: ["tag1", "tag2"]
  },
  {
    name: "Object 2",
    tags: ["tag3"]
  }
]

tags = {
  't': {'a': {'g': {1:{count: 1},2:{count: 1},3:{count: 1}}}}}

exports.addObject = (obj) ->
  if not obj.tags
    obj.tags = []
  if not obj.name
    obj.name = ""
  objects.push(obj)

exports.forObjects = (func) ->
  for obj in objects
    func(obj)
  return

exports.objectsInTag = (tag) ->
  results = []
  for obj in objects
    for ObjTag in obj.tags
      if objTag == tag
        results.push(obj)
        break
  return results

exports.addTag = (obj, tag) ->
  obj.tags.push(tag)
  node = tags
  for ch in tag
    if not node[ch]
      node[ch] = {}
    node = node[ch]
  if not node.count
    node.count = 0
  node.count += 1


exports.removeTag = (obj, tag) ->
  index = obj.tags.indexOf(tag)

  if index > -1
    obj.tags.splice(index, 1)

    _removeFromNode(tag, 0, tags)

_removeFromNode = (tag, index, node) ->
  if index == tag.length
    node.count -= 1
    if node.count == 0
      for own ch of node
        if ch != 'count'
          return false
      return true
  else
    if _removeFromNode(tag, index + 1, node[tag[index]])
      delete node[tag[index]]
      if node.count == 0 or not node.count
        for own ch of node
          console.log ch
          if ch != 'count'
            return false
        return true
  return false

_findPrefix = (stub, index, node) ->
  if not node
    return []
  else if index == stub.length
     _findMatching(stub, node)
  else
    _findPrefix(stub, index + 1, node[stub[index]])

_findMatching = (stub, node) ->
  if not node
    return []
  results = []
  for own ch of node
    if ch == 'count'
      results.push(stub)
    else
      results = results.concat(_findMatching(stub + ch, node[ch]))
  return results


exports.matchingTags = (stub, callback) ->
  results = _findPrefix(stub, 0, tags)
  console.log(results)
  callback results

