local buffer = {}
local isRecording = {}
local batteryLevel = {}

local function clientBeep(playerId)
  TriggerClientEvent('AB3:ServerBeep', -1, playerId)
end

local function startRecording(playerId)
  if not batteryLevel[playerId] or batteryLevel[playerId] <= 0 then
    TriggerClientEvent('AB3:Notification', playerId, "Battery is dead!")
    return
  end

  isRecording[playerId] = true
  TriggerClientEvent('AB3:UpdateStatus', -1, playerId, "Recording")
  clientBeep(playerId)
end

local function stopRecording(playerId)
  isRecording[playerId] = false
  TriggerClientEvent('AB3:UpdateStatus', -1, playerId, "Stopped")
  clientBeep(playerId)
end

local function saveToBuffer(playerId, data)
  buffer[playerId] = buffer[playerId] or {}
  table.insert(buffer[playerId], 1, data)
  if #buffer[playerId] > 10 then
    table.remove(buffer[playerId])
  end

  local function sendPreEventBuffer(playerId)
    TriggerClientEvent('AB3:PreEventBuffer', playerId, buffer[playerId] or {})
  end

  local function handleBatteryDrain(playerId)
    batteryLevel[playerId] = (batteryLevel[playerId] or 100) - 1
    if batteryLevel[playerId] <= 10 then
      TriggerClientEvent('AB3:Notification', playerId, "Low Battery!")
    end
  end

  RegisterNetEvent('AB3:StartRecording', function()
    local playerId = source
    startRecording(playerId)
end)

RegisterNetEvent('AB3:StopRecording', function()
  local playerId = source
  stopRecording(playerId)
  sendPreEventBuffer(playerId)
end)

RegisterNetEvent('AB3:SaveBuffer', function(data)
  local playerId = source
  saveToBuffer(playerId, data)
  if isRecording[playerId] then
      handleBatteryDrain(playerId)
  end
end)

AddEventHandler('playerJoining', function()
  local playerId = source
  batteryLevel[playerId] = 100
  isRecording[playerId] = false
end)

AddEventHandler('playerDropped', function()
  local playerId = source
  buffer[playerId] = nil
  isRecording[playerId] = nil
  batteryLevel[playerId] = nil
end)