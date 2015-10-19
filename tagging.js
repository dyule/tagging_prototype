// Generated by CoffeeScript 1.9.3
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
            count: 1
          },
          2: {
            count: 1
          },
          3: {
            count: 1
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

  exports.forObjects = function(func) {
    var i, len, obj;
    for (i = 0, len = objects.length; i < len; i++) {
      obj = objects[i];
      func(obj);
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
    if (!node.count) {
      node.count = 0;
    }
    return node.count += 1;
  };

  exports.removeTag = function(obj, tag) {
    var index;
    index = obj.tags.indexOf(tag);
    if (index > -1) {
      obj.tags.splice(index, 1);
      return _removeFromNode(tag, 0, tags);
    }
  };

  _removeFromNode = function(tag, index, node) {
    var ch;
    if (index === tag.length) {
      node.count -= 1;
      if (node.count === 0) {
        for (ch in node) {
          if (!hasProp.call(node, ch)) continue;
          if (ch !== 'count') {
            return false;
          }
        }
        return true;
      }
    } else {
      if (_removeFromNode(tag, index + 1, node[tag[index]])) {
        delete node[tag[index]];
        if (node.count === 0 || !node.count) {
          for (ch in node) {
            if (!hasProp.call(node, ch)) continue;
            console.log(ch);
            if (ch !== 'count') {
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
      if (ch === 'count') {
        results.push(stub);
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
