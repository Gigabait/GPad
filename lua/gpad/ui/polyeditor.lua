PANEL = {}

function PANEL:Init()
	self.SnapTo = 20
	self.SnapPoints = {1,2,5,10,20,50,100}

	self.PolygonData = {{}}
	self.CurrentPoly = 1
	
	self:SetCursor("blank")
end
function PANEL:PaintOver(w,h)
		
	for k,poly in ipairs(self.PolygonData)do
			surface.SetTextColor(100,100,100,255)
			for k1,point in ipairs(poly)do
				surface.SetTextPos(point.x-35, point.y-50)
				surface.SetFont("MetroSmall")
				surface.DrawText("x: "..point.x.."; y: "..point.y)
				draw.RoundedBox(4, point.x-2, point.y-2, 5, 5, Color(0, 120, 205, 255))
			end
			
			local polygoncopy = {}
			table.CopyFromTo(poly or {}, polygoncopy)
			if k == self.CurrentPoly then
				table.insert(polygoncopy, {x=math.RoundToNearest(self:ScreenToLocal(gui.MouseX()), self.SnapTo), y=math.RoundToNearest(self:ScreenToLocal(gui.MouseY()-15), self.SnapTo)})
			end
			draw.NoTexture()
			surface.SetDrawColor(0, 120, 205,180)
			surface.DrawPoly(polygoncopy)			
	end
	
	draw.RoundedBox(4, math.RoundToNearest(self:ScreenToLocal(gui.MouseX()), self.SnapTo)-2, math.RoundToNearest(self:ScreenToLocal(gui.MouseY()-15), self.SnapTo)-2, 5, 5, Color(105, 32, 122))
	
	surface.SetTextColor(100,100,100,255)
	surface.SetFont("MetroSmall")
	surface.SetTextPos(10, 20)
	surface.DrawText("x: "..math.RoundToNearest(self:ScreenToLocal(gui.MouseX()), self.SnapTo).."; y: "..math.RoundToNearest(self:ScreenToLocal(gui.MouseY()-15), self.SnapTo))
	surface.SetTextPos(10, 35)
	surface.DrawText("Current Poly: "..#self.PolygonData[self.CurrentPoly])
	surface.SetTextPos(10, 50)
	surface.DrawText("All Polygons: "..#self.PolygonData)
end

function PANEL:Paint(w,h)
	draw.NoTexture()
	surface.SetDrawColor(240, 240, 240, 255)
	surface.DrawRect(0,0,w,h)
	
	surface.SetDrawColor(100,100,100,150)
	for i=self.SnapTo, ScrW(), self.SnapTo do
		surface.DrawLine(i, 0, i, ScrH())
		surface.DrawLine(0, i, ScrW(), i)
	end
end
function PANEL:OnMousePressed(mc)
	if mc == MOUSE_LEFT then
		table.insert(self.PolygonData[self.CurrentPoly], {x=math.RoundToNearest(self:ScreenToLocal(gui.MouseX()), self.SnapTo), y=math.RoundToNearest(self:ScreenToLocal(gui.MouseY()-15), self.SnapTo)})
		
	elseif mc == MOUSE_RIGHT then
		local mnu = DermaMenu()
			mnu:AddOption("Export", function()
				self:Export()
			end):SetIcon("icon16/application_go.png")
			mnu:AddSpacer()
			mnu:AddOption("Add Polygon", function()
				self.CurrentPoly = self.CurrentPoly + 1
				self.PolygonData[self.CurrentPoly] = {}
			end):SetIcon("icon16/shape_square_add.png")
			mnu:AddOption("Clear", function()
				self.PolygonData[self.CurrentPoly] = {}
			end):SetIcon("icon16/note_delete.png")
			mnu:AddOption("Clear All", function()
				self.PolygonData = {{}}
				self.CurrentPoly = 1
			end):SetIcon("icon16/bin_closed.png")
			mnu:AddSpacer()
			local snap, m = mnu:AddSubMenu("Snap To...")
			m:SetIcon("icon16/zoom.png")
			for k,v in pairs(self.SnapPoints)do
				snap:AddOption(v, function()
					self.SnapTo = v
				end)
			end
			mnu:AddSpacer()
			mnu:AddOption("Cancel", function() end):SetIcon("icon16/cross.png")
			mnu:Open()
	elseif mc == MOUSE_MIDDLE then
		self:SetCursor("sizeall") -- ToDo: Free Snap
	end
end

function PANEL:OnMouseReleased(mc)
	if mc == MOUSE_MIDDLE then
		self:SetCursor("arrow")
	end
end

function PANEL:Export()
	local de = Color(200,200,200)
	local op = Color(150,150,255)
	local co = Color(0,128,0)
	local ar = Color(255,255,200)
	local fu = Color(255,132,252)
	MsgC(op, "local ")MsgC(de, "polydata = ")MsgC(ar, "{}")
	MsgC(co, " -- Put all this stuff OUTSIDE your paint hook.")
	local rtrn = ""
	for key,poly in ipairs(self.PolygonData)do
		MsgC(de, [[

   polydata[]]..key.."] =")MsgC(ar, " {} \n")
		for key2,point in ipairs(poly)do
		MsgC(de, [[	polydata[]]..key..[[][]]..key2..[[] = { x = ]]..point.x..[[, y = ]]..point.y..[[ }]].."\n")
		end
	end
	Msg(rtrn)
	MsgC(fu, "table.foreachi") 
	MsgC(de, "(polydata, ")
	MsgC(op, "function")
	MsgC(de, "(k,v) ")
	MsgC(fu, "surface.DrawPoly")
	MsgC(de, "(v) ")
	MsgC(op, "end")
	MsgC(de, ")")
	MsgC(co, " -- Put this in your paint hook.\n")
	RunConsoleCommand("showconsole")
end

function PANEL:CopyToClipboard()
	local rtrn = "local polydata = {}"
	for key,poly in ipairs(self.PolygonData) do
		rtrn = rtrn..[[

	polydata[]]..key..[[] = {}]]
		for key2,point in ipairs(poly)do
			rtrn = rtrn..[[

		polydata[]]..key..[[][]]..key2..[[] = { x = ]]..point.x..[[, y = ]]..point.y..[[ }]]
		end
	end
	SetClipboardText(rtrn.." --Put all this stuff OUTSIDE your paint hook.\n\ntable.foreachi(polydata, function(k,v) surface.DrawPoly(v) end) --Put this in your paint hook.")
end

Metro.Register("GPadMetroEditor", PANEL, "DPanel")