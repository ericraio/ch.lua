--[[
LIB MOSTLY BY RAIO ERIC
EXAMPLE.lua BY  Kotarou
LIB STATUS: NOT DONE
]]
require('ch')


function onConnect(room)
	print(room.name ..  ' ' .. 'connected')
	end
function onDisconnect(room)
	print(room.name .. ' ' .. 'disconnected')
	end
function onMessage(...)
	print(...)
	end

function onInit()
	event['onMessage'] = onMessage
	event['onDisconnect'] = onDisconnect
	event['onConnect'] = onConnect
	login['username'] = 'username'
	login['password'] = 'password'
	login['rooms'] = {'ccschrome', 'botplayzone'}
	end
event['onInit'] = onInit

--START LOOP
self.init()
