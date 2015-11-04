http = require "http"
https = require "https"
p = document.querySelector("#place")
unit = "c"
loaded = false
update = ->
  document.querySelector("#tempformat").innerHTML = if unit is "c"
    "<b>C</b>/F"
  else
    "C/<b>F</b>"
  text = ""
  query = "select * from weather.forecast where woeid in
    (select woeid from geo.places(1) where text=\"#{p.value}\") and u='#{unit}'"
  https.get("https://query.yahooapis.com/v1/public/yql?q=#{query}&format=json
    &env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", (res) ->
    res.on 'data', (chunk) -> text += chunk
    res.on 'end', ->
      data = JSON.parse text
      regiontext = if data.query.results.channel.location.region
        "#{data.query.results.channel.location.region}, "
      else ""
      document.querySelector("#placefull").innerHTML = "
      #{data.query.results.channel.location.city}, #{regiontext}
      #{data.query.results.channel.location.country}"
      document.querySelector("#temperature").innerHTML =
        data.query.results.channel.item.condition.temp
      document.querySelector("#conditions").innerHTML =
        data.query.results.channel.item.condition.text
      document.querySelector("#high").innerHTML =
        data.query.results.channel.item.forecast[0].high
      document.querySelector("#low").innerHTML =
        data.query.results.channel.item.forecast[0].low
      document.querySelector("#humidity").innerHTML =
        data.query.results.channel.atmosphere.humidity
      document.querySelector("#sunrise").innerHTML =
        data.query.results.channel.astronomy.sunrise
      document.querySelector("#sunset").innerHTML =
        data.query.results.channel.astronomy.sunset
      document.querySelector("#speed").innerHTML =
        Math.floor(data.query.results.channel.wind.speed) +
        if unit is "c" then "k/h" else "m/h"
      document.querySelector("#chill").innerHTML =
        data.query.results.channel.wind.chill
      save()
  ).on 'error', -> alert 'Getting Weather Failed.'
setInterval update, 1200000
update()
p.onchange = update
p.onkeyup = update

bkpfile = (process.env.HOME || process.env.USERPROFILE) +
  "/.podiumweather.json"

fs = require 'fs'

save = ->
  fs.writeFileSync bkpfile, JSON.stringify
    unit: unit
    location: p.value

fs.readFile bkpfile, (e, d) ->
  if !e
    loaded = true
    data = JSON.parse d
    unit = data.unit
    p.value = data.location
    update()
  else
    navigator.geolocation.getCurrentPosition (position) ->
      text = ""
      http.get("http://api.geonames.org/findNearbyPlaceNameJSON" +
      "?lat=#{position.coords.latitude}&lng=#{position.coords.longitude}" +
      "&username=podium", (res) ->
        res.on 'data', (chunk) -> text += chunk
        res.on 'end', ->
          data = JSON.parse text
          p.value = data.geonames[0].name + ", " +
          data.geonames[0].adminName1 + ", " + data.geonames[0].countryName
          unit = "f" if data.geonames[0].countryName is "United States"
          update()
          save()
      ).on 'error', -> alert 'Getting Location Failed.'

document.querySelector("#tempformat").onclick = ->
  unit = if unit is "c" then "f" else "c"
  update()
  save()
