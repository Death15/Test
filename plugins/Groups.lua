do

  -- Checks if bot was disabled on specific chat
  local function is_channel_disabled(receiver)
	  if not _config.disabled_channels then
		  return false
	  end
	  if _config.disabled_channels[receiver] == nil then
		  return false
	  end
    return _config.disabled_channels[receiver]
  end

  local function enable_channel(receiver)
	  if not _config.disabled_channels then
		  _config.disabled_channels = {}
	  end
	  if _config.disabled_channels[receiver] == nil then
		  return 'Group is not disabled'
	  end
	  _config.disabled_channels[receiver] = false
	  save_config()
	  return 'Group re-enabled'
  end

  local function pre_process(msg)
	  -- If sender is a moderator then re-enable the channel
	  if is_mod(msg.from.id, msg.to.id) then
	    if msg.text == 'group +' then
	      enable_channel(get_receiver(msg))
	    end
	  end
    if is_channel_disabled(get_receiver(msg)) then
    	msg.text = ''
    end
	  return msg
  end

  local function run(msg, matches)
	  -- Enable a group
	  if matches[1] == '+' then
		  return enable_channel(get_receiver(msg))
	  end
	  -- Disable a group
	  if matches[1] == '-' then
	    if not _config.disabled_channels then
		    _config.disabled_channels = {}
	    end
	    _config.disabled_channels[get_receiver(msg)] = true
	    save_config()
	    return 'Group Has Been Disabled!'
	  end
  end

  return {
	  description = 'Plugin .',
	  usage = {
    },
	  patterns = {
		  "^[!/](group) (+)$",
		  "^[!/](group) (-)$"
    },
	  run = run,
    moderated = true,
	  pre_process = pre_process
  }

end
