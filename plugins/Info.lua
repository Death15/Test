do
local function action_by_reply(extra, success, result)
  local user_info = {}
  local uhash = 'user:'..result.from.id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..result.from.id..':'..result.to.id
  user_info.msgs = tonumber(redis:get(um_hash) or 0)
  user_info.name = user_print_name(user)..' ['..result.from.id..']'
  local msgs = 'Total Messages : '..user_info.msgs
  if result.from.username then
    user_name = '@'..result.from.username
  else
    user_name = ''
  end
  local msg = result
  local user_id = msg.from.id
  local chat_id = msg.to.id
  local user = 'user#id'..msg.from.id
  local chat = 'chat#id'..msg.to.id
  local data = load_data(_config.moderation.data)
  if data[tostring('admins')][tostring(user_id)] then
    status = 'My Love'
  elseif data[tostring(msg.to.id)]['moderators'][tostring(user_id)] then
    status = 'My Mod'
  elseif tonumber(result.from.id) == tonumber(our_id) then
    status = 'No Status'
  else
    status = 'no Status'
  end
  for v,user in pairs(_config.sudo_users) do
    if user = user_id then
      status = 'My Fother'
    end
    if data[tostring('admins')][tostring(user_id)] then
    acces = 'BotAdmin'
  elseif data[tostring(msg.to.id)]['moderators'][tostring(user_id)] then
    acces = 'Moderator OF This Group'
  elseif tonumber(result.from.id) == tonumber(our_id) then
    acces = 'GroupAdmin'
  else
    acces = 'Member'
  end
  for v,user in pairs(_config.sudo_users) do
    if user = user_id then
      acces = 'Sudo'
    end
  end
  local text = '1- Full Name : '..(result.from.first_name or '')..' '..(result.from.last_name or '')..'\n\n'
             ..'2- First Name : '..(result.from.first_name or '')..'\n\n'
             ..'3- Last Name : '..(result.from.last_name or '')..'\n\n'
             ..'4- Username : '..user_name..'\n\n'
             ..'5- UserI-D : '..result.from.id..'\n\n'
             ..'6- total Maseages : '..msgs..'\n\n'
             ..'7- User Status : '..status..'\n\n'
             ..'8- Group I-D : '..msg.to.id..'\n\n'
             ..'9- Group N-A-M-E : ' .. string.gsub(msg.to.print_name, '_', ' ') .. '\n\n'
             ..'10- User Acces : '..acces..'\n\n'
  send_large_msg(extra.receiver, text)
end

local function run(msg)
   if msg.text == '/infouser' or msg.text == '!infouser' and is_momod(msg) then
      get_message(msg.reply_id, action_by_reply, {receiver=get_receiver(msg)})
   end
end

return {
    patterns = {
      '^[!/](infouser)$'
    },
  run = run
}
end
