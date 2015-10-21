
navTags = []
selectedObj = undefined

renderList = ->
  objList = document.getElementById('objectList')
  tagList = document.getElementById('tagList')
  navElem = document.getElementById('navTags')
  propPanel = document.getElementById('propertiesPanel')
  dragObj = undefined

  renderNavItem = (item) ->
    navItem = document.createElement('div')
    navItem.className = 'navTag'
    navItem.textContent = item
    navElem.appendChild navItem
    navItem.addEventListener 'click', ->
      index = navTags.indexOf(item)
      navTags.splice index, 1
      renderList()

  objList.innerHTML = ''
  tagList.innerHTML = ''
  navElem.innerHTML = ''
  propPanel.style.visibility = 'hidden'
  for navItem in navTags
    renderNavItem navItem

  tagging.forObjectsAndTags ((obj) ->
    element = document.createElement('div')
    nameElement = document.createElement('span')
    tagsElement = document.createElement('span')
    if obj == selectedObj
      element.className = 'listObject selected'
      propPanel.style.visibility = 'visible'
    else
      element.className = 'listObject'
    element.setAttribute 'draggable', 'true'
    element.addEventListener 'dragstart', (e) ->
      dragObj = obj
      e.dataTransfer.setData 'text/plain', 'object'

    nameElement.textContent = obj.name
    nameElement.className = 'listObjectName'
    for tag in obj.tags
      tagElement = document.createElement('span')
      tagElement.className = 'listObjectTag'
      tagElement.textContent = tag
      tagsElement.appendChild tagElement
    element.appendChild nameElement
    element.appendChild tagsElement
    objList.appendChild element
    element.addEventListener 'click', ->
      for listObj in element.parentNode.childNodes
        listObj.className = 'listObject'
      element.className = 'listObject selected'
      selectedObj = obj
      renderObject obj
  ), ((tag) ->
    element = document.createElement('div')
    nameElement = document.createElement('span')
    element.className = 'listTag'
    element.addEventListener 'dragover', (e) ->
      if dragObj.tags.indexOf(tag) == -1
        e.preventDefault()
    element.addEventListener 'dragenter', ->
      if dragObj.tags.indexOf(tag) == -1
        element.className = 'listTag dragtarget'
    element.addEventListener 'dragleave', ->
      element.className = 'listTag'
    element.addEventListener 'drop', (e) ->
      if dragObj.tags.indexOf(tag) == -1
        tagging.addTag dragObj, tag
        renderList()
        if dragObj == selectedObj
          renderObject selectedObj
      e.preventDefault()
    for otherItem in navTags
      if otherItem.length < tag.length - 1 and tag.substr(0, otherItem.length) == otherItem and tag[otherItem.length] == '/'
        removeItem = otherItem
        break
    nameElement.textContent = tag
    nameElement.className = 'listTagName'
    element.appendChild nameElement
    element.addEventListener 'click', ->
      navTags.splice navTags.indexOf(removeItem), 1
      navTags.push tag
      renderList()
    tagList.appendChild element
  ), navTags

renderObject = (obj) ->
  objTags = document.getElementById('objTags')
  objClone = objTags.cloneNode(false)
  document.getElementById('propertiesPanel').style.visibility = 'visible'
  document.getElementById('objName').textContent = obj.name
  objTags.parentNode.replaceChild objClone, objTags
  objTags = objClone
  tagbox objTags, tagging.matchingTags
  objTags.setTags obj.tags
  objTags.addEventListener 'tagadded', (e) ->
    tagging.addTag obj, e.detail
    renderList()
  objTags.addEventListener 'tagremoved', (e) ->
    tagging.removeTag obj, e.detail
    renderList()

document.addEventListener 'DOMContentLoaded', ->
  addButton = document.getElementById('addObject')
  addButton.addEventListener 'click', ->
    name = prompt('Name of object?')
    obj =
      name: name
      tags: navTags.slice()
    tagging.addObject obj
    selectedObj = obj
    renderList()
    renderObject obj
  renderList()
