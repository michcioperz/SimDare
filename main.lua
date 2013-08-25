gui = require "lib.Quickie"
arc_root = "lib/Navi/"
arc_path = arc_root .. "arc/"
require(arc_path.. "arc")
_navi = require(arc_path .. "navi")

function love.load()
  sprites = {
    love.graphics.newImage("human.png"),
    love.graphics.newImage("computer.png"),
    love.graphics.newImage("room.png"),
    love.graphics.newImage("bed.png"),
    love.graphics.newImage("fridge.png")
  }
  occupation = 3
  task = 2
  timer = 48*60*60
  hours = 48
  minutes = 0
  food = 0.75
  hydration = 0.75
  conscience = 1
  overburn = 0
  sleep = 0.75
  gui.mouse.disable()
  love.graphics.setNewFont(15)
  love.graphics.setBackgroundColor(255, 255, 255, 255)
  performGameUpdate = true
end

function love.update(dt)
  arc.check_keys(dt)
  if performGameUpdate then
    timer = timer - 8*60*dt
    if sleep > 0.01*dt then
      sleep = sleep - 0.01*dt
    elseif sleep < 0.01*dt then
      sleep = 0
    end
    if food > 0.01*dt then
      food = food - 0.01*dt
    elseif food < 0.01*dt then
      food = 0
    end
    if hydration > 0.01*dt then
      hydration = hydration - 0.01*dt
    elseif hydration < 0.01*dt then
      hydration = 0      
    end
    if occupation == 3 and sleep < 1 then
      if task == 2 then
	sleep = sleep + 0.03*dt
      elseif task == 1 then
	sleep = sleep + 0.02*dt
      end
      if sleep > 1 then
	sleep = 1
      end
    elseif occupation == 2 then
      if task == 2 then
	if conscience < 1 and conscience + 0.01*dt <= 1 then
	  conscience = conscience + 0.01*dt
	end
      elseif task == 1 then
	if overburn > 0 and overburn - 0.03*dt >= 0 then
	  overburn = overburn - 0.03*dt
	elseif overburn < 0.03*dt then
	  overburn = 0
	end
      end
    elseif occupation == 1 then
      if task == 2 then
	if overburn < 1 and overburn + 0.01*dt <= 1 then
	  overburn = overburn + 0.01*dt
	elseif overburn + 0.01*dt > 1 then
	  overburn = 1
	end
      elseif task == 1 then
	if overburn > 0 and overburn - 0.02*dt >= 0 then
	  overburn = overburn - 0.02*dt
	elseif overburn < 0.02*dt then
	  overburn = 0
	end
      end
    end
    hours = math.floor(timer/3600)
    minutes = math.floor((timer%3600)/60)
  end
  if food == 0 then
      performGameUpdate = false
      gui.Label{text = "You died of hunger", pos = {100, 500}, size = {100}}
  end
  if hydration == 0 then
    performGameUpdate = false
    gui.Label{text = "You died of dehydration", pos = {100, 525}, size = {100}}
  end
  if sleep == 0 then
    performGameUpdate = false
    gui.Label{text = "You fell asleep forever", pos = {100, 550}, size = {100}}
  end
  gui.Label{text = numToStr(hours) .. ":" .. numToStr(minutes), pos = {100, 100}}
  gui.group{grow = "down", pos = {0, 200}, function()
    gui.group{grow = "right", function()
      gui.Label{text = "food", size = {100}}
      gui.Slider{info = {value = food}}
    end}
    gui.group{grow = "right", function()
      gui.Label{text = "hydration", size = {100}}
      gui.Slider{info = {value = hydration}}
    end}
    gui.group{grow = "right", function()
      gui.Label{text = "conscience", size = {100}}
      gui.Slider{info = {value = conscience}}
    end}
    gui.group{grow = "right", function()
      gui.Label{text = "overburn", size = {100}}
      gui.Slider{info = {value = overburn}}
    end}
    gui.group{grow = "right", function()
      gui.Label{text = "sleep", size = {100}}
      gui.Slider{info = {value = sleep}}
    end}
  end}
  x, y = love.mouse.getPosition()
  if x >= 212 and x <= 311 and y >= 188 and y <= 313 then
    gui.Label{text = "Bed", pos = {600, 100}, size = {100}}
  end
  if x >= 539 and x <= 602 and y >= 189 and y <= 287 then
    gui.Label{text = "Computer", pos = {600, 100}, size = {100}}
  end
  if x >= 333 and x <= 421 and y >= 0 and y <= 144 then
    gui.Label{text = "Outside", pos = {600, 100}, size = {100}}
  end
  if x >= 534 and x <= 593 and y >= 351 and y <= 442 then
    gui.Label{text = "Fridge", pos = {600, 100}, size = {100}}
  end
end

function numToStr(int)
  if int < 10 then return "0"..int else return int end
end


function love.draw()
  arc.clear_key()
  x, y = love.mouse.getPosition()
  if x >= 333 and x <= 421 and y >= 0 and y <= 144 then
    love.graphics.setColor(180, 180, 180, 180)
  else
    love.graphics.setColor(120, 120, 120, 120)
  end
  love.graphics.rectangle("fill", 300, 0, 150, 144)
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(sprites[3], 0, 0)
  if x >= 539 and x <= 602 and y >= 189 and y <= 287 then
    love.graphics.setColor(180, 180, 180, 180)
  else
    love.graphics.setColor(120, 120, 120, 120)
  end
  love.graphics.draw(sprites[2], 571, 238, 0, 4, 4, 8, 12)
  if x >= 212 and x <= 311 and y >= 188 and y <= 313 then
    love.graphics.setColor(255,255,255,255)
  else
    love.graphics.setColor(200,200,200,255)
  end
  love.graphics.draw(sprites[4], 220, 300, math.rad(-70), 5)
  if x >= 534 and x <= 593 and y >= 351 and y <= 442 then
    love.graphics.setColor(255,255,255,255)
  else
    love.graphics.setColor(200,200,200,255)
  end
  love.graphics.draw(sprites[5], 533, 348, 0, 4, 4)
  stability = math.min(conscience, food, hydration, (1 - overburn), sleep)*255
  love.graphics.setColor(stability,stability,stability,255)
  if occupation == 3 then
    love.graphics.draw(sprites[1], 270, 200, math.rad(20), 4)
  elseif occupation == 2 then
    love.graphics.draw(sprites[1], -100, -100, 0, 4, 4)
  elseif occupation == 1 then
    love.graphics.draw(sprites[1], 543, 226, 0, 4, 4)
  end
  gui.core.draw()
end

function love.keypressed(k, unicode)
  arc.set_key(k)
  if k == "escape" then
    love.event.push('quit')
  end
end

function love.mousereleased(x, y,  button)
  if button == "l" then
    if x >= 212 and x <= 311 and y >= 188 and y <= 313 then
      occupation = 3
      task = 2
    end
    if x >= 539 and x <= 602 and y >= 189 and y <= 287 then
      occupation = 1
      task = 2
    end
    if x >= 333 and x <= 421 and y >= 0 and y <= 144 then
      occupation = 2
      task = 1
    end
  elseif button == "m" then
    print(x .. " " .. y)
  end
end