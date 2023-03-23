local function clientBeep()
  TriggerClientEvent('AB3:ServerBeep', -1, source)
end

if Config.ThrottleServerEvents then
  local drop = Config.ThrottleDropPlayer

  local function isThrottled(tb, uses, duration)
    local source = source
    if nil ~= tb[source] then
      tb[source] = tb[source] - 1
      if 0 >= tb[source] then
        if drop then DropPlayer(source, 'ab3 event error') end
        return true
      end
    else
      tb[source] = uses
    end

    Citizen.SetTimeout(duration, function() tb[source] = tb[source] + 1 end)
    return false
  end

  local throttle = {}
  RegisterNetEvent('AB3:ClientBeep:EVENT_START', function()
    if not isThrottled(throttle, 10, 6e3) then
      clientBeep()
    end
  end)
  local throttle = {}
  RegisterNetEvent('AB3:ClientBeep:EVENT_DURING', function()
    if not isThrottled(throttle, 1, 11.5e4) then
      --                            ^ 5 seconds for deviation
      clientBeep()
    end
  end)
else
  RegisterNetEvent('AB3:ClientBeep:EVENT_START', clientBeep)
  RegisterNetEvent('AB3:ClientBeep:EVENT_DURING', clientBeep)
end

if Config.CommandAccessAce then
  local ace = Config.CommandAccessAce .. '.user.toggle'
  RegisterNetEvent('AB3:ClientHasAce', function()
    TriggerClientEvent('AB3:ServerHasAce', source, IsPlayerAceAllowed(source, ace))
  end)
end

Config = nil
