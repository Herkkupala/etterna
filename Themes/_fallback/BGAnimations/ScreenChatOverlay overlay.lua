
local lastx, lasty = 0, 0
local width, height = SCREEN_WIDTH, SCREEN_HEIGHT*0.035
local lineNumber = 8
local inputLineNumber = 3
local tabHeight = 1
local maxTabs = 10
local x, y = 0, SCREEN_HEIGHT-height*(lineNumber+inputLineNumber+tabHeight)
local moveY = 0
local mousex, mousey = -1, -1
local scale = 0.4
local minimised = false
local typing = false
local typingText = ''
local transparency = 0.5
local curmsgh = 0
local closeTabSize = 10
local Colors = {
	background = color("#7777FF"),
	input = color("#888888"),
	activeInput = color("#BBBBFF"),
	output = color("#888888"),
	bar = color("#666666"),
	tab = color("#555555"),
	activeTab = color("#999999")
}
local chats = {}
chats[0] = {}
chats[1] = {}
chats[2] = {}
chats[0][""] = {}
local tabs = {{0, ""}}
--chats[tabname][tabtype]
--tabtype: 0=lobby, 1=room, 2=pm
local messages = chats[0][""]
local currentTabName = ""
local currentTabType = 0

function changeTab(tabName, tabType)
	currentTabName = tabName
	currentTabType = tabType
	if not chats[tabType][tabName] then
		local i = 1
		local done = false
		while not done do
			if not tabs[i] then tabs[i] = {tabType, tabName}; done = true; end
		end
		chats[tabType][tabName] = {}
	end
	messages = chats[tabType][tabName]
end
local chat = Def.ActorFrame{}
local currentScreen
local show = true
local online = IsNetSMOnline() and IsSMOnlineLoggedIn(PLAYER_1) and NSMAN:IsETTP()

chat.MinimiseMessageCommand = function(self)
	self:linear(0.5)
	moveY=minimised and height*(lineNumber+inputLineNumber+tabHeight-1) or 0
	self:y(moveY)
end
chat.InitCommand = function(self)
	online = IsNetSMOnline() and IsSMOnlineLoggedIn(PLAYER_1) and NSMAN:IsETTP()
	self:SetUpdateFunction(
		function(self)
			local s = SCREENMAN:GetTopScreen()
			if not s then
				return
			end
			local sN = s:GetName()
			if currentScreen ~= sN then
				currentScreen= sN
				online = IsNetSMOnline() and IsSMOnlineLoggedIn(PLAYER_1) and NSMAN:IsETTP()
				if(sN == "ScreenGameplay" or sN == "ScreenNetGameplay") then
					self:visible(false)
					show = false
					typing = false
				else
					self:visible(online)
					show = true
					s:AddInputCallback(input)
					MESSAGEMAN:Broadcast("ScreenChanged")
				end
				MESSAGEMAN:Broadcast("UpdateChatOverlay")
			end
		end
	)
end
chat.MultiplayerDisconnectionMessageCommand = function(self)
	SCREENMAN:set_input_redirected("PlayerNumber_P1", false)
	online = false
	self:visible(false)
	MESSAGEMAN:Broadcast("UpdateChatOverlay")
	chats = {}
	chats[0] = {}
	chats[1] = {}
	chats[2] = {}
	chats[0][""] = {}
	tabs = {{0, ""}}
	changeTab("", 0)
end

chat[#chat+1] = Def.Quad{
	Name = "Background",
	InitCommand = function(self)
		self:diffuse(Colors.background)
		self:diffusealpha(transparency)
		self:stretchto(x, y, width+x, height*(lineNumber+inputLineNumber+tabHeight)+y)
	end
}
chat[#chat+1] = Def.Quad{
	Name = "Bar",
	InitCommand = function(self)
		self:diffuse(Colors.bar)
		self:diffusealpha(transparency)
		self:stretchto(x, y, width+x, height+y)
	end
}
chat[#chat+1] = LoadFont("Common Normal")..{
	Name = "BarLabel",
	InitCommand = function(self)
		self:settext("CHAT")
		self:halign(0):valign(0.5)
		self:zoom(0.5)
		self:diffuse(color("#000000"))
		self:visible(true)
		self:xy(x+4, y+height*0.5)
	end
}
chat[#chat+1] = LoadFont("Common Normal")..{
	Name = "BarMinimiseButton",
	InitCommand = function(self)
		self:settext("-")
		self:halign(1):valign(0.5)
		self:zoom(0.8)
		self:diffuse(color("#000000"))
		self:visible(true)
		self:xy(x+width-4, y+5)
	end,
	MinimiseMessageCommand = function(self)
		self:settext(minimised and "+" or "-")
	end
}


