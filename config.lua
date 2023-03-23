--- Shared config.
--- @type table
Config = {
  --- [Client] Keybind to use for on/off command. can be nil for no keybind.
  --- @type string
  CommandBinding = 'u',
  --- [Client] Whether the axon overlay is also visible in third person.
  --- @type boolean
  ThirdPersonMode = false,

  -- Security

  --- [Client] Handling used to verify if the client should be able to enable AB3.  
  --- @type function -- A client-side implementation of custom framework logic, etc.  
  --- @return boolean -- Whether client should have access.
  CommandAccessHandling = function ()
    -- Add custom framework access handling here.
    return true
  end,
  --- [Server] Use ACL to determine whether the client should be able to enable AB3.  
  --- ACL will be checked befored CommandAccessHandling, if it exists.  
  --- The ab3.user.toggle ace should be used, where ab3 is the value set below.  
  --- @type string|nil -- String representation of the "root" ace.
  CommandAccessAce = 'ab3',
  --- [Server] Whether server events should be throttled server-side.  
  --- May be useful if these events are often used illegitimately in your server.
  --- @type boolean
  ThrottleServerEvents = false,
  --- [Server] Whether the player should be dropped if the throttle is violated.  
  --- The only plausible way for a player to violate a throttle is by cheating 
  --- or a race condition.
  --- @type boolean
  ThrottleDropPlayer = true,
}