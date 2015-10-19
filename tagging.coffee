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
  't': {'a': {'g': {1:{objects: [objects[0]]},2:{objects: [objects[0]]},3:{objects: [objects[1]]}}}}}

exports.addObject = (obj) ->
  if not obj.tags
    obj.tags = []
  if not obj.name
    obj.name = ""
  objects.push(obj)

exports.forObjectsAndTags = (objFunc, tagFunc, tagList) ->
  tagIndex = 0
  subTags = {}
  objList = objects
  if tagList.length > 0
    rootTag = tagList[0]
    node = tags
    while tagIndex < rootTag.length
      if node[rootTag[tagIndex]]
        node = node[rootTag[tagIndex]]
        tagIndex += 1
      else
        return
    if node.objects
      objList = node.objects
    else
      objList = []
  for obj in objList
    toAdd = tagList.length == 0
    for tag in obj.tags
      if tagList.indexOf(tag) > -1
        toAdd = true
    if toAdd
      objFunc(obj)
      for tag in obj.tags
        if tagList.indexOf(tag) == -1
          subTags[tag] = true
  for own tag of subTags
    tagFunc tag
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
  if not node.objects
    node.objects = []
  node.objects.push(obj)
  console.log(tags)


exports.removeTag = (obj, tag) ->
  index = obj.tags.indexOf(tag)

  if index > -1
    obj.tags.splice(index, 1)

    _removeFromNode(tag, 0, tags, obj)

    console.log(tags)

_removeFromNode = (tag, index, node, obj) ->
  if index == tag.length
    objIndex = node.objects.indexOf(obj)
    node.objects.splice objIndex, 1
    if node.objects.length == 0
      for own ch of node
        if ch != 'objects'
          return false
      return true
  else
    if _removeFromNode(tag, index + 1, node[tag[index]], obj)
      delete node[tag[index]]
      if not node.count or node.objects.length == 0
        for own ch of node
          console.log ch
          if ch != 'objects'
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
    if ch == 'objects'
      if node.objects.length > 0
        results.push(stub)
    else
      results = results.concat(_findMatching(stub + ch, node[ch]))
  return results


exports.matchingTags = (stub, callback) ->
  results = _findPrefix(stub, 0, tags)
  console.log results
  callback results

