--=====================================================================================
-- WC3LU | Warcraft3LevelUp - core.lua
-- Version: 2.0.0
-- Author: DonnieDice
-- RGX Mods Collection - RealmGX Community Project
--=====================================================================================

local RGX = assert(_G.RGXFramework, "WC3LU: RGX-Framework not loaded")

WC3LU = WC3LU or {}

local ADDON_VERSION = "2.0.4"
local ADDON_NAME = "Warcraft3LevelUp"
local PREFIX = "|Tinterface/addons/Warcraft3LevelUp/media/icon:16:16|t - |cffffffff[|r|cfff4d038WC3LU|r|cffffffff]|r "
local TITLE = "|Tinterface/addons/Warcraft3LevelUp/media/icon:18:18|t [|cfff4d038W|r|cffffffffarcraft 3|r |cfff4d038L|r|cffffffffevel|r |cfff4d038U|r|cfff4d038p|r|cfff4d038!|r]"

WC3LU.version = ADDON_VERSION
WC3LU.addonName = ADDON_NAME

local Sound = RGX:GetSound()

local handle = Sound:Register(ADDON_NAME, {
sounds = {
high = "Interface\\Addons\\Warcraft3LevelUp\\sounds\\warcraft_3_high.ogg",
medium = "Interface\\Addons\\Warcraft3LevelUp\\sounds\\warcraft_3_med.ogg",
low = "Interface\\Addons\\Warcraft3LevelUp\\sounds\\warcraft_3_low.ogg",
},
defaultSoundId = 569593,
savedVar = "WC3LUSettings",
defaults = {
enabled = true,
soundVariant = "medium",
muteDefault = true,
showWelcome = true,
volume = "Master",
firstRun = true,
},
triggerEvent = "PLAYER_LEVEL_UP",
addonVersion = ADDON_VERSION,
})

WC3LU.handle = handle

local L = WC3LU.L or {}
local initialized = false

local function ShowHelp()
print(PREFIX .. " " .. (L["HELP_HEADER"] or ""))
print(PREFIX .. " " .. (L["HELP_TEST"] or ""))
print(PREFIX .. " " .. (L["HELP_ENABLE"] or ""))
print(PREFIX .. " " .. (L["HELP_DISABLE"] or ""))
print(PREFIX .. " |cffffffff/wc3lu high|r - Use high quality sound")
print(PREFIX .. " |cffffffff/wc3lu med|r - Use medium quality sound")
print(PREFIX .. " |cffffffff/wc3lu low|r - Use low quality sound")
end

local function HandleSlashCommand(args)
local command = string.lower(args or "")
if command == "" or command == "help" then
ShowHelp()
elseif command == "test" then
print(PREFIX .. " " .. (L["PLAYING_TEST"] or ""))
handle:Test()
elseif command == "enable" then
handle:Enable()
print(PREFIX .. " " .. (L["ADDON_ENABLED"] or ""))
elseif command == "disable" then
handle:Disable()
print(PREFIX .. " " .. (L["ADDON_DISABLED"] or ""))
elseif command == "high" then
handle:SetVariant("high")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "high"))
elseif command == "med" or command == "medium" then
handle:SetVariant("medium")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "medium"))
elseif command == "low" then
handle:SetVariant("low")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "low"))
else
print(PREFIX .. " " .. (L["ERROR_PREFIX"] or "") .. " " .. (L["ERROR_UNKNOWN_COMMAND"] or ""))
end
end

RGX:RegisterEvent("ADDON_LOADED", function(event, addonName)
if addonName ~= ADDON_NAME then return end
handle:SetLocale(WC3LU.L)
L = WC3LU.L or {}
handle:Init()
initialized = true
end, "WC3LU_ADDON_LOADED")

RGX:RegisterEvent("PLAYER_LEVEL_UP", function()
if initialized then
handle:Play()
end
end, "WC3LU_PLAYER_LEVEL_UP")

RGX:RegisterEvent("PLAYER_LOGIN", function()
if not initialized then
handle:SetLocale(WC3LU.L)
L = WC3LU.L or {}
handle:Init()
initialized = true
end
handle:ShowWelcome(PREFIX, TITLE)
end, "WC3LU_PLAYER_LOGIN")

RGX:RegisterEvent("PLAYER_LOGOUT", function()
handle:Logout()
end, "WC3LU_PLAYER_LOGOUT")

RGX:RegisterSlashCommand("wc3lu", function(msg)
local ok, err = pcall(HandleSlashCommand, msg)
if not ok then
print(PREFIX .. " |cffff0000WC3LU Error:|r " .. tostring(err))
end
end, "WC3LU_SLASH")
