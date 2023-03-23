if Config.ThrottleServerEvents then
  local drop = Config.ThrottleDropPlayer

  local function isThrottled(tb, duration)
    if tb[source] then
      if drop then DropPlayer(source, 'ab3 event error') end
      return true
    end
    tb[source] = true
    local source = source
    Citizen.SetTimeout(duration, function() tb[source] = nil end)
    return false
  end

  local throttle = {}
  RegisterNetEvent('AB3:ClientBeep', function()
    if not isThrottled(throttle, 11.5e4) then
      --                            ^ 5 seconds for deviation
      TriggerClientEvent('AB3:ServerBeep', -1, source)
    end
  end)
else
  RegisterNetEvent('AB3:ClientBeep', function()
    TriggerClientEvent('AB3:ServerBeep', -1, source)
  end)
end

if Config.CommandAccessAce then
  local ace = Config.CommandAccessAce .. '.user.toggle'
  RegisterNetEvent('AB3:ClientHasAce', function()
    TriggerClientEvent('AB3:ServerHasAce', source, IsPlayerAceAllowed(source, ace))
  end)
end

Config = nil
