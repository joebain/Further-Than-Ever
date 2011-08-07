sounds = {}

sounds.drums1 = nil
sounds.bass1 = nil
sounds.love1 = nil

sounds.tracks = {}
sounds.bar_change_cbs = {}
sounds.beat_change_cbs = {}
sounds.loop_change_cbs = {}

sounds.loop_length = 14.9
sounds.start_time = 0
sounds.first_bar = true
sounds.loop_time = 0
sounds.loop_position = 0
sounds.beat_position = 0
sounds.old_beat = 0
sounds.beat = 0
sounds.bar_position = 0
sounds.old_bar = 0
sounds.bar = 0

sounds.flap_count = 1

function sounds.init()
    sounds.drums1 = love.audio.newSource("drum1.ogg", "static")
    sounds.bass1 = love.audio.newSource("new_bass.ogg", "static")
    sounds.love1 = love.audio.newSource("new_plink.ogg", "static")
    sounds.grow = {}
	sounds.grow[1] = love.audio.newSource("grow_1.ogg", "static")
	sounds.grow[2] = love.audio.newSource("grow_2.ogg", "static")
	sounds.grow[3] = love.audio.newSource("grow_3.ogg", "static")
    sounds.shrink = {}
	sounds.shrink[1] = love.audio.newSource("shrink_1.ogg", "static")
	sounds.shrink[2] = love.audio.newSource("shrink_2.ogg", "static")
	sounds.shrink[3] = love.audio.newSource("shrink_3.ogg", "static")
    sounds.flap = {}
	sounds.flap[1] = love.audio.newSource("flap_1.ogg", "static")
	sounds.flap[2] = love.audio.newSource("flap_2.ogg", "static")
	sounds.flap[3] = love.audio.newSource("flap_3.ogg", "static")
    
	sounds.drums1:play()
    
    sounds.tracks.drums = sounds.drums1
--	sounds.tracks.bass = sounds.bass1
--	sounds.tracks.love = sounds.love1
    sounds.start_time = love.timer.getMicroTime()
end

function sounds.update(dt)
    sounds.loop_time = sounds.loop_time + dt
    sounds.loop_position = sounds.loop_time / sounds.loop_length
    sounds.beat_position = (sounds.loop_position * 16) % 4
    sounds.bar_position = (sounds.loop_position * 4)
   
	if sounds.tracks.drums == nil then return end
    if sounds.tracks.drums:isStopped() then
		if sounds.first_bar then
			sounds.loop_length = love.timer.getMicroTime() - sounds.start_time
			sounds.first_bar = false
			--print("loop length is " .. sounds.loop_length)
		end

		for name,track in pairs(sounds.tracks) do
			track:play()
		end

		if sounds.loop_time < sounds.loop_length/2 then
--            print("uh oh, too soon")
		else

			--        print("loop" .. os.clock())
			for i,cb in ipairs(sounds.loop_change_cbs) do
				sounds.flap[sounds.flap_count]:play()
				sounds.flap_count = sounds.flap_count + 1
				if sounds.flap_count > 3 then sounds.flap_count = 1 end
				if cb[2] ~= nil then
					cb[1](cb[2])
				else
					cb[1]()
				end
			end

		end

		sounds.loop_time = 0
    end
    
	sounds.bar = math.floor(sounds.bar_position)
	if sounds.bar ~= sounds.old_bar then
		sounds.old_bar = sounds.bar
	--	print("bar")
        for i,cb in ipairs(sounds.bar_change_cbs) do
            if cb[2] ~= nil then
				cb[1](cb[2])
			else
				cb[1]()
			end
		end
	end
	sounds.beat = math.floor(sounds.beat_position)
	if sounds.beat ~= sounds.old_beat then
		sounds.old_beat = sounds.beat
--		print("beat")
        for i,cb in ipairs(sounds.beat_change_cbs) do
            if cb[2] ~= nil then
				cb[1](cb[2])
			else
				cb[1]()
			end
		end
	end
end

function sounds.add_loop_change_cb(func, self)
    sounds.loop_change_cbs[#sounds.bar_change_cbs+1] = {func, self}
end

function sounds.add_bar_change_cb(func, self)
    sounds.bar_change_cbs[#sounds.bar_change_cbs+1] = {func, self}
end

function sounds.add_beat_change_cb(func, self)
    sounds.beat_change_cbs[#sounds.beat_change_cbs+1] = {func, self}
end

function sounds.go_stage(stage)
     if stage == 10 then
         sounds.tracks.bass = sounds.bass1
	 elseif stage == 15 then
		 sounds.tracks.lead = sounds.love1
     end
end

function sounds.stage_up()
	sounds.grow[math.random(3)]:play()
end

function sounds.stage_down()
	sounds.shrink[math.random(3)]:play()
end
