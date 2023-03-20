--- Client-side config.
--- @type table
Config = {
  --- Handling used to verify if the client should be able to enable AB3.
  --- @type function - a client-side implementation of custom framework logic, etc
  --- @return boolean - whether client should have access
  CommandAccessHandling = function ()
    -- Add custom framework access handling here.
    return true
  end,
  --- Use ACL to determine whether the client should be able to enable AB3.  
  --- ACL will be checked befored CommandAccessHandling, if it exists.
  --- @type string|nil - string representation of the "root" ace
  CommandAccessAce = 'ab3',
  --- Keybind to use for on/off command. can be nil for no keybind.
  --- @type string
  CommandBinding = 'u',
  --- Whether the axon overlay is also visible in third person.
  --- @type boolean
  ThirdPersonMode = false,
}