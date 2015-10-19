window.tagcomplete = (elem, listCallback) ->
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
      if list[i] < curOption.value
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
      itemElem = document.createElement "option"
      itemElem.value = list[i]
      listElem.appendChild itemElem
      i += 1


  elem.addEventListener "input", () ->
    if elem.value.length > 0
      listCallback(elem.value, createList)
    else
      listElem.innerHTML = ""


