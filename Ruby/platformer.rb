require 'ruby2d'

set width: 800
set height: 600

RUN_SPEED = 4
JUMP_SPEED = -16
GRAVITY = 0.7

Image.new(
  'background.png',
  x: 0, y: 0,
  width: 800, height: 600
)

$player = Sprite.new(
     'player.png',
     width: 37.5,
     height: 50,
     clip_width: 75,
     time: 100,
     y: 450
)

$player_horizontal_movement = 0
$player_vertical_movement = 0
$player_is_grounded = false


$world_shift = 0
$min_world_shift = 0
$max_world_shift = 500


$platforms = [
  Sprite.new('platform.png', width: 50, height: 50, x: 0, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 150, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 200, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 250, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 250, y: 500),
  Sprite.new('platform.png', width: 50, height: 50, x: 250, y: 450),
  Sprite.new('platform.png', width: 50, height: 50, x: 150, y: 350),
  Sprite.new('platform.png', width: 50, height: 50, x: 0, y: 250),
  Sprite.new('platform.png', width: 50, height: 50, x: 50, y: 100),
  Sprite.new('platform.png', width: 50, height: 50, x: 100, y: 100),
  Sprite.new('platform.png', width: 50, height: 50, x: 150, y: 100),
  Sprite.new('platform.png', width: 50, height: 50, x: 200, y: 100),
  Sprite.new('platform.png', width: 50, height: 50, x: 250, y: 100),
  Sprite.new('platform.png', width: 50, height: 50, x: 300, y: 100),
  Sprite.new('platform.png', width: 50, height: 50, x: 400, y: 300),
  Sprite.new('platform.png', width: 50, height: 50, x: 550, y: 300),
  Sprite.new('platform.png', width: 50, height: 50, x: 700, y: 300),
  Sprite.new('platform.png', width: 50, height: 50, x: 850, y: 300),
  Sprite.new('platform.png', width: 50, height: 50, x: 900, y: 300),
  Sprite.new('platform.png', width: 50, height: 50, x: 900, y: 250),
  Sprite.new('platform.png', width: 50, height: 50, x: 900, y: 200),
  Sprite.new('platform.png', width: 50, height: 50, x: 900, y: 150),
  Sprite.new('platform.png', width: 50, height: 50, x: 900, y: 100),
  Sprite.new('platform.png', width: 50, height: 50, x: 850, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 900, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 950, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 1000, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 1050, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 1100, y: 550),
  Sprite.new('platform.png', width: 50, height: 50, x: 1200, y: 400),
  Sprite.new('platform.png', width: 50, height: 50, x: 1250, y: 400),
  Sprite.new('platform.png', width: 50, height: 50, x: 1050, y: 250),
  Sprite.new('platform.png', width: 50, height: 50, x: 1100, y: 250),
  Sprite.new('platform.png', width: 50, height: 50, x: 1200, y: 100),
  Sprite.new('platform.png', width: 50, height: 50, x: 1250, y: 100),
]

$spikes = [
  Sprite.new('spike.png', width: 50, height: 50, x: 0, y: 300),
  Sprite.new('spike.png', width: 50, height: 50, x: 950, y: 500, rotate: 180),
  Sprite.new('spike.png', width: 50, height: 50, x: 1000, y: 500, rotate: 180),
]

$finish = Sprite.new('finish.png', width: 50, height: 50, x: 1250, y: 50)

$all_objects = $platforms + $spikes + [$finish]

def move_horizontal
  unless world_scroll
    $player.x += $player_horizontal_movement
  end
  if $player_horizontal_movement > 0
    $player_horizontal_movement -= RUN_SPEED / 4
  elsif $player_horizontal_movement < 0
    $player_horizontal_movement += RUN_SPEED / 4
  end

  if $player_horizontal_movement.abs < 0.5
    $player_horizontal_movement = 0
  end
end

def move_vertical
  $player.y += $player_vertical_movement
  $player_vertical_movement += GRAVITY
  if $player_vertical_movement > 1.5
    $player_is_grounded = false
  end

  if $player.y < 0 && $player_vertical_movement < 0
    $player_vertical_movement = 0
  end
end

def box_collision(object, make_smaller_by = 0)
  if ($player.x <= object.x + object.width - make_smaller_by && $player.x + $player.width - make_smaller_by >= object.x) &&
    ($player.y <= object.y + object.height - make_smaller_by && $player.y + $player.height - make_smaller_by >= object.y)
    return true
  end
  return false
end

def check_horizontal_collision(platform)
  if $player_horizontal_movement < 0
    $player.x = platform.x - $player.width
  elsif $player_horizontal_movement > 0
    $player.x = platform.x + platform.width
  end
end

def horizontal_move_and_collide
  move_horizontal

  $platforms.each do |platform|
    if box_collision(platform)
      if $player_horizontal_movement < 0
        $player.x = platform.x + platform.width + 1
        $player_horizontal_movement = 0
      elsif $player_horizontal_movement > 0
        $player.x = platform.x - $player.width - 1
        $player_horizontal_movement = 0
      end
    end
  end
end

def vertical_move_and_collide
  move_vertical

  $platforms.each do |platform|
    if box_collision(platform)
      if $player_vertical_movement > 0
        $player.y = platform.y - platform.height - 1
        $player_vertical_movement = 0
        $player_is_grounded = true
      elsif $player_vertical_movement < 0
        $player.y = platform.y + $player.height + 1
        $player_vertical_movement = 0
      end
    end
  end
end

def world_scroll
  if $player_horizontal_movement < 0 && $world_shift > $min_world_shift && $player.x <= Window.width * 0.25
    $all_objects.each do |object|
      object.x -= $player_horizontal_movement
    end

    $world_shift += $player_horizontal_movement
    return true
  elsif $player_horizontal_movement > 0 && $world_shift < $max_world_shift && $player.x >= Window.width * 0.75
    $all_objects.each do |object|
      object.x -= $player_horizontal_movement
    end

    $world_shift += $player_horizontal_movement
    return true
  end
  return false
end

def check_spikes
  $spikes.each do |spike|
    if box_collision(spike, 15)
      die
    end
  end
end

def check_fall
  if $player.y > Window.height
    die
  end
end

def check_win
  if box_collision($finish)
    clear
    Text.new('You win!', x: 380, y: 270, style: 'bold', size: 20)
  end
end

def die
  $all_objects.each do |object|
    object.x += $world_shift
  end
  $world_shift = 0

  $player.x = 0
  $player.y = 450
  $player_horizontal_movement = 0
  $player_vertical_movement = 0
end


on :key_held do |event|
  case event.key
  when 'left'
    $player.play flip: :horizontal
    if $player.x > 0
      $player_horizontal_movement -= RUN_SPEED / 2
      if $player_horizontal_movement.abs > RUN_SPEED
        $player_horizontal_movement = -RUN_SPEED
      end
    end
  when 'right'
    $player.play
    if $player.x < (Window.width - $player.width)
      $player_horizontal_movement += RUN_SPEED / 2
      if $player_horizontal_movement > RUN_SPEED
        $player_horizontal_movement = RUN_SPEED
      end
    end
  end
end

on :key_up do
  $player.stop
end

on :key_down do |event|
  case event.key
  when 'space'
    if $player_is_grounded
      $player_vertical_movement += JUMP_SPEED
      $player_is_grounded = false
    end
  end
end


update do
  horizontal_move_and_collide
  vertical_move_and_collide

  check_spikes
  check_fall
  check_win
end

show
