GPad = {}
GPad.DEVMODE = true

if not Metro then 
	include("autorun/metro.lua")
end

include("gpad/loader.lua")
include("gpad/constructor.lua")

GPad.VFS = {}
GPad.VFS.Protocol = {}

include("gpad/vfs.lua")
include("gpad/vfs/bufferobject.lua")
include("gpad/vfs/protocol.lua")
include("gpad/vfs/root.lua")
include("gpad/vfs/file.lua")
include("gpad/vfs/copyfs.lua")

GPad.VFTP = {}

include("gpad/vftp.lua")
GPad.IncludeDir("vftp", true, "sh")

GPad.Table = {}
include("gpad/table.lua")

if not glon then
	include("gpad/glon.lua")
end

function GPad.PrintDebug(...)
	Msg"[GPad] " print(...)
end

if SERVER then return end

include("gpad/doctypes.lua")

GPad.IncludeDir("documents", true)

GPad.Stack = {}
GPad.IncludeDir("stack", true)

GPad.IncludeDir("ui", true)
GPad.IncludeDir("ide", true)

GPad.Decompiler = {}
GPad.IncludeDir("decompiler", true)

GPad.GLua = {}
GPad.IncludeDir("compilers", true)

--RunConsoleCommand("gpad_show")