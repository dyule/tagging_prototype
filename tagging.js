// Generated by CoffeeScript 1.10.0
(function() {
  var _findMatching, _findPrefix, _removeFromNode, exports, objects, tags,
    hasProp = {}.hasOwnProperty;

  exports = {};

  window.tagging = exports;

  objects = [
    {
      name: "Object 1",
      tags: ["tag1", "tag2"]
    }, {
      name: "Object 2",
      tags: ["tag3"]
    }
  ];

  tags = {
    't': {
      'a': {
        'g': {
          1: {
            objects: [objects[0]]
          },
          2: {
            objects: [objects[0]]
          },
          3: {
            objects: [objects[1]]
          }
        }
      }
    }
  };

  exports.addObject = function(obj) {
    if (!obj.tags) {
      obj.tags = [];
    }
    if (!obj.name) {
      obj.name = "";
    }
    return objects.push(obj);
  };

  exports.forObjectsAndTags = function(objFunc, tagFunc, tagList) {
    var i, j, k, len, len1, len2, node, obj, objList, ref, ref1, rootTag, subTags, tag, tagIndex, toAdd;
    tagIndex = 0;
    subTags = {};
    objList = objects;
    if (tagList.length > 0) {
      rootTag = tagList[0];
      node = tags;
      while (tagIndex < rootTag.length) {
        if (node[rootTag[tagIndex]]) {
          node = node[rootTag[tagIndex]];
          tagIndex += 1;
        } else {
          return;
        }
      }
      if (node.objects) {
        objList = node.objects;
      } else {
        objList = [];
      }
    }
    for (i = 0, len = objList.length; i < len; i++) {
      obj = objList[i];
      toAdd = tagList.length === 0;
      ref = obj.tags;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        tag = ref[j];
        if (tagList.indexOf(tag) > -1) {
          toAdd = true;
        }
      }
      if (toAdd) {
        objFunc(obj);
        ref1 = obj.tags;
        for (k = 0, len2 = ref1.length; k < len2; k++) {
          tag = ref1[k];
          if (tagList.indexOf(tag) === -1) {
            subTags[tag] = true;
          }
        }
      }
    }
    for (tag in subTags) {
      if (!hasProp.call(subTags, tag)) continue;
      tagFunc(tag);
    }
  };

  exports.objectsInTag = function(tag) {
    var ObjTag, i, j, len, len1, obj, ref, results;
    results = [];
    for (i = 0, len = objects.length; i < len; i++) {
      obj = objects[i];
      ref = obj.tags;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        ObjTag = ref[j];
        if (objTag === tag) {
          results.push(obj);
          break;
        }
      }
    }
    return results;
  };

  exports.addTag = function(obj, tag) {
    var ch, i, len, node;
    obj.tags.push(tag);
    node = tags;
    for (i = 0, len = tag.length; i < len; i++) {
      ch = tag[i];
      if (!node[ch]) {
        node[ch] = {};
      }
      node = node[ch];
    }
    if (!node.objects) {
      node.objects = [];
    }
    node.objects.push(obj);
    return console.log(tags);
  };

  exports.removeTag = function(obj, tag) {
    var index;
    index = obj.tags.indexOf(tag);
    if (index > -1) {
      obj.tags.splice(index, 1);
      _removeFromNode(tag, 0, tags, obj);
      return console.log(tags);
    }
  };

  _removeFromNode = function(tag, index, node, obj) {
    var ch, objIndex;
    if (index === tag.length) {
      objIndex = node.objects.indexOf(obj);
      node.objects.splice(objIndex, 1);
      if (node.objects.length === 0) {
        for (ch in node) {
          if (!hasProp.call(node, ch)) continue;
          if (ch !== 'objects') {
            return false;
          }
        }
        return true;
      }
    } else {
      if (_removeFromNode(tag, index + 1, node[tag[index]], obj)) {
        delete node[tag[index]];
        if (!node.count || node.objects.length === 0) {
          for (ch in node) {
            if (!hasProp.call(node, ch)) continue;
            console.log(ch);
            if (ch !== 'objects') {
              return false;
            }
          }
          return true;
        }
      }
    }
    return false;
  };

  _findPrefix = function(stub, index, node) {
    if (!node) {
      return [];
    } else if (index === stub.length) {
      return _findMatching(stub, node);
    } else {
      return _findPrefix(stub, index + 1, node[stub[index]]);
    }
  };

  _findMatching = function(stub, node) {
    var ch, results;
    if (!node) {
      return [];
    }
    results = [];
    for (ch in node) {
      if (!hasProp.call(node, ch)) continue;
      if (ch === 'objects') {
        if (node.objects.length > 0) {
          results.push(stub);
        }
      } else {
        results = results.concat(_findMatching(stub + ch, node[ch]));
      }
    }
    return results;
  };

  exports.matchingTags = function(stub, callback) {
    var results;
    results = _findPrefix(stub, 0, tags);
    console.log(results);
    return callback(results);
  };

}).call(this);

//# sourceMappingURL=tagging.js.map
