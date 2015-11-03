window.onkeydown = (e) ->
  window.location.reload() if e.keyCode is 116
  require('remote').getCurrentWindow().toggleDevTools() if e.keyCode is 123

document.querySelector("#close").onclick = ->
  window.close()
aTags = document.querySelectorAll "a"
for i in aTags
  i.setAttribute "onclick", "require('shell').openExternal('#{i.href}')"
  i.href = "#"
