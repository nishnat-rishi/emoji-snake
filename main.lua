function love.load()
  arena_size = 11
  pixel_size = 60
  love.window.setMode(pixel_size * arena_size, pixel_size * arena_size)
  love.window.setTitle('Emoji Snake')
  math.randomseed(os.time())
  love.graphics.setBackgroundColor(255, 255, 255)
  emoji_img = love.graphics.newImage('emoji.jpg')
  emoji = {}
  emoji_size = 60
  emoji_rows, emoji_columns = 8, 7
  load_emoji(emoji, emoji_rows, emoji_columns, emoji_img)
  b = 8
  timer = 3
  tick = 5
  state = 1
  
  snake = {}
  snake[1] = {x = 0, y = 0, q = {x = math.random(emoji_rows), y = math.random(emoji_columns)}}
  direction = {x = 1, y = 0}
  direction_buffer = {x = 1, y = 0}
  
  drop = {x = math.random(arena_size-1), y = math.random(arena_size-1), q = {x = math.random(emoji_rows), y = math.random(emoji_columns)}}
end


function love.update(dt)
  if state == 1 then
    if timer > 0 then
      timer = timer - tick * dt
    else
      direction.x, direction.y = direction_buffer.x, direction_buffer.y
      for i = 2, #snake-1 do
        if (snake[1].x + direction.x) % arena_size == snake[i].x and (snake[1].y + direction.y) % arena_size == snake[i].y then
          -- Display Score, wait for 5 seconds and execute love.load() (Make wrapper function for Timer)
          state = 0
          display_end_screen()
          -- love.load()
          break
        end
      end
      if (snake[1].x + direction.x) % arena_size == drop.x and (snake[1].y + direction.y) % arena_size == drop.y then
        table.insert(snake, 1, {x = drop.x, y = drop.y, q = {x = drop.q.x, y = drop.q.y}})
        drop = {x = math.random(arena_size-1), y = math.random(arena_size-1), q = {x = math.random(emoji_rows), y = math.random(emoji_columns)}}
        tick = tick + 1
      else
        snake_update(direction)
      end
      timer = 3
    end
  end
end

function love.draw()
  for k = #snake, 1, -1 do
      love.graphics.draw(emoji_img, emoji[snake[k].q.x][snake[k].q.y], snake[k].x * pixel_size + b/2, snake[k].y * pixel_size + b/2)
  end
  love.graphics.draw(emoji_img, emoji[drop.q.x][drop.q.y], drop.x * pixel_size + b/2, drop.y * pixel_size + b/2)
end

function load_emoji(emoji, emoji_rows, emoji_columns, emoji_img)
  for i = 0, emoji_rows-1 do
    table.insert(emoji, {})
    for j = 0, emoji_columns-1 do
      emoji[i+1][j+1] = love.graphics.newQuad(i * emoji_size, j * emoji_size, emoji_size, emoji_size, emoji_img:getDimensions())
    end
  end
end

function display_end_screen()
  love.load()
end

function snake_update(direction)
  for i = #snake, 2, -1 do
    snake[i].x, snake[i].y = snake[i-1].x, snake[i-1].y
  end
  snake[1].x, snake[1].y = (snake[1].x + direction.x) % arena_size, (snake[1].y + direction.y) % arena_size
end

function love.keypressed(key)
  if key == 'left' and direction.x ~= 1 then
    direction_buffer.x, direction_buffer.y = -1, 0
  elseif key == 'right' and direction.x ~= -1 then
    direction_buffer.x, direction_buffer.y = 1, 0
  elseif key == 'up' and direction.y ~= 1 then
    direction_buffer.x, direction_buffer.y = 0, -1
  elseif key == 'down' and direction.y ~= -1 then
    direction_buffer.x, direction_buffer.y = 0, 1
  end
end