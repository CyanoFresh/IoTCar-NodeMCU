-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there
dofile("credentials.lua")

-- Init pins modes
gpio.mode(in1, gpio.OUTPUT)
gpio.mode(in2, gpio.OUTPUT)
gpio.mode(in3, gpio.OUTPUT)
gpio.mode(in4, gpio.OUTPUT)
gpio.mode(enA, gpio.OUTPUT)
gpio.mode(enB, gpio.OUTPUT)

pwm.setup(enA, 1000, 0)
pwm.setup(enB, 1000, 0)

-- Write default pin values
gpio.write(in1, 1)
gpio.write(in2, 0)
gpio.write(in3, 0)
gpio.write(in4, 1)

pwm.start(enB)
pwm.start(enA)

function startup()
    if file.open("init.lua") == nil then
        print("init.lua deleted or renamed")
    else
        print("Running")
        file.close("init.lua")
        dofile("application.lua")
    end
end

print("Connecting to WiFi access point...")

wifi.setmode(wifi.STATION)
wifi.sta.config(SSID, PASSWORD)

tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("Waiting for IP address...")
    else
        tmr.stop(1)
        print("WiFi connection established, IP address: " .. wifi.sta.getip())
        print("You have 3 seconds to abort")
        print("Waiting...")
        tmr.alarm(0, 3000, 0, startup)
    end
end)
