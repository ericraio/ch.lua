_=require('underscore')
http=require('socket.http')
sock=require('socket')
--[[
to-do
# FIX SOCKETS
# ADD SOCKET SELECT
# MAKE PM class
# FINISH example.lua
# ADD SPECIALS INTO ch_getServer
# CLEAN UP

]]
--[[
I like to call these classes since lua does not actually have them
i like that a bit better then python
--]]
message = {} -- holds everything to do with the message e.g message.body, message.body.msgid, message.ip and so on
user={} -- holds everything to do with the user e.g user.name, user.name.uid and so on
global={} -- holds everything to do with multiple rooms such as global.room.message
room={} -- holds everything about the room e.g room.name, room.message, room.mod.delete and so om
self={} -- used for things like connecting disconnecting and so on
sock={} -- used to hold the socket connection
event = {} -- used for onMessage, onReconnect, onDisconnect, etc
login = {} -- holds the user, password, rooms
sp = {}
self['connected'] = false
local count = 1 -- for room array
local w12 = 75
local sv2 = 95
local sv4 = 110
local sv6 = 104
local sv8 = 101
local sv10 = 110
local sv12 = 116
local tsweights = {{"5", w12}, {"6", w12}, {"7", w12}, {"8", w12}, {"16", w12}, {"17", w12}, {"18", w12}, {"9", sv2}, {"11", sv2}, {"12", sv2}, {"13", sv2}, {"14", sv2}, {"15", sv2}, {"19", sv4}, {"23", sv4}, {"24", sv4}, {"25", sv4}, {"26", sv4}, {"28", sv6}, {"29", sv6}, {"30", sv6}, {"31", sv6}, {"32", sv6}, {"33", sv6}, {"35", sv8}, {"36", sv8}, {"37", sv8}, {"38", sv8}, {"39", sv8}, {"40", sv8}, {"41", sv8}, {"42", sv8}, {"43", sv8}, {"44", sv8}, {"45", sv8}, {"46", sv8}, {"47", sv8}, {"48", sv8}, {"49", sv8}, {"50", sv8}, {"52", sv10}, {"53", sv10}, {"55", sv10}, {"57", sv10}, {"58", sv10}, {"59", sv10}, {"60", sv10}, {"61", sv10}, {"62", sv10}, {"63", sv10}, {"64", sv10}, {"65", sv10}, {"66", sv10}, {"68", sv2}, {"71", sv12}, {"72", sv12}, {"73", sv12}, {"74", sv12}, {"75", sv12}, {"76", sv12}, {"77", sv12}, {"78", sv12}, {"79", sv12}, {"80", sv12}, {"81", sv12}, {"82", sv12}, {"83", sv12}, {"84", sv12}}
local sp = {}
sp['mitvcanal'] = 56
sp['magicc666'] = 22
sp['livenfree'] = 18
sp['eplsiite'] = 56
sp['soccerjumbo2'] = 21
sp['bguk'] = 22
sp['animachat20'] = 34
sp['pokemonepisodeorg'] = 55
sp['sport24lt'] = 56
sp['mywowpinoy'] = 5
sp['phnoytalk'] = 21
sp['flowhot-chat-online'] = 12
sp['watchanimeonn'] = 26
sp['cricvid-hitcric-'] = 51
sp['fullsportshd2'] = 18
sp['chia-anime'] = 12
sp['narutochatt'] = 52
sp['ttvsports'] = 56
sp['futboldirectochat'] = 22
sp['portalsports'] = 18
sp['stream2watch3'] = 56
sp['proudlypinoychat'] = 51
sp['ver-anime'] = 34
sp['iluvpinas'] = 53
sp['vipstand'] = 21
sp['eafangames'] = 56
sp['worldfootballusch2'] = 18
sp['soccerjumbo'] = 21
sp['myfoxdfw'] = 22
sp['animelinkz'] = 20
sp['rgsmotrisport'] = 51
sp['bateriafina-8'] = 8
sp['as-chatroom'] = 10
sp['dbzepisodeorg'] = 12
sp['tvanimefreak'] = 54
sp['watch-dragonball'] = 19
sp['narutowire'] = 10
sp['leeplarp'] = 27

function split( sInput, sSeparator )
    local tReturn = {}
    for w in sInput:gmatch( "[^"..sSeparator.."]+" ) do
        table.insert( tReturn, w )
    end
    return tReturn
end

local function ch_getServer(Room)
  local group = Room:gsub("-", "q")
  local fnv = tonumber(string.sub(group, 1, 5), 36)
  local lnv = string.sub(Room, 7, (6 + string.len(string.sub(Room, 1, 3))))
  local maxnum = _.reduce(_.map(tsweights, function(x) return x[2] end), 0, function(memo, i) return memo + i end)
	local cumfreq = 0
	local sn = 0

  if lnv then
    lnv = tonumber(lnv, 36)
    if lnv <= 1000 then
      lnv = 1000
    end
  else
    lnv = 1000
  end

  local num = (fnv % lnv) / lnv

  for index, wgt in pairs(tsweights) do
    cumfreq = cumfreq + (wgt[2] / maxnum)
    if num <= cumfreq then
      sn = tonumber(wgt[1])
      break
    end
  end
  print('Server: '..'s'.. sn ..'.chatango.com')
  return 's' .. sn .. '.chatango.com'
end
room['getServer'] = ch_getServer

local function uid()
  local num1 = math.random(10^7, 10^8)
  local num2 = math.random(10^7, 10^8)
  uid = tostring(num1)..tostring(num2)
  return uid
end
self['uid'] = uid
--change later for pm--
self['port'] = 443
function ch_connect(addr)
	self.connected = true
	local serv = room.getServer(addr)
	con = socket.tcp()
	con:settimeout(500)
	local res, err = con:connect(serv, self.port)
	sock[addr] = con
	sock['sock'] = con
	room['name'] = addr
	con:send('bauth' .. ':' .. addr .. ':' .. self.uid() .. ':' .. login.username ..':' .. login.password ..'\0')
	print(res)
	count = count + 1
	if err then
		return false
	else
		event.onConnect(room)
		return true
	end
end
self['connect'] = ch_connect
local function ch_getEvents(args)
	local event
	local Room
	local arg
	str= split(args, ':')
	a, b, c, e = str[1], str[2], str[3], str[4]
	event = a
	print(event)
	if event == 'ok' then
		room.sendCommand(room.name, "getpremium","1")
		room.sendCommand("msgbg", "1")

	end
	-- can't get this to call ;(
	if event == 'bmsg' then
		print('called')
	end
end

self['getEvent'] = ch_getEvents
local function ch_handler()
    while self.connected do
        res, err = con:receive(3000)
        if not (res == nil) then
            self.getEvent(res)
		else error(err) end
        end
    end
end
self['handle'] = ch_handler

local function send(...)
	local args = {...}
	return sock[room.name]:send(table.concat(args, ':') .. '\0')
end
room['sendCommand'] = send
local function ch_init()
	event.onInit() -- called inside bot script, what it does is set the OnMessage, onDiconnect
	while not(login.rooms[count] == nil) do
		self.connect(login.rooms[count])
	end
	self.handle()
end
self['init'] = ch_init

