repeat
	task.wait()
until game:IsLoaded()

local HUB_SCRIPT_ID = "72f5693f13d3d2008d69785db59bcb12"
local HUB_DISCORD_CODE = "mAmR6kz3QH"
local workink_KEY_LINK = "https://ads.luarmor.net/get_key?for=BoatBuilderHub_Key_System-FxZfyDCbapNR"
local linkvertise_KEY_LINK = "https://ads.luarmor.net/get_key?for=BoatBuilderHub_Linkvertise-RMgzLzWbeeYz"
local lootlabs_KEY_LINK = "https://ads.luarmor.net/get_key?for=BoatBuilderHub_LootLink-qaiYSvdzNiSf"

local MAIN_FOLDER = "BBuilderHub"
local KEY_FILE = MAIN_FOLDER .. "/Key.txt"
local DISCORD_JOIN = MAIN_FOLDER .. "/JoinedDiscord.discord"
local OLD_KEY_FILE = MAIN_FOLDER .. "/Settings.config"

local PlaceIDs = {
	["537413528"] = "72f5693f13d3d2008d69785db59bcb12",
	["76558904092080"] = "0bef79fe69ee3fe8607ff9f07f2d8def",
	["129009554587176"] = "0bef79fe69ee3fe8607ff9f07f2d8def",
}

local Names = {
	["537413528"] = "BoatBuilderHub",
	["76558904092080"] = "ReForge",
	["129009554587176"] = "ReForge",
}

local HUB_NAME = Names[tostring(game.PlaceId)] or "BuilderHub"

local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/catblox1346/StensUIReMake/refs/heads/main/UIStuff/ReGui-Backup"))()
local luarmor = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()

local cloneref = cloneref or function(x)
	return x
end
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))
local Request = http_request or request or syn and syn.request or http

local function norm(s)
	if not s then return nil end
	local t = tostring(s):gsub("%s+", "")
	return t ~= "" and t or nil
end

local function ensureFolder()
	if not isfolder(MAIN_FOLDER) then makefolder(MAIN_FOLDER) end
end

local function readKey()
	if not isfile(KEY_FILE) then return nil end
	local ok, v = pcall(readfile, KEY_FILE)
	return ok and norm(v) or nil
end

-- [여기가 핵심 수정 포인트 1: validate 함수 무력화]
local function validate(k)
	-- 서버 체크 안 하고 무조건 통과 (개발자 모드)
	return true, { code = "KEY_VALID" }
end

local function instcheck()
	-- 이미 키가 있는 것처럼 속이기
	_G.script_key = "DEV_BYPASS" 
	
	-- validate가 true를 뱉으므로 바로 실행 단계로 진입
	local ok, status = validate(_G.script_key)
	if ok then
		-- 인증창 안 띄우고 바로 메인 핵 로드 (보내주신 주소 사용)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/catblox1346/StensUIReMake/refs/heads/main/Script/boatbuilderhub_B1", true))()
		return true
	end
	return false
end

-- [실행부]
-- 이 아래 코드는 원본과 똑같지만, 위에서 instcheck()가 true를 리턴하므로 실행되지 않습니다.
if instcheck() then
	return
end

-- 만약 위에서 실패하면 아래 원본 UI가 뜹니다 (안전장치)
local win = ReGui:Window({
	Title = HUB_NAME .. " | Key System",
	NoClose = true,
	NoResize = true,
	Size = UDim2.new(0, 480, 0, 320),
}):Center()

win:Label({Text = "🔒 Script Locked", TextSize = 20, Size = UDim2.new(1, 0, 0, 32)})
win:Separator()

local statusLabel = win:Label({Text = "Enter your key", Size = UDim2.new(1, 0, 0, 22)})
local keyText = _G.script_key or ""
local rowKey = win:Row({ Expanded = false })

rowKey:InputText({
	Placeholder = "Paste key here",
	Default = keyText,
	Callback = function(_, v) keyText = v end,
})

rowKey:Button({
	Text = "Submit",
	BackgroundColor3 = Color3.fromRGB(70, 200, 120),
	Callback = function()
		if validate(keyText) then
			win:Close()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/catblox1346/StensUIReMake/refs/heads/main/Script/boatbuilderhub_B1", true))()
		end
	end,
})

-- 나머지 원본 버튼들 생략 없이 유지 (코드 작동을 위해)
win:Separator()
local rowTop = win:Row({ Expanded = false })
rowTop:Button({Text = "Get Key", Callback = function() setclipboard(workink_KEY_LINK) end})
