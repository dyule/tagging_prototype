window.tagbox = (el, matchCallback) ->
  myTags = []



  el.setTags = (tags) ->
    myTags = []
    el.innerHTML = ""
    for tag in tags
      tagElement = createTagElement tag
      el.appendChild tagElement
      myTags.push(tag)
    tagText = createTagTextBox()
    el.appendChild tagText
    tagcomplete(tagText, matchCallback, myTags)


  createTagElement = (tag) ->
    tagElement = document.createElement "span"
    tagElement.className = "objTag"
    tagElement.textContent = tag
    removeElement = document.createElement "span"
    removeElement.textContent = "x"
    removeElement.className = "removeTag"
    tagElement.appendChild(removeElement)
    removeElement.addEventListener "click", () ->
      el.removeChild(tagElement)
      index = myTags.indexOf(tag)
      myTags.splice(index, 1)
      el.dispatchEvent new CustomEvent("tagremoved", {detail: tag})
    return tagElement

  createTagTextBox = () ->
    newTags = document.createElement("input")
    newTags.type = "text"
    newTags.className = "objNewTag"

    wasOne = false
    newTags.addEventListener "keydown", (e) ->
      wasOne = e.keyCode == 8 and newTags.selectionStart == 1


    newTags.addEventListener "keyup", (e) ->
      if e.keyCode == 8 and newTags.selectionStart == 0 and myTags.length > 0 and not wasOne
        backTag = myTags.pop()
        newTags.value = backTag + newTags.value
        newTags.selectionStart = backTag.length
        newTags.selectionEnd = backTag.length
        el.removeChild(newTags.previousElementSibling)
        el.dispatchEvent new CustomEvent("tagremoved", {detail: backTag})
        newTags.dispatchEvent(new Event("input"))
      else if e.keyCode == 13
        addAll()


    newTags.addEventListener "input", () ->
      text = newTags.value
      curStart = newTags.selectionStart
      tlist = text.split /,/g
      i = 0
      rlen = 0
      while i < tlist.length - 1
        rlen += tlist[i].length + 1
        newText = tlist[i].trim()
        addTag(newText)
        i += 1
      newTags.value = tlist[tlist.length - 1]
      newTags.selectionStart = curStart - rlen
      newTags.selectionEnd = curStart - rlen

    newTags.addEventListener "blur", () ->
      addAll()


    addAll = () ->
      text = newTags.value
      tlist = text.split /,/g
      i = 0
      while i < tlist.length
        newText = tlist[i].trim()
        addTag(newText)
        i += 1
      newTags.value = ""
      newTags.dispatchEvent(new Event("input"))

    addTag = (tag) ->
      if tag.length == 0
        return
      for theTag in myTags
        if theTag == tag
          return
      tagElement = createTagElement tag
      el.insertBefore tagElement, newTags
      myTags.push(tag)
      el.dispatchEvent new CustomEvent("tagadded", {detail: tag})

    return newTags