require 'mp'
require 'mp.msg'

-- Copy: (Ignore those as they are old defaults)
-- Filename or URL              (CTRL+f)
-- Full Filename Path           (CTRL+p)
-- Current Video Time           (CTRL+t)
-- Current Video Duration       (CTRL+d)
-- Current Displayed Subtitle   (CTRL+s)
-- Video Metadata               (CTRL+m)

WINDOWS = 2
UNIX = 3

local function platform_type()
    local utils = require 'mp.utils'
    local workdir = utils.to_string(mp.get_property_native("working-directory"))
    if string.find(workdir, "\\") then
        return WINDOWS
    else
        return UNIX
    end
end

local function command_exists(cmd)
    local pipe = io.popen("type " .. cmd .. " > /dev/null 2> /dev/null; printf \"$?\"", "r")
    exists = pipe:read() == "0"
    pipe:close()
    return exists
end

local function get_clipboard_cmd()
    if command_exists("xclip") then
        return "xclip -silent -in -selection clipboard"
    elseif command_exists("wl-copy") then
        return "wl-copy"
    elseif command_exists("pbcopy") then
        return "pbcopy"
    else
        mp.msg.error("No supported clipboard command found")
        return false
    end
end

local function divmod(a, b)
    return a / b, a % b
end

local function set_clipboard(text)
    if platform == WINDOWS then
        -- Escape quotes for PowerShell by doubling them
        local escaped_text = text:gsub('"', '""')
        mp.commandv("run", "powershell", "set-clipboard", string.format('"%s"', escaped_text))
        return true
    elseif (platform == UNIX and clipboard_cmd) then
        local pipe = io.popen(clipboard_cmd, "w")
        pipe:write(text)
        pipe:close()
        return true
    else
        mp.msg.error("Set_clipboard error")
        return false
    end
end

-- Copy Time
local function copyTime()
    local time_pos = mp.get_property_number("time-pos")
    local minutes, remainder = divmod(time_pos, 60)
    local hours, minutes = divmod(minutes, 60)
    local seconds = math.floor(remainder)
    local milliseconds = math.floor((remainder - seconds) * 1000)
    local time = string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
    if set_clipboard(time) then
        mp.osd_message(string.format("Time Copied to Clipboard: %s", time))
    else
        mp.osd_message("Failed to copy time to clipboard")
    end
end

-- Copy Time (FFmpeg Format)
local function copyTimeFFmpeg()
    local time_pos = mp.get_property_number("time-pos")
    local minutes, remainder = divmod(time_pos, 60)
    local hours, minutes = divmod(minutes, 60)
    local seconds = math.floor(remainder)
    local milliseconds = math.floor((remainder - seconds) * 1000)
    local time = string.format("'%02d\\:%02d\\:%02d.%03d'", hours, minutes, seconds, milliseconds)
    if set_clipboard(time) then
        mp.osd_message(string.format("FFmpeg Time Copied to Clipboard: %s", time))
    else
        mp.osd_message("Failed to copy FFmpeg time to clipboard")
    end
end

-- Copy Filename with Extension
local function copyFilename()
    local filename = string.format("%s", mp.get_property_osd("filename"))
    local extension = string.match(filename, "%.(%w+)$")

    local succ_message = "Filename Copied to Clipboard"
    local fail_message = "Failed to copy filename to clipboard"

    -- If filename doesn't have an extension then it is a URL.
    if not extension then
        filename = mp.get_property_osd("path")

        succ_message = "URL Copied to Clipboard"
        fail_message = "Failed to copy URL to clipboard"
    end

    -- Add quotation marks around the filename
    local quoted_filename = string.format('"%s"', filename)

    if set_clipboard(quoted_filename) then
        mp.osd_message(string.format("%s: %s", succ_message, quoted_filename))
    else
        mp.osd_message(string.format("%s", fail_message))
    end
end

-- Copy Full Filename Path
local function copyFullPath()
    local full_path = mp.get_property_osd("path")
    
    -- If path is relative, prepend working directory
    if platform == WINDOWS then
        -- Check if path is not absolute (doesn't start with drive letter or \\)
        if not string.match(full_path, "^%a:") and not string.match(full_path, "^\\\\") then
            full_path = string.format("%s\\%s", mp.get_property_osd("working-directory"), full_path)
        end
    else
        -- Check if path is not absolute (doesn't start with /)
        if not string.match(full_path, "^/") then
            full_path = string.format("%s/%s", mp.get_property_osd("working-directory"), full_path)
        end
    end

    -- Add quotation marks around the path
    local quoted_path = string.format('"%s"', full_path)

    if set_clipboard(quoted_path) then
        mp.osd_message(string.format("Full Filename Path Copied to Clipboard: %s", quoted_path))
    else
        mp.osd_message("Failed to copy full filename path to clipboard")
    end
end

-- Copy Current Displayed Subtitle
local function copySubtitle()
    local subtitle = string.format("%s", mp.get_property_osd("sub-text"))

    if subtitle == "" then
        mp.osd_message("There are no displayed subtitles.")
        return
    end

    if set_clipboard(subtitle) then
        mp.osd_message(string.format("Displayed Subtitle Copied to Clipboard: %s", subtitle))
    else
        mp.osd_message("Failed to copy displayed subtitle to clipboard")
    end
end

-- Copy Current Video Duration
local function copyDuration()
    local duration = mp.get_property_number("duration")
    
    if not duration then
        mp.osd_message("Duration not available")
        return
    end
    
    local minutes, remainder = divmod(duration, 60)
    local hours, minutes = divmod(minutes, 60)
    local seconds = math.floor(remainder)
    local milliseconds = math.floor((remainder - seconds) * 1000)
    local formatted_duration = string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)

    if set_clipboard(formatted_duration) then
        mp.osd_message(string.format("Video Duration Copied to Clipboard: %s", formatted_duration))
    else
        mp.osd_message("Failed to copy video duration to clipboard")
    end
end

-- Copy Current Video Metadata
local function copyMetadata()
    local metadata = string.format("%s", mp.get_property_osd("metadata"))

    if set_clipboard(metadata) then
        mp.osd_message(string.format("Video Metadata Copied to Clipboard: %s", metadata))
    else
        mp.osd_message("Failed to copy metadata to clipboard")
    end
end

platform = platform_type()
if platform == UNIX then
    clipboard_cmd = get_clipboard_cmd()
end

-- Key-Bindings
mp.add_key_binding("Ctrl+c", "copyTime", copyTime)
mp.add_key_binding("Ctrl+C", "copyTimeFFmpeg", copyTimeFFmpeg)
mp.add_key_binding("Ctrl+n", "copyFilename", copyFilename)
mp.add_key_binding("Ctrl+p", "copyFullPath", copyFullPath)
mp.add_key_binding("Ctrl+S", "copySubtitle", copySubtitle)
mp.add_key_binding("Ctrl+d", "copyDuration", copyDuration)
mp.add_key_binding("Ctrl+m", "copyMetadata", copyMetadata)