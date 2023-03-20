RegisterNetEvent('AB3:ClientBeep', function()
  TriggerClientEvent('AB3:ServerBeep', -1, source)
end)

if Config.CommandAccessAce then
  local ace = Config.CommandAccessAce
  RegisterNetEvent('AB3:ClientHasAce', function()
    TriggerClientEvent('AB3:ServerHasAce', source, IsPlayerAceAllowed(source, ace))
  end)
end

Config = nil
