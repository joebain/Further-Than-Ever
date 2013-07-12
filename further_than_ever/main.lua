require "pos"
require "sounds"
require "tiles"
require "man"
require "bird"

intro = {
	"Catch the birds.",
	"The birds are loose.",
	"Every time you catch a bird you do some good.",
	"There are too many birds.",
	"This bird's name is Bertie.",
	"This bird drinks too much.",
	"Alcoholism is a problem for some birds.",
	"This bird is called Queenie.",
	"Transgenderism is not fully accepted.",
	"Get those birds!",
	"Some birds are better than others.",
	"There are no rules for birds.",
	"Birds live in anarchy.",
	"Birds are scared of larger birds.",
	"Birds don't have a conception of nets.",
	"There is not much jealousy among birds.",
	"There is some jealousy.",
	"Some birds wish they were bigger birds.",
	"No more birds."}

stage = man.net.min_length + 1
stages = man.net.max_length + 1

all_birds = {}

position = {}
text_position = {}
text_position.x = 0
text_position.y = 0

nice_font = nil

quitting = false

function love.load()
	love.graphics.setMode(
		(tiles.width + tiles.border.left + tiles.border.right) * tiles.tile_size,
		(tiles.height + tiles.border.top + tiles.border.bottom) * tiles.tile_size)

		for i,v in ipairs(love) do
			print(i .. ": " .. v)
		end

	love.graphics.setBackgroundColor(255,255,255)

	nice_font = love.graphics.newFont("oblik_serif_bold.otf" , 24)
	love.graphics.setFont(nice_font)
	
	position.y = love.graphics.getHeight() / 2
	position.x = love.graphics.getWidth() / 2
	
	text_position.y = love.graphics.getHeight() - (nice_font:getHeight() + tiles.tile_size * 0.5)
	
    sounds.init()
    man.init()
	tiles.init()

	sounds.add_loop_change_cb(new_bird)
--    new_bird()
	if love.mouse.isVisible() then
		love.mouse.setVisible(false)
	end
end

function love.draw()

    tiles.draw()
    man.draw()
	-- text
    text_id = 1
        text_id = stage - man.net.min_length
--		print ("text: " .. text_id .. ", " .. #intro)
	love.graphics.setColor( 0,0,0, 255 )
    love.graphics.print(intro[text_id], text_position.x, text_position.y)
    
--    love.graphics.print(stage, 0, 0)
    
end

function love.update(dt)
	sounds.update(dt)
    man.update(dt)
	tiles.update(dt)
end

function stage_up()
	if tiles.finishing then return end
	old_stage = stage
    stage = stage + 1
	--print("stage " .. stage .. " old " .. old_stage)
	stage = math.min(stage, man.net.max_length-2)
	man.net.length = stage
	sounds.go_stage(stage)
	if stage ~= old_stage then
		sounds.stage_up()
	end

	if stage >= man.net.max_length-2 then
		--print("finishing")
		tiles.finishing = true
	end
end

function stage_down()
	if tiles.finishing then return end
	old_stage = stage
    stage = stage - 1
	--print("stage " .. stage)
	stage = math.max(stage, man.net.min_length + 1)
	man.net.length = stage
	sounds.go_stage(stage)
	if stage ~= old_stage then
		sounds.stage_down()
	end
end

function love.keypressed(key, id)
	if key == 'q' then
		stage_up()
	elseif key == 'a' then
		stage_down()
	elseif key == 'f' then
		love.graphics.toggleFullscreen()
	elseif key == 'escape' then
		quitting = true
    end
end

function new_bird()
	if stage < stages then
		b = bird.new()
		table.insert(all_birds, b)
		b:init()
	end
end

