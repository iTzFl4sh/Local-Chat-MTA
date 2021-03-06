--[[
'
'
'
' | Multi Theft Auto [MTA] Script , Author's: ___.Flash | [server Side!]
'
'
'
--]]

local antiAbuse = {};
local localChatInterval = get("*localChatInterval");
local localChatCommand = get("*localChatCommand");
local localChatKey = get("*localChatKey");
local distanceChat = get("distanceChat");

function string:removeHexCode()
   local s = self:gsub("#%x%x%x%x%x%x", "");
   if #s < 1 then
      return self;
   end
   return s;
end

local function localChat(responsiblePlayer, _, ...)
   if not responsiblePlayer.account.guest then
      if isPlayerMuted(responsiblePlayer) ~= false then
         return outputChatBox("[Local chat]: You are muted!", responsiblePlayer, 255, 170, 0);
      end;
      if antiAbuse[responsiblePlayer] ~= nil and getTickCount()-antiAbuse[responsiblePlayer] <= localChatInterval then
         antiAbuse[responsiblePlayer] = getTickCount();
         outputChatBox("[Local chat]: Not flood!", responsiblePlayer, 255, 170, 0);
     else
         antiAbuse[responsiblePlayer] = getTickCount();
         local localMessage = table.concat({...}, "\t"):removeHexCode();
         outputDebugString( ("[Local chat] %s: %s"):format(responsiblePlayer.name:removeHexCode(), localMessage), 3, 255, 170, 0);
         local localPlayers = getElementsWithinRange(responsiblePlayer.position, distanceChat, "player");
         local i = 0;
         repeat
               i = i + 1;
               outputChatBox( ("[Local chat] %s: %s"):format(responsiblePlayer.name:removeHexCode(), localMessage), localPlayers[i], 255, 255, 255);
         until i == #localPlayers;
      end
  else
      outputChatBox("[Local chat]: You are not logged in!", responsiblePlayer, 255, 170, 0);
   end
end

local function onPlayerJoin()
   bindKey(source, localChatKey, "down", "chatbox", localChatCommand);
end

local function onPlayerQuit()
   antiAbuse[source] = nil;
end

local function onPlayerMuted()
   antiAbuse[source] = nil;
end

local function onResourceStart()
   addCommandHandler(localChatCommand, localChat);
   local allPlayers = getElementsByType("player");
   for i = 1, #allPlayers do
      bindKey(allPlayers[i], localChatKey, "down", "chatbox", localChatCommand);
   end
   addEventHandler("onPlayerJoin", getRootElement(), onPlayerJoin);
   addEventHandler("onPlayerQuit", getRootElement(), onPlayerQuit);
   addEventHandler("onPlayerMuted", getRootElement(), onPlayerMuted);
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart);