local chatWindow = Def.ActorFrame{
	InitCommand = function(self)
		self:visible(true)
	end,
	ChatMessageCommand = function(self, params)
		local msgs = chats[params.type][params.tab]
		local newTab = false
		if not msgs then 
			chats[params.type][params.tab] = {}
			msgs = chats[params.type][params.tab]
			tabs[#tabs+1] = {params.type, params.tab}
			newTab = true
		end
		msgs[#msgs+1] = params.msg
		if msgs == messages or newTab then --if its the current tab
			MESSAGEMAN:Broadcast("UpdateChatOverlay")
		end
	end
}

chatWindow[#chatWindow+1] = Def.Quad{
	Name = "ChatWindow",
	InitCommand = function(self)
		self:diffuse(Colors.output)
		self:diffusealpha(transparency)
	end,
	UpdateChatOverlayMessageCommand = function(self)
		self:stretchto(x, height*(1+tabHeight)+y, width+x, height*(lineNumber+tabHeight)+y)
		curmsgh = 0
		MESSAGEMAN:Broadcast("UpdateChatOverlayMsgs")
	end
}
chatWindow[#chatWindow+1] = LoadColorFont("Common Normal")..{
	Name = "ChatText",
	InitCommand = function(self)
		self:settext('')
		self:halign(0):valign(1)
		self:vertspacing(0)
		self:zoom(scale)
		self:SetMaxLines(lineNumber, 0)
		self:wrapwidthpixels((width-8)/scale)
	end,
	UpdateChatOverlayMsgsMessageCommand = function(self)
		local t = ""
		for i = lineNumber-1,0,-1  do
			if messages[#messages-i] then
				t = t..messages[#messages-i].."\n"
			end
		end
		self:settext(t)
		self:xy(x+4, y+height*(lineNumber+tabHeight)-4)
	end
}

local tabWidth = width/maxTabs
for i = 0, maxTabs-1 do
	chatWindow[#chatWindow+1] = Def.ActorFrame{ 
		Name = "Tab"..i+1,
		UpdateChatOverlayMessageCommand = function(self)
			self:visible(not not tabs[i+1])
		end,
		Def.Quad{
			InitCommand = function(self)
				self:diffuse(Colors.tab)
				self:diffusealpha(transparency)
			end,
			UpdateChatOverlayMessageCommand = function(self)
				self:diffuse((tabs[i+1] and currentTabName == tabs[i+1][2] and currentTabType == tabs[i+1][1]) and Colors.activeTab or Colors.tab)
				self:stretchto(x+tabWidth*i, y+height, x+tabWidth*(i+1), y+height*(1+tabHeight))
			end,
		},
		LoadFont("Common Normal")..{
			InitCommand = function(self)
				self:halign(0):valign(0)
				self:maxwidth(tabWidth)
				self:zoom(scale)
				self:diffuse(color("#000000"))
				self:xy(x+tabWidth*i, y+height*(1+(tabHeight/4)))
			end,
			UpdateChatOverlayMessageCommand = function(self)
				if not tabs[i+1] then
					self:settext("")
					return
				end
				if tabs[i+1][1] == 0 and tabs[i+1][2] == "" then
					self:settext("Lobby")
				else
					self:settext(tabs[i+1][2] or "")
				end
			end
		},
		LoadFont("Common Normal")..{
			InitCommand = function(self)
				self:halign(0):valign(0)
				self:maxwidth(tabWidth)
				self:zoom(scale)
				self:diffuse(color("#000000"))
				self:xy(x+tabWidth*(i+1)-closeTabSize, y+height*(1+(tabHeight/4)))
			end,
			UpdateChatOverlayMessageCommand = function(self)
				if tabs[i+1] and ((tabs[i+1][1] == 0 and tabs[i+1][2] == "") or (tabs[i+1][1] == 1 and tabs[i+1][2] ~= nil and tabs[i+1][2] == NSMAN:GetCurrentRoomName())) then
					self:settext("")
				else
					self:settext("X")
				end
			end
		},
	}
end

chatWindow[#chatWindow+1] = Def.Quad{
	Name = "ChatBox",
	InitCommand = function(self)
		self:diffuse(Colors.input)
		self:diffusealpha(transparency)
	end,
	UpdateChatOverlayMessageCommand = function(self)
		self:stretchto(x, height*(lineNumber+1)+y+4, width+x, height*(lineNumber+1+inputLineNumber)+y)
		self:diffuse(typing and Colors.activeInput or Colors.input):diffusealpha(transparency)
	end,
}
chatWindow[#chatWindow+1] = LoadFont("Common Normal")..{
	Name = "ChatBoxText",
	InitCommand = function(self)
		self:settext('')
		self:halign(0):valign(0)
		self:zoom(scale)
		self:wrapwidthpixels((width-8)/scale)
		self:diffuse(color("#FFFFFF"))
	end,
	UpdateChatOverlayMessageCommand = function(self)
		self:settext(typingText)
		self:wrapwidthpixels((width-8)/scale)
		self:xy(x+4, height*(lineNumber+1)+y+4+4)
	end
}

chat[#chat+1] = chatWindow

chat.UpdateChatOverlayMessageCommand = function(self)
	SCREENMAN:set_input_redirected("PlayerNumber_P1", typing)
end
function overTab(mx, my)
	for i = 0, maxTabs-1 do
		if tabs[i+1] then
			if mx >= x+tabWidth*i and my>= y+height and mx <= x+tabWidth*(i+1) and my<= y+height*(1+tabHeight) then
				return i+1, mx >= x+tabWidth*(i+1)-closeTabSize
			end
		end
	end
	return nil, nil
end
function input(event)
	if(not show or not online) then
		return
	end
	local update = false
	if event.DeviceInput.button == "DeviceButton_left mouse button" then
			if typing then
				update = true
			end
			typing = false
			local mx, my = INPUTFILTER:GetMouseX(), INPUTFILTER:GetMouseY()
			if mx >= x and mx <= x+width and my >= moveY+y and my <= moveY+y+height then
				minimised = not minimised
				MESSAGEMAN:Broadcast("Minimise")
				update = true
			elseif mx >= x and mx <= width+x and my >= height*(lineNumber+tabHeight)+y+moveY+4 and my <= height*(lineNumber+inputLineNumber+tabHeight)+y+moveY and not minimised then
				typing = true
				update = true
			elseif mx >= x and mx <= x+width and my >= y+moveY and my <= y+height+moveY then
				mousex, mousey = mx, my
				lastx, lasty = x, y
				update = true
			else
				local tabButton, closeTab = overTab(mx, my)
				if not tabButton then
					mousex, mousey = -1, -1
					if typing then
						update = true
					end
				else
					if not closeTab then
						changeTab(tabs[tabButton][2], tabs[tabButton][1])
					else
						local tabT = tabs[tabButton][1]
						local tabN = tabs[tabButton][2]
						if (tabT == 0 and tabN == "") or (tabT == 1 and tabN ~= nil and tabN == NSMAN:GetCurrentRoomName()) then
							return false
						end
						tabs[tabButton] = nil
						if chats[tabT][tabN] == messages then
							for i = #tabs,1,-1 do
								if tabs[i] then
									changeTab(tabs[i][2], tabs[i][1])
								end
							end
						end
						chats[tabT][tabN] = nil
					end
					update = true
				end
			end
	end
	
	
	if typing and event.type ~= "InputEventType_Release" then
		if event.DeviceInput.button == "DeviceButton_enter" then
			if typingText:len() > 0 then
				NSMAN:SendChatMsg(typingText, currentTabType, currentTabName)
				typingText = ''
			end
			update = true
		elseif event.button == "Back" then
			typingText = ''
			typing = false
			update = true
		elseif event.DeviceInput.button == "DeviceButton_space" then
			typingText = typingText .. ' '
			update = true
		elseif (INPUTFILTER:IsBeingPressed("left ctrl") or INPUTFILTER:IsBeingPressed("right ctrl")) and event.DeviceInput.button == "DeviceButton_v" then
			typingText = typingText .. HOOKS:GetClipboard()
			update = true
		elseif event.DeviceInput.button == "DeviceButton_backspace" then
			typingText = typingText:sub(1, -2)
			update = true
		elseif event.char then
			typingText = typingText .. event.char
			update = true
		end
	end
	if update then
		MESSAGEMAN:Broadcast("UpdateChatOverlay")
	end
	
	
	return update or typing
end


return chat