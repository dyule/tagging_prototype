window.tagcomplete = (elem, listCallback, filterList) ->
  listElem = document.createElement("datalist")
  elem.parentNode.insertBefore listElem, elem.nextSibling
  listElem.id = "list1337"
  elem.setAttribute("list", "list1337")
  createList = (list) ->
    list.sort()
    i = 0
    j = 0
    while i < list.length and j < listElem.childNodes.length
      curOption = listElem.childNodes.item(j)
      skip = false
      if list[i] < curOption.value
        for stopWord in filterList
          if list[i] == stopWord
            skip = true
        if skip
          i += 1
        else
          itemElem = document.createElement "option"
          itemElem.value = list[i]
          listElem.insertBefore itemElem, curOption
          i += 1
          j += 1
      else if list[i] > curOption.value
        listElem.removeChild(curOption)
      else
        i += 1
        j += 1

    while j < listElem.childNodes.length
      listElem.removeChild(listElem.childNodes.item(j))

    while i < list.length
      skip = false
      for stopWord in filterList
        if list[i] == stopWord
          skip = true
      if not skip
        itemElem = document.createElement "option"
        itemElem.value = list[i]
        listElem.appendChild itemElem
      i += 1


  elem.addEventListener "input", () ->
    console.log elem.value
    if elem.value.length > 0
      listCallback(elem.value, createList)
    else
      listElem.innerHTML = ""


