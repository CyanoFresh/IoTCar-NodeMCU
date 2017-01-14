ws = websocket.createClient()

ws:on("connection", function(ws)
    print('Connected to WS server')
end)

ws:on("receive", function(_, msg, opcode)
    print('Received message: ', msg, opcode) -- opcode is 1 for text message, 2 for binary

    local data = cjson.decode(msg)

    if data.type == "move.forward" then
        -- Start move
        gpio.write(in1, 1)
        gpio.write(in2, 0)
        gpio.write(in3, 0)
        gpio.write(in4, 1)

        pwm.setduty(enA, 1023)
        pwm.setduty(enB, 1023)

        print('move start')
        tmr.alarm(moveTimer, 500, tmr.ALARM_SINGLE, function()
            print('move end')
            -- Stop move
            pwm.setduty(enA, 0)
            pwm.setduty(enB, 0)

            ws:send(cjson.encode({
                type = "move.forward.done"
            }))
        end)
    elseif data.type == "move.backward" then
        -- Start move
        gpio.write(in1, 0)
        gpio.write(in2, 1)
        gpio.write(in3, 1)
        gpio.write(in4, 0)

        pwm.setduty(enA, 1023)
        pwm.setduty(enB, 1023)

        print('move start')
        tmr.alarm(moveTimer, 500, tmr.ALARM_SINGLE, function()
            print('move end')
            -- Stop move
            pwm.setduty(enA, 0)
            pwm.setduty(enB, 0)

            ws:send(cjson.encode({
                type = "move.backward.done"
            }))
        end)
    elseif data.type == "move.left" then
        -- Start move
        gpio.write(in1, 0)
        gpio.write(in2, 1)
        gpio.write(in3, 0)
        gpio.write(in4, 1)

        pwm.setduty(enA, 1023)
        pwm.setduty(enB, 1023)

        print('move start')
        tmr.alarm(moveTimer, 700, tmr.ALARM_SINGLE, function()
            print('move end')
            -- Stop move
            pwm.setduty(enA, 0)
            pwm.setduty(enB, 0)

            ws:send(cjson.encode({
                type = "move.left.done"
            }))
        end)
    elseif data.type == "move.right" then
        -- Start move
        gpio.write(in1, 1)
        gpio.write(in2, 0)
        gpio.write(in3, 1)
        gpio.write(in4, 0)

        pwm.setduty(enA, 1023)
        pwm.setduty(enB, 1023)

        print('move start')

        tmr.alarm(moveTimer, 700, tmr.ALARM_SINGLE, function()
            print('move end')
            -- Stop move
            pwm.setduty(enA, 0)
            pwm.setduty(enB, 0)

            ws:send(cjson.encode({
                type = "move.right.done"
            }))
        end)
    end
end)

ws:on("close", function(_, status)
    print('WebSocket disconnected', status)
    print("Reconnect in 3 sec...")

    tmr.alarm(reconnectWSSTimer, 3000, tmr.ALARM_SINGLE, function()
        connect()
    end)
end)

function connect()
    print("Connecting to WS server...")
    ws:connect(WSURL)
end

connect()
