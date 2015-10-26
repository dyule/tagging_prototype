// Generated by CoffeeScript 1.9.3
(function() {
  window.tagbox = function(el, matchCallback) {
    var createTagElement, createTagTextBox, myTags;
    myTags = [];
    el.setTags = function(tags) {
      var j, len, tag, tagElement, tagText;
      myTags = [];
      el.innerHTML = "";
      for (j = 0, len = tags.length; j < len; j++) {
        tag = tags[j];
        tagElement = createTagElement(tag);
        el.appendChild(tagElement);
        myTags.push(tag);
      }
      tagText = createTagTextBox();
      el.appendChild(tagText);
      return tagcomplete(tagText, matchCallback, myTags);
    };
    createTagElement = function(tag) {
      var removeElement, tagElement;
      tagElement = document.createElement("span");
      tagElement.className = "objTag";
      tagElement.textContent = tag;
      removeElement = document.createElement("span");
      removeElement.textContent = "x";
      removeElement.className = "removeTag";
      tagElement.appendChild(removeElement);
      removeElement.addEventListener("click", function() {
        var index;
        el.removeChild(tagElement);
        index = myTags.indexOf(tag);
        myTags.splice(index, 1);
        return el.dispatchEvent(new CustomEvent("tagremoved", {
          detail: tag
        }));
      });
      return tagElement;
    };
    return createTagTextBox = function() {
      var addAll, addTag, newTags, wasOne;
      newTags = document.createElement("input");
      newTags.type = "text";
      newTags.className = "objNewTag";
      newTags.setAttribute("autocomplete", false);
      wasOne = false;
      newTags.addEventListener("keydown", function(e) {
        return wasOne = e.keyCode === 8 && newTags.selectionStart === 1;
      });
      newTags.addEventListener("keyup", function(e) {
        var backTag;
        if (e.keyCode === 8 && newTags.selectionStart === 0 && myTags.length > 0 && !wasOne) {
          backTag = myTags.pop();
          newTags.value = backTag + newTags.value;
          newTags.selectionStart = backTag.length;
          newTags.selectionEnd = backTag.length;
          el.removeChild(newTags.previousElementSibling);
          el.dispatchEvent(new CustomEvent("tagremoved", {
            detail: backTag
          }));
          return newTags.dispatchEvent(new Event("input"));
        } else if (e.keyCode === 13) {
          addAll();
          return e.preventDefault();
        }
      });
      newTags.addEventListener("input", function() {
        var curStart, i, newText, rlen, text, tlist;
        text = newTags.value;
        curStart = newTags.selectionStart;
        tlist = text.split(/,|;/g);
        i = 0;
        rlen = 0;
        while (i < tlist.length - 1) {
          rlen += tlist[i].length + 1;
          newText = tlist[i].trim();
          addTag(newText);
          i += 1;
        }
        newTags.value = tlist[tlist.length - 1];
        newTags.selectionStart = curStart - rlen;
        return newTags.selectionEnd = curStart - rlen;
      });
      newTags.addEventListener("blur", function() {
        return addAll();
      });
      addAll = function() {
        var i, newText, text, tlist;
        text = newTags.value;
        tlist = text.split(/,/g);
        i = 0;
        while (i < tlist.length) {
          newText = tlist[i].trim();
          addTag(newText);
          i += 1;
        }
        newTags.value = "";
        return newTags.dispatchEvent(new Event("input"));
      };
      addTag = function(tag) {
        var j, len, tagElement, theTag;
        if (tag.length === 0) {
          return;
        }
        for (j = 0, len = myTags.length; j < len; j++) {
          theTag = myTags[j];
          if (theTag === tag) {
            return;
          }
        }
        tagElement = createTagElement(tag);
        el.insertBefore(tagElement, newTags);
        myTags.push(tag);
        return el.dispatchEvent(new CustomEvent("tagadded", {
          detail: tag
        }));
      };
      return newTags;
    };
  };

}).call(this);

//# sourceMappingURL=tagbox.js.map
