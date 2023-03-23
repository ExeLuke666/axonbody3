-- globals
local hudForceHide = false
local hudPresence = false
local activated = false

-- Compatibility with frameworks

if GetConvar('tfnrp_framework_init', 'false') == 'true' then
  Config.CommandAccessHandling = function ()
    return exports.framework:GetLocalClientDuty() > 0
  end

elseif Config.CommandAccessAce then
  Config.CommandAccessAce = nil
  local hasAce = false
  local pass = false
  local commandAccessHandling = Config.CommandAccessHandling

  RegisterNetEvent('AB3:ServerHasAce', function (bool)
    hasAce = bool
  end)
  TriggerServerEvent('AB3:ClientHasAce')

  Config.CommandAccessHandling = function ()
    if not pass then
      pass = true
      Citizen.SetTimeout(2.5e3, function () pass = false end)
      TriggerServerEvent('AB3:ClientHasAce')
    end

    return hasAce and commandAccessHandling()
  end
end

----------------------------------------------------------
-------------------- Commands
----------------------------------------------------------


-- HUD

RegisterCommand('axonhide', function()
  hudForceHide = true
  ShowNotification('~y~Axon Body 3~s~ overlay now ~r~hidden~s~.')
end)

RegisterCommand('axonshow', function()
  hudForceHide = false
  ShowNotification('~y~Axon Body 3~s~ overlay now ~g~visible~s~.')
end)

-- Activation and deactivation

if Config.CommandBinding then
  RegisterKeyMapping('axon', 'Toggle Axon Body 3', 'keyboard', Config.CommandBinding)
end
RegisterCommand('axon', function ()
  if activated then
    DeactivateAB3()
    ShowNotification('~y~Axon Body 3~s~ has ~r~stopped recording~s~.')
  else
    if not Config.CommandAccessHandling() then
      ShowNotification('You have to be ~r~on duty~s~ to enable ~y~Axon Body 3~s~.')
    else
      ActivateAB3()
      ShowNotification('~y~Axon Body 3~s~ has ~g~started recording~s~.')
    end
  end
end)

RegisterCommand('axonon', function ()
  if not Config.CommandAccessHandling() then
    ShowNotification('You have to be ~r~on duty~s~ to use ~y~Axon Body 3~s~.')
  else
    if activated then
      ShowNotification('~y~Axon Body 3~s~ is already ~g~recording~s~.')
    else
      ActivateAB3()
      ShowNotification('~y~Axon Body 3~s~ has ~g~started recording~s~.')
    end
  end
end)

RegisterCommand('axonoff', function ()
  if not activated then
    ShowNotification('~y~Axon Body 3~s~ has already ~r~stopped recording~s~.')
  else
    DeactivateAB3()
    ShowNotification('~y~Axon Body 3~s~ has ~r~stopped recording~s~.')
  end
end)


----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------


-- Events

--- This event is unimplemented and should be used by external client scripts.  
--- Will emit an error if parameters are incorrect or if state is already the same.
--- Please make sure state is synchronised with your implementation.  
--- @param state boolean -- Whether AB3 should be activated.
RegisterNetEvent('AB3:SetState', function(state)
  if state == true then
    ActivateAB3()
  elseif state == false then
    DeactivateAB3()
  else -- defensive programming
    error('what')
  end
end)

RegisterNetEvent('AB3:ServerBeep', function(netId)
  local otherPed = GetPlayerPed(GetPlayerFromServerId(netId))
  local ped = PlayerPedId()
  if DoesEntityExist(otherPed) and (IsPedInAnyVehicle(ped) == IsPedInAnyVehicle(otherPed)) or not IsPedInAnyVehicle(ped) then
    local playerCoords = GetEntityCoords(ped)
    local targetCoords = GetEntityCoords(otherPed)
    local distance = #(playerCoords - targetCoords)

    local volume = 0.05
    local radius = 10
    if (distance <= radius) then
      local distanceVolumeMultiplier = volume / radius
      local distanceVolume = volume - (distance * distanceVolumeMultiplier)

      SendNuiMessage('{"PLAY_AT_VOLUME":' .. distanceVolume .. '}')
    end
  end
end)

-- Utils

local idx
-- dynamic buffer of thread logic for suspended threads
local buffer = {}
-- sum of threads + 1 to store bool
local count = 3
local function bufferReduce(idx) buffer[idx] = buffer[idx] - 1 end
local function bufferFirstIdx()
  local idx = #buffer
  for i = 0, idx do if 0 == buffer[i] then return i end end
  return idx + 1
end

function ActivateAB3()
  if activated then
    return error('AB3 attempted to activate when already active.')
  end

  activated = true
  idx = bufferFirstIdx()
  buffer[idx] = count
  local cidx = idx

  -- beeper
  Citizen.CreateThread(function()
    Citizen.Wait(12e4)
    while count == buffer[cidx] do
      TriggerServerEvent('AB3:ClientBeep')
      Citizen.Wait(12e4)
    end
    bufferReduce(cidx)
  end)

  -- HUD
  Citizen.CreateThread(function()
    while count == buffer[cidx] do
      Citizen.Wait(0)
      if not hudForceHide and (Config.ThirdPersonMode or GetFollowPedCamViewMode() == 4) then
        if not hudPresence then
          SetHudPresence(true)
        end
      elseif hudPresence then
        SetHudPresence(false)
      end
    end
    SetHudPresence(false)
    bufferReduce(cidx)
  end)
end

function DeactivateAB3()
  if not activated then
    return error('AB3 attempted to deactivate when already deactivated.')
  end

  activated = false
  bufferReduce(idx)
end

function SetHudPresence(state)
  SendNuiMessage('{"PRESENCE":' .. (state and 1 or 0) .. '}')
  hudPresence = state
end

function ShowNotification(message)
  BeginTextCommandThefeedPost('STRING')
  AddTextComponentSubstringPlayerName(message)
  EndTextCommandThefeedPostTicker(true, false)
end
