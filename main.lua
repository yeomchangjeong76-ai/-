repeat
    task.wait()
until game:IsLoaded()

-- 설정값
local HUB_SCRIPT_ID = "72f5693f13d3d2008d69785db59bcb12"
local PlaceIDs = {
    ["537413528"] = "72f5693f13d3d2008d69785db59bcb12",
    ["76558904092080"] = "0bef79fe69ee3fe8607ff9f07f2d8def",
    ["129009554587176"] = "0bef79fe69ee3fe8607ff9f07f2d8def",
}

-- 서비스 및 라이브러리 로드
local luarmor = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
local cloneref = cloneref or function(x) return x end
local Players = cloneref(game:GetService("Players"))

-- 현재 게임 지원 여부 확인
local supported = PlaceIDs[tostring(game.PlaceId)]
if not supported then
    Players.LocalPlayer:Kick("Game not supported for this script.")
    return
end

-- Luarmor 설정 (키 체크 없이 로드 시도)
luarmor.script_id = supported or HUB_SCRIPT_ID

-- [수정 핵심] 키 시스템을 건너뛰고 바로 스크립트 실행
-- 만약 해당 스크립트가 서버측에서 반드시 키를 요구하도록 설정되어 있다면 
-- 아래 함수 호출 시 오류가 날 수 있으나, 클라이언트측 제약은 모두 제거되었습니다.
print("Key system bypassed. Loading main script...")
local ok, err = pcall(function()
    luarmor.load_script()
end)

if not ok then
    warn("Failed to load script: " .. tostring(err))
end

