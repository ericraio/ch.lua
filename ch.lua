local socket = require('socket')
local io = require('io')
local _ = require('underscore')


local tsweights = {
                    {  '5' , 61  }, {  '7' , 61  }, {  '6' , 61  }, {  '8' , 61  },
                    { '16' , 6   }, { '17' , 61  }, {  '9' , 90  }, { '11' , 90  },
                    { '13' , 90  }, { '14' , 90  }, { '15' , 90  }, { '23' , 110 },
                    { '24' , 110 }, { '25' , 110 }, { '28' , 104 }, { '29' , 104 },
                    { '30' , 104 }, { '31' , 104 }, { '32' , 104 }, { '33' , 104 },
                    { '35' , 101 }, { '36' , 101 }, { '37' , 101 }, { '38' , 101 },
                    { '39' , 101 }, { '41' , 101 }, { '40' , 101 }, { '42' , 101 },
                    { '43' , 101 }, { '44' , 101 }, { '45' , 101 }, { '46' , 101 },
                    { '47' , 101 }, { '48' , 101 }, { '49' , 101 }, { '50' , 101 }
                 }

function connect(network, port)
  client = socket.tcp()
  client:settimeout(300) -- 5 minute timeout
  local result, err = client:connect(network, port)
  if err then print("Connection Error: "..err) end
  print("Connection Result: "..result)
end

function increment(table, key, value)
  table[key] = table[key] + (value or 1)
end

function get_server(room)
  local group = room:gsub("-", "q")
  local fnv = tonumber(string.sub(group, 1, 5), 36)
  local lnv = string.sub(room, 7, (6 + string.len(string.sub(room, 1, 3))))
  local maxnum = 3386
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

function get_room()
  local answer
  io.write('What is the room name? ')
  io.flush()
  answer = io.read()
  return answer
end

function get_name()
  local answer
  io.write('What is your screen name? ')
  io.flush()
  answer = io.read()
  return answer
end

function get_password()
  io.write("What is your password? \027[s")
  local password = io.read()
  io.write('\027[u',('*'):rep(#password),'\n')
  return password
end

function authenticate(room)
  local authenticate_order = {"bauth", room, generate_uid()}
  print(table.concat(authenticate_order, ':'))
  return client:send(table.concat(authenticate_order, ':') .. '\0')
end

function login(user_name, password)
  send("blogin", user_name, password)
end

function generate_uid()
  local num1 = math.random(10^7, 10^8)
  local num2 = math.random(10^7, 10^8)
  uid = tostring(num1)..tostring(num2)
  return uid
end

function send(...)
  local args = {...}
  print(table.concat(args, ':') .. '\r\n\0')
  return client:send(table.concat(args, ':') .. '\r\n\0')
end

function loop()
  while not err do
    result, err = client:receive()
    if not (res == nil) then
      print("recv: " .. result)
    else
      print("recv is nil")
    end
  end
  print("Error in Loop: "..err)

  running = false
  return false -- TODO: Handle "proper" shutdowns
end

function main()
  running = true
  room = get_room()
  server = get_server(room)
  connect(server, 443)
  return loop()
end

main()
