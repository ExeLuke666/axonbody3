-- // Globals
local hudForceHide = false
local hudPresence = false
local activated = false
local batteryLevel = 100
local preEventBuffer = {}
local bufferSize = 60

RegisterCommand('axonhide', function()
  hudForceHide = true
  ShowNotification('~y~Axon Body 3:~s~ overlay now ~g~visible~s~.')
end)

RegisterCommand('axonshow' function()
  hudForceHide = false
  ShowNotification('~y~Axon Body 3:~s~ overlay now ~g~visible~s~.')
end)

RegisterCommand('axon', function()
  if activated then
    DeactivateAB3()
    ShowNotification('~y~Axon Body 3~s~ has ~r~stopped recording~s~.')
  else
    ActivateAB3()
    ShowNotification('~y~Axon Body 3~s~ has ~g~started recording~s~.')
  end
end)

RegisterCommand('axonbattery', function()
  ShowNotification('~y~Axon Body 3~s~ battery level: ~b~' .. batteryLevel .. '%~s~.')
end)

RegisterCommand('axonbuffer', function()
  if not activated then
      ShowNotification('~y~Showing pre-event buffer~s~...')
      ShowPreEventBuffer()
  else
      ShowNotification('~r~Cannot access pre-event buffer while recording~s~.')
  end
end)

RegisterNetEvent('AB3:ServerBeep', function(netId)
  local otherPed = GetPlayerPed(GetPlayerFromServerId(netId))
  if DoesEntityExist(otherPed) then
      local volume = 0.05
      local radius = 10
      local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(otherPed))
      if distance <= radius then
          SendNuiMessage('{"PLAY_AT_VOLUME":' .. volume .. '}')
      end
  end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(60e3) -- 1 minute intervals
      if activated and batteryLevel > 0 then
          batteryLevel = batteryLevel - 1
          if batteryLevel == 10 then
              ShowNotification('~y~Axon Body 3~s~ battery is ~r~critically low~s~.')
          elseif batteryLevel == 0 then
              ShowNotification('~y~Axon Body 3~s~ has ~r~shut down due to low battery~s~.')
              DeactivateAB3()
          end
      end
  end
end)

function saveToBuffer(data)
  table.insert(preEventBuffer, {
      timestamp = os.time(),
      event = data
  })

  if #preEventBuffer > bufferSize then
      table.remove(preEventBuffer, 1)
  end

  print("Saved to buffer: ", data)
end

function printBuffer()
  for _, event in ipairs(preEventBuffer) do
    print(string.format("Time: %s, Event: %s", os.date('%X', event.timestamp), event.event))
  end
end

function ActivateAB3()
  if activated then return end
  activated = true
  SaveToBuffer('AB3 activated')
  UpdateHud()
end

function DeactivateAB3()
  if not activated then return end
  activated = false
  SaveToBuffer('AB3 deactivated')
  UpdateHud()
end

function UpdateHud()
  if not hudForceHide and (Config.ThirdPersonMode or GetFollowPedCamViewMode() == 4) then
      local hudData = {
          presence = true,
          recording = activated,
          battery = batteryLevel
      }
      SendNuiMessage(json.encode(hudData))
      hudPresence = true
  elseif hudPresence then
      SendNuiMessage('{"PRESENCE":0}')
      hudPresence = false
  end
end

function ShowNotification(message)
  BeginTextCommandThefeedPost('STRING')
  AddTextComponentSubStringPlayerName(message)
  EndTextCOmmandThefeedPostTicker(true, false)
end