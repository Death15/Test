do

local function run(msg, matches)
  if matches[1] == 'mystatus' then
    if is_sudo(msg) then
      return "you're THe Sudo Of Infernal!"
    elseif is_admin(msg) then
      return "you're admin of Infernal!
    elseif is_momod(msg) then
      return "you're a moderator of this Group"
    else
      return "you're a Member of This Group"
    end
  end
end

return {
  patterns = {
    "^[!/](mystatus$",
    "^(mystatus)$"
    },
  run = run
}
end
