function GetSubmenuHandler(buttonWindow, panelWindow, submenus)
	
	local externalFunctions = {}
	local submenuPanelNames = {}
	
	-------------------------------------------------------------------
	-- Submenu Handling
	-------------------------------------------------------------------
	local buttonsHolder = Control:New {
		x = 0,
		y = 0,
		right = 0,
		bottom = 0,
		name = "buttonsHolder",
		parent = buttonWindow,
		padding = {0, 0, 0, 0},
		children = {}
	}
	
	local submenuCount = #submenus
	local buttonHeight = 100/submenuCount .. "%"

	for i = 1, #submenus do
		
		if not submenus[i].exitGame then
			local panelHandler = GetTabPanelHandler(submenus[i].name, buttonWindow, panelWindow, submenus[i].tabs, true)
			panelHandler.Hide()
			panelHandler.AddTab(i18n("back"), function(self) 
				panelHandler.Hide() 
				if not buttonsHolder.visible then
					buttonsHolder:Show()
				end
				
				if panelWindow.children[1] and panelHandler.GetManagedControlByName(panelWindow.children[1].name) then
					panelWindow:ClearChildren()
					if panelWindow.visible then
						panelWindow:Hide()
					end
				end
			end, 6)
			
			submenuPanelNames[submenus[i].name] = panelHandler
			
			submenus[i].panelHandler = panelHandler
		end
		
		submenus[i].button = Button:New {
			x = 0,
			y = 100*(i - 1)/submenuCount .. "%",
			width = "100%",
			height = buttonHeight,
			caption = i18n(submenus[i].name),
			font = { size = 20},
			parent = buttonsHolder,
			OnClick = {function(self) 
				if submenus[i].exitGame then
					Spring.Echo("Quitting...")
					Spring.SendCommands("quitforce")
					return
				end
				
				if buttonsHolder.visible then
					buttonsHolder:Hide()
				end
				
				submenus[i].panelHandler.Show()
			end},
		}
	end
	
	-------------------------------------------------------------------
	-- External Functions
	-------------------------------------------------------------------
	function externalFunctions.GetTabList(name)
		return submenuPanelNames[name]
	end
	
	return externalFunctions
end