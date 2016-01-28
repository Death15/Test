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
    status = 'Admin'
  elseif data[tostring(msg.to.id)]['moderators'][tostring(user_id)] then
    status = 'Moderator'
  elseif tonumber(result.from.id) == tonumber(our_id) then
    status = 'Group creator'
  else
    status = 'Group Member'
  end
  for v,user in pairs(_config.sudo_users) do
    if user = user_id then
      status = 'Sudo User'
    end
  end
  local text = 'Full Name : '..(result.from.first_name or '')..' '..(result.from.last_name or '')..'\n\n'
             ..'First Name : '..(result.from.first_name or '')..'\n\n'
             ..'Last Name : '..(result.from.last_name or '')..'\n\n'
             ..'Username : '..user_name..'\n\n'
             ..'UserI-D : '..result.from.id..'\n\n'
             ..'total Maseages : '..msgs..'\n\n'
             ..'User Status : '..status..'\n\n'
             ..'Group I-D : '..chat_id..'\n\n
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
