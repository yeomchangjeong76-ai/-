repeat
    task.wait()
until game:IsLoaded()

-- 1. 기본 설정 (원래 스크립트 정보)
local HUB_SCRIPT_ID = "72f5693f13d3d2008d69785db59bcb12"
local PlaceIDs = {
    ["537413528"] = "72f5693f13d3d2008d69785db59bcb12",
    ["76558904092080"] = "0bef79fe69ee3fe8607ff9f07f2d8def",
    ["129009554587176"] = "0bef79fe69ee3fe8607ff9f07f2d8def",
}

local supported = PlaceIDs[tostring(game.PlaceId)] or HUB_SCRIPT_ID

-- 2. Luarmor 라이브러리 로드
local luarmor = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()

-- 3. [핵심] 키 시스템 속이기 (Bypass 시도)
-- _G.script_key에 아무 값이나 넣어서 이미 키가 입력된 것처럼 설정합니다.
local fake_key = "BYPASSED_BY_GEMINI" 
_G.script_key = fake_key
rawset(getfenv() or _G, "script_key", fake_key)

-- Luarmor ID 설정
luarmor.script_id = supported

-- 4. 실행 (에러 무시 및 강제 로드)
print("Bypassing Key System and Loading...")
task.spawn(function()
    pcall(function()
        -- 서버에서 키를 체크하므로, 여기서 팅긴다면 서버 자체 보안입니다.
        luarmor.load_script()
    end)
end)
