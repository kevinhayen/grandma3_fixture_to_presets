local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)
local chkMerge = nil;

-- The sorting order is defined by variable ftpColorRGBNames, while the RGB value comes from ftpColorRGB
local ftpColorRGBNames		= {'White', 'CTO', 'CTB', 'Red', 'Orange', 'Amber', 'Yellow', 'Fern Green', 'Green', 'Sea Green', 'Cyan', 'Lavender', 'Blue', 'Violet', 'Magenta', 'Pink', 'Cold White', 'Warm White'}
local ftpColorRGB 			= {};
ftpColorRGB['White'] 		= '255,255,255'
ftpColorRGB['CTO'] 			= '255,227,175'
ftpColorRGB['CTB'] 			= '176,227,255'
ftpColorRGB['Red']  		= '255,000,000'
ftpColorRGB['Orange']		= '255,128,000'
ftpColorRGB['Amber']		= '255,191,000'
ftpColorRGB['Yellow']		= '255,255,000'
ftpColorRGB['Fern Green']	= '128,255,000'
ftpColorRGB['Green']		= '000,255,000'
ftpColorRGB['Sea Green']	= '000,255,127'
ftpColorRGB['Cyan']			= '000,255,255'
ftpColorRGB['Lavender']		= '000,128,255'
ftpColorRGB['Blue']			= '000,000,255'
ftpColorRGB['Violet']		= '128,000,255'
ftpColorRGB['Magenta']		= '255,000,255'
ftpColorRGB['Pink']			= '255,000,128'
ftpColorRGB['Cold White']	= '230,255,255'
ftpColorRGB['Warm White']	= '255,255,230'

local function fixture_to_presets(displayHandle)

	SetVar(UserVars(),"ftpForceMerge", false);

	------------------------------
	-- begin of screen creation --
	------------------------------

	 -- Get the index of the display on which to create the dialog.
	local displayIndex = Obj.Index(GetFocusDisplay())
	if displayIndex > 5 then
		displayIndex = 1
	end
	
	-- Get the colors.
	local colorTransparent = Root().ColorTheme.ColorGroups.Global.Transparent
	local colorBackground = Root().ColorTheme.ColorGroups.Button.Background
	local colorBackgroundPlease = Root().ColorTheme.ColorGroups.Button.BackgroundPlease
	local colorPartlySelected = Root().ColorTheme.ColorGroups.Global.PartlySelected
	local colorPartlySelectedPreset = Root().ColorTheme.ColorGroups.Global.PartlySelectedPreset
	
	-- Get the overlay.
	local display = GetDisplayByIndex(displayIndex)
	local screenOverlay = display.ScreenOverlay
	
	-- Delete any UI elements currently displayed on the overlay.
	screenOverlay:ClearUIChildren()   

	-- Create the dialog base.
	local dialogWidth = 1400
	local baseInput = screenOverlay:Append("BaseInput")
	baseInput.Name = "DMXTesterWindow"
	baseInput.H = "0"
	baseInput.W = dialogWidth
	baseInput.MaxSize = string.format("%s,%s", display.W * 0.8, display.H)
	baseInput.MinSize = string.format("%s,0", dialogWidth - 100)
	baseInput.Columns = 1  
	baseInput.Rows = 2
	baseInput[1][1].SizePolicy = "Fixed"
	baseInput[1][1].Size = "60"
	baseInput[1][2].SizePolicy = "Stretch"
	baseInput.AutoClose = "Yes"
	baseInput.CloseOnEscape = "Yes"
	
	-- Create the title bar.
	local titleBar = baseInput:Append("TitleBar")
	titleBar.Columns = 2  
	titleBar.Rows = 1
	titleBar.Anchors = "0,0"
	titleBar[2][2].SizePolicy = "Fixed"
	titleBar[2][2].Size = "50"
	titleBar.Texture = "corner2"
	
	local titleBarIcon = titleBar:Append("TitleButton")
	titleBarIcon.Text = "Fixture to Presets - by Haai"
	titleBarIcon.Texture = "corner1"
	titleBarIcon.Anchors = "0,0"
	titleBarIcon.Icon = "object_subfixture1"
	
	local titleBarCloseButton = titleBar:Append("CloseButton")
	titleBarCloseButton.Anchors = "1,0"
	titleBarCloseButton.Texture = "corner2"
	
	-- Create the dialog's main frame.
	local dlgFrame = baseInput:Append("DialogFrame")
	dlgFrame.H = "100%"
	dlgFrame.W = "100%"
	dlgFrame.Columns = 1  
	dlgFrame.Rows = 3
	dlgFrame.Anchors = {
		left = 0,
		right = 0,
		top = 1,
		bottom = 1
	}
	dlgFrame[1][1].SizePolicy = "Fixed"
	dlgFrame[1][1].Size = "110"
	dlgFrame[1][2].SizePolicy = "Fixed"
	dlgFrame[1][2].Size = "80"
	dlgFrame[1][3].SizePolicy = "Fixed"  
	dlgFrame[1][3].Size = "80" 

	--------------------------
	-- create selected grid --
	--------------------------

	local selectedGrid = dlgFrame:Append("UILayoutGrid")
	selectedGrid.Columns = 2
	selectedGrid.Rows = 1
	selectedGrid.Anchors = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0
	}
	selectedGrid.Margin = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 5    
	}

	local tblSelected = {};

	tblSelected[1] = selectedGrid:Append("Button")
	tblSelected[1].Anchors = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0
	}
	tblSelected[1].Margin = {
		left = 2,
		right = 2,
		top = 2,
		bottom = 2    
	}
	tblSelected[1].HasHover = "Yes";
	tblSelected[1].PluginComponent = myHandle
	tblSelected[1].Clicked = "ChangeFixtureClick";
	tblSelected[1].Text = "Please patch some fixtures, or just click this button to reset this plugin";

	tblSelected[2] = selectedGrid:Append("Button")
	tblSelected[2].Anchors = {
		left = 1,
		right = 1,
		top = 0,
		bottom = 0
	}
	tblSelected[2].Margin = {
		left = 2,
		right = 2,
		top = 2,
		bottom = 2    
	}
	tblSelected[2].HasHover = "No";
	tblSelected[2].Text = ""

	-------------------------
	-- create second label --
	-------------------------

	local subGrid = dlgFrame:Append("UILayoutGrid")
	subGrid.Columns = 1
	subGrid.Rows = 1
	subGrid.Anchors = {
		left = 0,
		right = 0,
		top = 1,
		bottom = 1
	}
	subGrid.Margin = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0   
	}

	local subOptions = subGrid:Append("UIObject")
	subOptions.Text = ""
	subOptions.ContentDriven = "Yes"
	subOptions.ContentWidth = "No"
	subOptions.TextAutoAdjust = "No"
	subOptions.Anchors = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0
	}
	subOptions.Padding = {
		left = 20,
		right = 20,
		top = 15,
		bottom = 15
	}
	subOptions.Font = "Medium20"
	subOptions.HasHover = "No"
	subOptions.BackColor = colorTransparent 


	-------------------------
	-- create options grid --
	-------------------------

	local optionsGrid = dlgFrame:Append("UILayoutGrid")
	optionsGrid.Anchors = {
		left = 0,
		right = 0,
		top = 2,
		bottom = 2
	}
	optionsGrid.Margin = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 5    
	}

	----------------------------
	-- begin of data creation --
	----------------------------

	Printf('==============')
	Printf('Print uservars')
	Printf('==============')
	Cmd("GetUserVar ftp*")
	Printf('==============')

	local tblOptions = {};
	local foundAttribute = 0
	local x = 1;
	local y = -1;

	optionsGrid.Columns = 3

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- check if fixture and mode is patched. This plugin can cause an error when a fixture is selected in this plugin, and later unpatched --
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	if GetVar(UserVars(),"ftpClickedFixture") ~= nil and GetVar(UserVars(),"ftpClickedFixtureMode") ~= nil then
		local fixturesCheck = ShowData().Livepatch.FixtureTypes:Children();
		fixtureFound = '0'
		for fixtureCheck in ipairs(fixturesCheck) do
			local modesCheck = fixturesCheck[fixtureCheck].DMXModes:Children();
			for modeCheck in ipairs(modesCheck) do
				if fixturesCheck[fixtureCheck].name == GetVar(UserVars(),"ftpClickedFixture") and modesCheck[modeCheck].name == GetVar(UserVars(),"ftpClickedFixtureMode") then
					fixtureFound = '1'
				end
			end
		end
		if fixtureFound == '0' then
			DelVar(UserVars(),"ftpClickedFixture")
			DelVar(UserVars(),"ftpClickedFixtureMode")
		end
	end

	-------------------------------------------------------------------------------------------
	-- when an attribute is selected, but you change to a fixture, not having this attribute --
	-------------------------------------------------------------------------------------------

	if GetVar(UserVars(),"ftpFoundAttributeInFixtureError") ~= nil and GetVar(UserVars(),"ftpClickedFixture") ~= nil and GetVar(UserVars(),"ftpClickedAttribute") ~= nil then

		subOptions.Text = 'Fixture "' .. GetVar(UserVars(),"ftpClickedFixture") .. '" has no attribute named "' .. GetVar(UserVars(),"ftpClickedAttribute") .. '"'

		dlgFrame[1][1].Size = "0"

		optionsGrid.Columns = 2

		tblOptions[1] = optionsGrid:Append("Button")
		tblOptions[1].Text = 'Show all attributes of "' .. GetVar(UserVars(),"ftpClickedFixture") .. '"'
		tblOptions[1].Anchors = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0
		}
		tblOptions[1].Margin = {
			left = 2,
			right = 2,
			top = 2,
			bottom = 2    
		}
		tblOptions[1].HasHover = "Yes";
		tblOptions[1].PluginComponent = myHandle
		tblOptions[1].Clicked = "ChangeAttributeClick";

		tblOptions[1] = optionsGrid:Append("Button")
		tblOptions[1].Text = 'Select another fixture'
		tblOptions[1].Anchors = {
			left = 1,
			right = 1,
			top = 0,
			bottom = 0
		}
		tblOptions[1].Margin = {
			left = 2,
			right = 2,
			top = 2,
			bottom = 2    
		}
		tblOptions[1].HasHover = "Yes";
		tblOptions[1].PluginComponent = myHandle
		tblOptions[1].Clicked = "ChangeFixtureClick";

	else

		-----------------------------------------
		-- overview of fixtures or subfixtures --
		-----------------------------------------

		if GetVar(UserVars(),"ftpClickedFixture") == nil then

			local showFixtures = {}
			local fixtures = ShowData().Livepatch.FixtureTypes:Children();
			for fixture in ipairs(fixtures) do

				local fixtureName = fixtures[fixture].name;
				local modes = fixtures[fixture].DMXModes:Children();

				for mode in ipairs(modes) do

					if modes[mode].used > 0 then

						local modeName = modes[mode].name;
						local geometryName = modes[mode].geometry;

						if fixtureName ~= 'Universal' and geometryName ~= '' then
							-- include all subfixtures related to the selected fixture
							local subFixtures = fixture_to_presets_get_subfixtures(fixtureName, geometryName);

							-- put fixtures in array
							for _,subFixture in ipairs(subFixtures) do	
								if subFixture == 'Main' then
									subFix = "";
								else
									subFix = "\n\n" .. subFixture;
								end	
								table.insert(showFixtures, fixtureName .. " :: " .. modeName .. subFix)
							end										
						end
					end
				end
			end

			-- sort fixtures
			table.sort(showFixtures)

			-- show fixtures
			for _,showFixture in ipairs(showFixtures) do	

				dlgFrame[1][1].Size = "0"
				subOptions.Text = "Select Fixture (subfixtures in red)";

				if y == (optionsGrid.Columns - 1) then
					y = -1
					x = #tblOptions + 1;
				end
				y = y + 1;

				tblOptions[x] = optionsGrid:Append("Button")

				if string.find(showFixture, '\n\n') ~= nil then
					tblOptions[x].BackColor = colorBackgroundPlease;
				end

				tblOptions[x].Text = showFixture
				tblOptions[x].Anchors = {
					left = y,
					right = y,
					top = x - 1,
					bottom = x - 1
				}
				tblOptions[x].Margin = {
					left = 2,
					right = 2,
					top = 2,
					bottom = 2    
				}
				tblOptions[x].HasHover = "Yes";
				tblOptions[x].PluginComponent = myHandle
				tblOptions[x].Clicked = "SelectionFixtureClick";
			end
		end

		----------------------------------------------------------------
		-- once a fixture is selected, update this in the button text --
		----------------------------------------------------------------

		if GetVar(UserVars(),"ftpClickedFixture") ~= nil then

			if GetVar(UserVars(),"ftpClickedIsSubFixture") == '1' then
				sub = "\n" .. GetVar(UserVars(),"ftpClickedGeometry")
			else
				sub = ""
			end

			tblSelected[1].Text = GetVar(UserVars(),"ftpClickedFixture") .. " :: " .. GetVar(UserVars(),"ftpClickedFixtureMode") .. sub .. "\n\n(Click to change Fixture)"
		end

		------------------------------------
		-- overview of fixture attributes --
		------------------------------------

		if GetVar(UserVars(),"ftpClickedFixture") ~= nil and GetVar(UserVars(),"ftpClickedAttribute") == nil then

			local showAttributes = {}
			local channels = ShowData().Livepatch.FixtureTypes[GetVar(UserVars(),"ftpClickedFixture")].DMXModes[GetVar(UserVars(),"ftpClickedFixtureMode")].DMXChannels:Children();

			optionsGrid.Columns = 6

			-- find color type (RGB, CMY, none or other)
			fixture_to_presets_get_color_type(channels);

			for channel in ipairs(channels) do
				local channelName = channels[channel].name;		
				local channelGeometry = channels[channel].Geometry.name;
				local channelGeometryModel = ''
				if channels[channel].Geometry.Model ~= nil then
					channelGeometryModel = channels[channel].Geometry.Model.Name;
				end
				local channelsInfo = channels[channel]:Children();

				findSubfix = "::" .. channelGeometry .. "-" .. channelGeometryModel .. "::"
				foundSubfix = string.find(GetVar(UserVars(),"ftpClickedSubFixtures"), findSubfix, 1, true)

				if (GetVar(UserVars(),"ftpClickedIsSubFixture") == '0' and foundSubfix == nil)
				or (GetVar(UserVars(),"ftpClickedIsSubFixture") == '1' and foundSubfix ~= nil) 
				then

					for channelInfo in ipairs(channelsInfo) do

						local channelInfoName = channelsInfo[channelInfo].name;

						subOptions.Text = "Select Attribute";

						fixture_to_presets_get_preset_type(channelInfoName)

						if string.sub(channelInfoName, 1, 8) ~= 'ColorRGB' or (string.sub(channelInfoName, 1, 8) == 'ColorRGB' and (GetVar(UserVars(), 'ftpSelectionColorType') == nil or GetVar(UserVars(), 'ftpSelectionColorCreated') == nil) ) then
							
							if string.sub(channelInfoName, 1, 8) == 'ColorRGB' and (GetVar(UserVars(), 'ftpSelectionColorType') ~= nil and GetVar(UserVars(), 'ftpSelectionColorCreated') == nil) then
								SetVar(UserVars(),"ftpSelectionColorCreated", 'yes');
								channelInfoName = 'Color';
							end

							channelInfoName = GetVar(UserVars(),"ftpPresetType") .. '\n\n' .. channelInfoName

							-- add to 
							table.insert(showAttributes, channelInfoName)
						end
					end
				end
			end	

			-- sort attributes
			table.sort(showAttributes)

			-- show attributes
			for _,showAttribute in ipairs(showAttributes) do	

				if y == (optionsGrid.Columns - 1) then
					y = -1
					x = #tblOptions + 1;
				end
				y = y + 1;

				type = string.sub(showAttribute, 2, string.find(showAttribute, '\n\n'))
				attr = string.sub(showAttribute, string.find(showAttribute, '\n\n') + 2)

				tblOptions[x] = optionsGrid:Append("Button")
				tblOptions[x].Text = attr .. '\n\n' .. type
				tblOptions[x].Anchors = {
					left = y,
					right = y,
					top = x - 1,
					bottom = x - 1
				}
				tblOptions[x].Margin = {
					left = 2,
					right = 2,
					top = 2,
					bottom = 2    
				}
				tblOptions[x].HasHover = "Yes";
				tblOptions[x].PluginComponent = myHandle
				tblOptions[x].Clicked = "SelectionAttributeClick";

			end
		end

		----------------------------------
		-- overview of attribute values --
		----------------------------------

		if GetVar(UserVars(),"ftpClickedFixture") ~= nil and GetVar(UserVars(),"ftpClickedAttribute") ~= nil then

			optionsGrid.Columns = 6

			tblSelected[2].HasHover = "Yes";
			tblSelected[2].Text = GetVar(UserVars(),"ftpClickedAttribute") .. "\n\n(Click to change Attribute)"
			tblSelected[2].PluginComponent = myHandle
			tblSelected[2].Clicked = "ChangeAttributeClick";

			subGrid.Columns = 20;
			subOptions.Anchors = {
				left = 0,
				right = 19,
				top = 0,
				bottom = 0
			};
			subOptions.Text = "Store Preset by clicking";

			chkPreview = subGrid:Append("CheckBox")
			chkPreview.Anchors = {
				left = 0,
				right = 1,
				top = 0,
				bottom = 0
			}    
			chkPreview.Margin = {
					left = 8,
					right = 8,
					top = 15,
					bottom = 15    
				}
				chkPreview.Text = "Preview"
				chkPreview.TextalignmentH = "Left";
				chkPreview.State = GetVar(UserVars(),"ftpClickedPreview");
				chkPreview.PluginComponent = myHandle
				chkPreview.Clicked = "chkPreviewClicked"
				chkPreview.HasHover = "Yes";

			chkMerge = subGrid:Append("CheckBox")
			chkMerge.Anchors = {
				left = 18,
				right = 19,
				top = 0,
				bottom = 0
			}    
			chkMerge.Margin = {
					left = 8,
					right = 8,
					top = 15,
					bottom = 15    
				}
			chkMerge.Text = "Merge"
			chkMerge.TextalignmentH = "Left";
			chkMerge.State = GetVar(UserVars(),"ftpClickedMerge");
			chkMerge.PluginComponent = myHandle
			chkMerge.Clicked = "chkMergeClicked"
			chkMerge.HasHover = "Yes";

			btnLeft = subGrid:Append("Button")
			btnLeft.Anchors = {
				left = 15,
				right = 15,
				top = 0,
				bottom = 0
			}
			btnLeft.Margin = {
				left = 3,
				right = 3,
				top = 15,
				bottom = 15    
			}
			btnLeft.HasHover = "Yes";
			btnLeft.PluginComponent = myHandle
			btnLeft.Clicked = "btnLeftClick";
			btnLeft.Text = "<";

			btnDMX = subGrid:Append("Button")
			btnDMX.Anchors = {
				left = 16,
				right = 16,
				top = 0,
				bottom = 0
			}
			btnDMX.Margin = {
				left = 0,
				right = 0,
				top = 15,
				bottom = 15    
			}
			btnDMX.HasHover = "Yes";
			btnDMX.PluginComponent = myHandle
			btnDMX.Clicked = "btnDMXClick";
			btnDMX.Text = "100";

			btnRight = subGrid:Append("Button")
			btnRight.Anchors = {
				left = 17,
				right = 17,
				top = 0,
				bottom = 0
			}
			btnRight.Margin = {
				left = 3,
				right = 3,
				top = 15,
				bottom = 15    
			}
			btnRight.HasHover = "Yes";
			btnRight.PluginComponent = myHandle
			btnRight.Clicked = "btnRightClick";
			btnRight.Text = ">";

			fixture_to_presets_get_preset_type(GetVar(UserVars(),"ftpClickedAttribute"))
			fixture_to_presets_find_first_empty_preset(">")

			local channels = ShowData().Livepatch.FixtureTypes[GetVar(UserVars(),"ftpClickedFixture")].DMXModes[GetVar(UserVars(),"ftpClickedFixtureMode")].DMXChannels:Children();

			for channel in ipairs(channels) do
				
				local channelGeometry = channels[channel].Geometry.name;

				local channelGeometryModel = ''
				if channels[channel].Geometry.Model ~= nil then
					channelGeometryModel = channels[channel].Geometry.Model.Name;
				end

				findSubfix = "::" .. channelGeometry .. "-" .. channelGeometryModel .. "::"
				foundSubfix = string.find(GetVar(UserVars(),"ftpClickedSubFixtures"), findSubfix, 1, true)

				if (GetVar(UserVars(),"ftpClickedIsSubFixture") == '0' and foundSubfix == nil)
				or (GetVar(UserVars(),"ftpClickedIsSubFixture") == '1' and foundSubfix ~= nil) 
				then

					local channelsInfo = channels[channel]:Children();

					for channelInfo in ipairs(channelsInfo) do

						if channelsInfo[channelInfo].name == GetVar(UserVars(),"ftpClickedAttribute") or (GetVar(UserVars(),"ftpClickedAttribute") == 'Color' and (channelsInfo[channelInfo].name == 'ColorRGB_R' or channelsInfo[channelInfo].name == 'ColorRGB_C')) then

							local channelGroups = channelsInfo[channelInfo]:Children();

							if string.sub(channelsInfo[channelInfo].name, 1, 8) ~= 'ColorRGB' then

								for channelGroup in ipairs(channelGroups) do

									local channelGroupName = channelGroups[channelGroup].attribute
									local channelValues = channelGroups[channelGroup]:Children();

									for channelValue in ipairs(channelValues) do

										local channelValueName = channelValues[channelValue].name;
										local channelValueDMX = channelValues[channelValue].dmxfrom;

										if channelValueName ~= 'No Feature' then

											if y == (optionsGrid.Columns - 1) then
												y = -1
												x = #tblOptions + 1;
											end
											y = y + 1;

											local channelValueDMX = (tonumber(channelValues[channelValue].dmxfrom) + tonumber(channelValues[channelValue].dmxto)) / 2
											channelValueDMX = math.floor(channelValueDMX / 65793);
											channelValueDMX = tostring(channelValueDMX);

											tblOptions[x] = optionsGrid:Append("Button")
											tblOptions[x].Text = channelValueName .. '\n\n' .. channelValueDMX
											tblOptions[x].Anchors = {
												left = y,
												right = y,
												top = x - 1,
												bottom = x - 1
											}
											tblOptions[x].Margin = {
												left = 2,
												right = 2,
												top = 2,
												bottom = 2    
											}
											tblOptions[x].HasHover = "Yes";
											tblOptions[x].PluginComponent = myHandle
											tblOptions[x].Clicked = "SelectionValueClick";

										end
									end
								end
							end

							if string.sub(channelsInfo[channelInfo].name, 1, 8) == 'ColorRGB' then

								if y == (optionsGrid.Columns - 1) then
									y = -1
									x = #tblOptions + 1;
								end
								y = y + 1;

								tblOptions[x] = optionsGrid:Append("Button")
								tblOptions[x].Text = 'Create All Colors\n\n(Auto-Merge if exists)';
								tblOptions[x].BackColor = colorBackgroundPlease;
								tblOptions[x].Anchors = {
									left = y,
									right = y,
									top = x - 1,
									bottom = x - 1
								}
								tblOptions[x].Margin = {
									left = 2,
									right = 2,
									top = 2,
									bottom = 2    
								}
								tblOptions[x].HasHover = "Yes";
								tblOptions[x].PluginComponent = myHandle
								tblOptions[x].Clicked = "SelectionColorRGBAllClick";

								for color in pairs(ftpColorRGBNames) do

									if y == (optionsGrid.Columns - 1) then
										y = -1
										x = #tblOptions + 1;
									end
									y = y + 1;

									tblOptions[x] = optionsGrid:Append("Button")
									tblOptions[x].Text = ftpColorRGBNames[color]
									tblOptions[x].Anchors = {
										left = y,
										right = y,
										top = x - 1,
										bottom = x - 1
									}
									tblOptions[x].Margin = {
										left = 2,
										right = 2,
										top = 2,
										bottom = 2    
									}
									tblOptions[x].HasHover = "Yes";
									tblOptions[x].PluginComponent = myHandle
									tblOptions[x].Clicked = "SelectionColorRGBClick";

								end
							end
						end
					end
				end
			end
		end
	end

	optionsGrid.Rows = #tblOptions;
	dlgFrame[1][3].Size = #tblOptions * 100;

	signalTable.SelectionFixtureClick = function(caller)
		if string.find(caller.Text, '\n\n') == nil then
			clickedFixture = string.sub(caller.Text, 0, string.find(caller.Text, '::') - 2);
			clickedFixtureMode = string.sub(caller.Text, string.find(caller.Text, '::') + 3);
			clickedGeometry = ShowData().Livepatch.FixtureTypes[clickedFixture].DMXModes[clickedFixtureMode].Geometry;
			SetVar(UserVars(),"ftpClickedIsSubFixture", '0');
		else			
			FixtureMode = string.sub(caller.Text, 0, string.find(caller.Text, '\n\n') - 1)
			clickedFixture = string.sub(FixtureMode, 0, string.find(caller.Text, '::') - 2);
			clickedFixtureMode = string.sub(FixtureMode, string.find(caller.Text, '::') + 3);
			clickedGeometry = string.sub(caller.Text, string.find(caller.Text, '\n\n') + 2);
			SetVar(UserVars(),"ftpClickedIsSubFixture", '1');
		end
		SetVar(UserVars(),"ftpClickedFixture", clickedFixture);
		SetVar(UserVars(),"ftpClickedFixtureMode", clickedFixtureMode);
		SetVar(UserVars(),"ftpClickedGeometry", clickedGeometry);

		local geos = ShowData().Livepatch.FixtureTypes[clickedFixture].Geometries:Children();
		SetVar(UserVars(),"ftpClickedGeometryModel", nil)
		SetVar(UserVars(),"ftpClickedSubFixtures", '::')
		for geo in ipairs(geos) do
			-- find geometry model, this is linked to the geometry in the attributes
			if geos[geo].name == GetVar(UserVars(),"ftpClickedGeometry") and geos[geo].Model ~= nil then
				SetVar(UserVars(),"ftpClickedGeometryModel", geos[geo].Model.name)
			end
			-- list all subfixture geometries in one string, to verify if a subfixture is selected, or the main fixture, when looping the attributes
			if geos[geo].Model ~= nil then
				SetVar(UserVars(),"ftpClickedSubFixtures", GetVar(UserVars(),"ftpClickedSubFixtures") .. '::' .. geos[geo].name .. '-' .. geos[geo].Model.name .. '::')
			end
		end	

		-- check if a previously selected attribute is linked to the current selected fixture
		DelVar(UserVars(),"ftpFoundAttributeInFixtureError");
		if GetVar(UserVars(),"ftpClickedAttribute") ~= nil then
			SetVar(UserVars(),"ftpFoundAttributeInFixtureError", '1');
			local channels = ShowData().Livepatch.FixtureTypes[GetVar(UserVars(),"ftpClickedFixture")].DMXModes[GetVar(UserVars(),"ftpClickedFixtureMode")].DMXChannels:Children();
			for channel in ipairs(channels) do
				local channelName = channels[channel].name;
				local channelGeometry = channels[channel].Geometry.name;

				foundSubfix = nil;
				if channels[channel].Geometry.Model ~= nil then
					local channelGeometryModel = channels[channel].Geometry.Model.Name;
					findSubfix = "::" .. channelGeometry .. "-" .. channelGeometryModel .. "::"
					foundSubfix = string.find(GetVar(UserVars(),"ftpClickedSubFixtures"), findSubfix, 1, true)
				end
				
				local channelsInfo = channels[channel]:Children();

				if (GetVar(UserVars(),"ftpClickedIsSubFixture") == '0' and foundSubfix == nil)
				or (GetVar(UserVars(),"ftpClickedIsSubFixture") == '1' and foundSubfix ~= nil) 
				then
					for channelInfo in ipairs(channelsInfo) do
						if channelsInfo[channelInfo].name == GetVar(UserVars(),"ftpClickedAttribute") or (GetVar(UserVars(),"ftpClickedAttribute") == 'Color' and (channelsInfo[channelInfo].name == 'ColorRGB_R' or channelsInfo[channelInfo].name == 'ColorRGB_C')) then
							DelVar(UserVars(),"ftpFoundAttributeInFixtureError");
						end
					end
				end
			end
		end

		Cmd("Call Plugin " .. pluginName);
	end

	signalTable.SelectionAttributeClick = function(caller)
		attribute = string.sub(caller.Text, 0, string.find(caller.Text, '\n\n') - 1) 
		SetVar(UserVars(),"ftpClickedAttribute", attribute);
		Cmd("Call Plugin " .. pluginName);
	end

	signalTable.SelectionValueClick = function(caller)
		clickedValueName = string.sub(caller.Text, 0, string.find(caller.Text, '\n\n') - 1);
		clickedValue = string.sub(caller.Text, string.find(caller.Text, '\n\n') + 2);
		SetVar(UserVars(),"ftpClickedValue", clickedValue);
		SetVar(UserVars(),"ftpChannelValueName", clickedValueName);
		fixture_to_presets_execute();
	end

	signalTable.SelectionColorRGBAllClick = function(caller)
		SetVar(UserVars(), 'ftpForceMerge', true);
		for color in pairs(ftpColorRGBNames) do
			fixture_to_presets_storeColorRGB(ftpColorRGBNames[color]);
		end
		SetVar(UserVars(), 'ftpForceMerge', false);
	end

	signalTable.SelectionColorRGBClick = function(caller)
		fixture_to_presets_storeColorRGB(caller.Text);
	end

	signalTable.btnLeftClick = function(caller)
		presetNo = tonumber(GetVar(UserVars(), "ftpPresetNumber" .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2))) - 1
		SetVar(UserVars(), "ftpPresetSetNo", presetNo)
		fixture_to_presets_find_first_empty_preset("<")
	end

	signalTable.btnDMXClick = function(caller)
		preset = TextInput(': " Preset Number to store');
		if preset == nil then
			preset = '1';
		end
		if tonumber(preset) then
			SetVar(UserVars(), "ftpPresetSetNo", preset)
			fixture_to_presets_find_first_empty_preset(">")
		end
	end

	signalTable.btnRightClick = function(caller)
		presetNo = tonumber(GetVar(UserVars(), "ftpPresetNumber" .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2))) + 1
		SetVar(UserVars(), "ftpPresetSetNo", presetNo)
		fixture_to_presets_find_first_empty_preset(">")
	end

	function fixture_to_presets_storeColorRGB(label)

		local channels = ShowData().Livepatch.FixtureTypes[GetVar(UserVars(),"ftpClickedFixture")].DMXModes[GetVar(UserVars(),"ftpClickedFixtureMode")].DMXChannels:Children();
		-- find color type (RGB, CMY, none or other)
		fixture_to_presets_get_color_type(channels);

		SetVar(UserVars(), 'ftpChannelValueName', label);
		SetVar(UserVars(), "ftpPresetType", '4Color');
		SetVar(UserVars(), "ftpIsColorAssigned", false);

		dmxValues = fixture_to_presets_split(ftpColorRGB[label], ',')

		fixture_to_presets_store_info()

		if tonumber(GetVar(UserVars(), 'ftpStorePreset')) > 0 then

			fixture_to_presets_select_fixtures(GetVar(UserVars(), 'ftpClickedFixture'), GetVar(UserVars(), 'ftpClickedFixtureMode'));

			if string.find(GetVar(UserVars(),"ftpSelectionColorAssigned"), '-ColorRGB_RY-') and GetVar(UserVars(),"ftpChannelValueName") == 'Amber' then
				Cmd('Attribute "ColorRGB_RY" At 255');
				fixture_to_presets_setColorsToZero();
			end
			if string.find(GetVar(UserVars(),"ftpSelectionColorAssigned"), '-ColorRGB_GY-') and GetVar(UserVars(),"ftpChannelValueName") == 'Lime' then
				Cmd('Attribute "ColorRGB_GY" At 255');
				fixture_to_presets_setColorsToZero();
			end
			if string.find(GetVar(UserVars(),"ftpSelectionColorAssigned"), '-ColorRGB_BM-') and GetVar(UserVars(),"ftpChannelValueName") == 'Purple' then
				Cmd('Attribute "ColorRGB_BM" At 255');
				fixture_to_presets_setColorsToZero();
			end
			if string.find(GetVar(UserVars(),"ftpSelectionColorAssigned"), '-ColorRGB_RM-') and GetVar(UserVars(),"ftpChannelValueName") == 'Pink' then
				Cmd('Attribute "ColorRGB_RM" At 255');
				fixture_to_presets_setColorsToZero();
			end
			if string.find(GetVar(UserVars(),"ftpSelectionColorAssigned"), '-ColorRGB_W-') and GetVar(UserVars(),"ftpChannelValueName") == 'Open' then
				Cmd('Attribute "ColorRGB_W" At 255');
				fixture_to_presets_setColorsToZero();
			end
			if string.find(GetVar(UserVars(),"ftpSelectionColorAssigned"), '-ColorRGB_WW-') and GetVar(UserVars(),"ftpChannelValueName") == 'Warm White' then
				Cmd('Attribute "ColorRGB_WW" At 255');
				fixture_to_presets_setColorsToZero();
			end
			if string.find(GetVar(UserVars(),"ftpSelectionColorAssigned"), '-ColorRGB_CW-') and GetVar(UserVars(),"ftpChannelValueName") == 'Cold White' then
				Cmd('Attribute "ColorRGB_CW" At 255');
				fixture_to_presets_setColorsToZero();
			end
			if string.find(GetVar(UserVars(),"ftpSelectionColorAssigned"), '-ColorRGB_UV-') and GetVar(UserVars(),"ftpChannelValueName") == 'UV' then
				Cmd('Attribute "ColorRGB_UV" At 255');
				fixture_to_presets_setColorsToZero();
			end

			if GetVar(UserVars(),"ftpIsColorAssigned") == false then

				if GetVar(UserVars(),"ftpSelectionColorType") == 'RGB' then
					Cmd('Attribute "ColorRGB_R" At ' .. dmxValues[1]);
					Cmd('Attribute "ColorRGB_G" At ' .. dmxValues[2]);
					Cmd('Attribute "ColorRGB_B" At ' .. dmxValues[3]);
				end
				if GetVar(UserVars(),"ftpSelectionColorType") == 'CMY' then
					Cmd('Attribute "ColorRGB_C" At ' .. tostring(255 - tonumber(dmxValues[1])));
					Cmd('Attribute "ColorRGB_M" At ' .. tostring(255 - tonumber(dmxValues[2])));
					Cmd('Attribute "ColorRGB_Y" At ' .. tostring(255 - tonumber(dmxValues[3])));
				end

			end

			if GetVar(UserVars(),"ftpClickedPreview") ~= 1 then
				Cmd('Store Preset "' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2) .. '".' .. GetVar(UserVars(), 'ftpStorePreset') .. ' /m');
				if GetVar(UserVars(), 'ftpStoreMode') ~= 'merge' then
					Cmd('Label Preset "' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2) .. '".' .. GetVar(UserVars(), 'ftpStorePreset') .. ' "' .. GetVar(UserVars(),"ftpChannelValueName") .. '"')
				end
				Cmd('ClearAll');
			end
			
			fixture_to_presets_find_first_empty_preset('>')
		end
	end

	signalTable.ChangeFixtureClick = function(caller)
		DelVar(UserVars(),"ftpClickedFixture");
		Cmd("Call Plugin " .. pluginName);
	end

	signalTable.ChangeAttributeClick = function(caller)
		DelVar(UserVars(),"ftpFoundAttributeInFixtureError");
		DelVar(UserVars(),"ftpClickedAttribute");
		Cmd("Call Plugin " .. pluginName);
	end

	signalTable.chkPreviewClicked = function(caller)
		if chkPreview.State == 1 then
			chkPreview.State = 0;
			Cmd('ClearAll');
		else
			chkPreview.State = 1;
		end
		SetVar(UserVars(),"ftpClickedPreview", chkPreview.State);
	end

	signalTable.chkMergeClicked = function(caller)
		if chkMerge.State == 1 then
			chkMerge.State = 0;
		else
			chkMerge.State = 1;
		end
		SetVar(UserVars(),"ftpClickedMerge", chkMerge.State);
	end

end

function fixture_to_presets_split(s, delimiter)
	result = {};
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
	end
	return result;
end

function fixture_to_presets_execute()

	fixture_to_presets_store_info()

	fixture_to_presets_select_fixtures(GetVar(UserVars(), 'ftpClickedFixture'), GetVar(UserVars(), 'ftpClickedFixtureMode'));

	Cmd('Attribute "' .. GetVar(UserVars(),"ftpClickedAttribute") .. '" At Absolute Decimal24 ' .. tostring(tonumber(GetVar(UserVars(),"ftpClickedValue")) * 65793) );
	
	if GetVar(UserVars(),"ftpClickedPreview") ~= 1 then
		if tonumber(GetVar(UserVars(), 'ftpStorePreset')) > 0 then
			if GetVar(UserVars(), 'ftpStoreMode') == 'merge' then
				Cmd('Store Preset "' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2) .. '".' .. GetVar(UserVars(), 'ftpStorePreset') .. ' /m');
			else
				Cmd('Store Preset "' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2) .. '".' .. GetVar(UserVars(), 'ftpStorePreset'));
				Cmd('Label Preset "' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2) .. '".' .. GetVar(UserVars(), 'ftpStorePreset') .. ' "' .. GetVar(UserVars(),"ftpChannelValueName") .. '"')
			end
			Cmd('ClearAll');


			fixture_to_presets_find_first_empty_preset(">")

			-- check if an encoder wheel is linked to find images, create appearance, and link them in presets
			local channels = ShowData().Livepatch.FixtureTypes[GetVar(UserVars(),"ftpClickedFixture")].DMXModes[GetVar(UserVars(),"ftpClickedFixtureMode")].DMXChannels:Children();
			
			for channel in ipairs(channels) do
				
				local channelGeometry = channels[channel].Geometry.name;

				foundSubfix = nil;
				if channels[channel].Geometry.Model ~= nil then
					local channelGeometryModel = channels[channel].Geometry.Model.Name;
					findSubfix = "::" .. channelGeometry .. "-" .. channelGeometryModel .. "::"
					foundSubfix = string.find(GetVar(UserVars(),"ftpClickedSubFixtures"), findSubfix, 1, true)
				end

				if (GetVar(UserVars(),"ftpClickedIsSubFixture") == '0' and foundSubfix == nil)
				or (GetVar(UserVars(),"ftpClickedIsSubFixture") == '1' and foundSubfix ~= nil) 
				then
					local channelsInfo = channels[channel]:Children();
					for channelInfo in ipairs(channelsInfo) do
						if channelsInfo[channelInfo].name == GetVar(UserVars(),"ftpClickedAttribute") or (GetVar(UserVars(),"ftpClickedAttribute") == 'Color' and (channelsInfo[channelInfo].name == 'ColorRGB_R' or channelsInfo[channelInfo].name == 'ColorRGB_C')) then
							local channelGroups = channelsInfo[channelInfo]:Children();
							if string.sub(channelsInfo[channelInfo].name, 1, 8) ~= 'ColorRGB' then
								for channelGroup in ipairs(channelGroups) do
									if channelGroups[channelGroup].wheel ~= nil and GetVar(UserVars(),"presetType") == 'Gobo' then
										wheelName = channelGroups[channelGroup].wheel.name;
										wheelIndex = channelValues[channelValue].wheelslotindex;
										appearance = fixtures[fixture].Wheels[wheelName][wheelIndex].appearance;
										-- create appearance
										--Cmd('Delete Appearance "' .. appearance.name .. '" /NoConfirm');
										local newAppearance = ShowData().Appearances:Aquire();
										newAppearance.Name = appearance.name;
										newAppearance.Appearance = ShowData().Mediapools.Gobos[appearance.name];
										-- assign appearance to preset
										Cmd('Set Preset "' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2) .. '".' .. GetVar(UserVars(), 'ftpStorePreset') .. ' Property "Appearance" "' .. appearance.name .. '"');
									end
								end
							end
						end
					end
				end
			end	
		end	
	end
end

function fixture_to_presets_store_info()

	if GetVar(UserVars(),"ftpClickedPreview") ~= 1 then
		
		SetVar(UserVars(), 'ftpStorePreset', '0')
		DelVar(UserVars(), 'ftpStoreMode')

		if GetVar(UserVars(),"ftpClickedMerge") == 1 then

			storePreset = TextInput(': "' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2) .. '" preset number to merge values');
			if storePreset == nil then
				storePreset = 0;
			end
			SetVar(UserVars(), 'ftpStoreMode', 'merge');
			SetVar(UserVars(), 'ftpStorePreset', storePreset);

		else

			--check if a preset exists, having the same name
			local presetTypes = ShowData().DataPools.Default.PresetPools:Children();
			--loop preset types (gobo, color, beam,..)
			for presetType in ipairs(presetTypes) do
				if presetTypes[presetType].name == string.sub(GetVar(UserVars(),"ftpPresetType"), 2) then
					presets = presetTypes[presetType]:Children();
					for preset in ipairs(presets) do
						if presets[preset].name == GetVar(UserVars(),"ftpChannelValueName") then
							if GetVar(UserVars(),"ftpForceMerge") == false then
								local options = {
									title="Fixture to Preset",   --string:
									message='A preset "' .. GetVar(UserVars(),"ftpChannelValueName") .. '" already exists in the ' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2) .. ' presets' ,  --string
									display= nil,               --int | handle?
									commands={
										{value=tonumber(presets[preset].no), name="Merge Values"},
										{value=0, name="Create new preset"}
									}
								}
								local r = MessageBox(options);
								local result = tonumber(r['result']);
								if result > 0 then
									SetVar(UserVars(), 'ftpStoreMode', 'merge');
									SetVar(UserVars(), 'ftpStorePreset', result);
								end
								if result == -1 then
									SetVar(UserVars(), 'ftpStorePreset', '-1');
								end
							else
								SetVar(UserVars(), 'ftpStoreMode', 'merge');
								SetVar(UserVars(), 'ftpStorePreset', tonumber(presets[preset].no));
							end
						end
					end
				end
			end

			--find first empty preset
			if GetVar(UserVars(), 'ftpStorePreset') == '0' then
				SetVar(UserVars(), 'ftpStorePreset', GetVar(UserVars(), 'ftpPresetNumber' .. string.sub(GetVar(UserVars(),"ftpPresetType"), 2)))
			end

		end
	end
end

function fixture_to_presets_get_preset_type(attribute)
	SetVar(UserVars(),"ftpPresetType", nil);
	if attribute == 'Color' then
		SetVar(UserVars(),"ftpPresetType", "4Color");
	end
	if GetVar(UserVars(),"ftpPresetType") == nil then
		local attributes = ShowData().LivePatch.AttributeDefinitions.Attributes[attribute];
		local featureGroups = ShowData().LivePatch.AttributeDefinitions.FeatureGroups:Children();
		for featureGroup in ipairs(featureGroups) do
			features = featureGroups[featureGroup]:Children()
			for feature in ipairs(features) do
				if attributes.feature.name == features[feature].name then
					SetVar(UserVars(),"ftpPresetType", featureGroups[featureGroup].no .. featureGroups[featureGroup].name);
				end
			end
		end
	end
end

function fixture_to_presets_get_color_type(channels)
	SetVar(UserVars(),"ftpSelectionColorType", '');
	SetVar(UserVars(),"ftpSelectionColorCreated", '');
	SetVar(UserVars(),"ftpSelectionColorAssigned", '-');
	for channel in ipairs(channels) do
		local channelsInfo = channels[channel]:Children();
		for channelInfo in ipairs(channelsInfo) do
			local channelInfoName = channelsInfo[channelInfo].name;
			if channelInfoName == 'ColorRGB_R' or channelInfoName == 'ColorRGB_G' or channelInfoName == 'ColorRGB_B' then
				SetVar(UserVars(),"ftpSelectionColorType", 'RGB');
			end
			if channelInfoName == 'ColorRGB_C' or channelInfoName == 'ColorRGB_M' or channelInfoName == 'ColorRGB_Y' then
				SetVar(UserVars(),"ftpSelectionColorType", 'CMY');
			end
			if channelInfoName == 'ColorRGB_RY' or channelInfoName == 'ColorRGB_GY' or channelInfoName == 'ColorRGB_BM' or channelInfoName == 'ColorRGB_RM' or channelInfoName == 'ColorRGB_W' or channelInfoName == 'ColorRGB_WW' or channelInfoName == 'ColorRGB_CW' or channelInfoName == 'ColorRGB_UV' then
				SetVar(UserVars(),"ftpSelectionColorAssigned", GetVar(UserVars(), 'ftpSelectionColorAssigned') .. channelInfoName .. '-');
			end
		end
	end
end

function fixture_to_presets_setColorsToZero()
	if GetVar(UserVars(),"ftpSelectionColorType") == 'RGB' then
		Cmd('Attribute "ColorRGB_R" At 0');
		Cmd('Attribute "ColorRGB_G" At 0');
		Cmd('Attribute "ColorRGB_B" At 0');
	end
	if GetVar(UserVars(),"ftpSelectionColorType") == 'CMY' then
		Cmd('Attribute "ColorRGB_C" At 0');
		Cmd('Attribute "ColorRGB_M" At 0');
		Cmd('Attribute "ColorRGB_Y" At 0');
	end
	SetVar(UserVars(),"ftpIsColorAssigned", true);
end

function fixture_to_presets_select_fixtures(fixtureName, modeName)

	Printf('-- select fixtures --')
	Printf(fixtureName);
	Printf(modeName);

	Cmd('ClearAll');

	local stages = ShowData().Livepatch.Stages:Children();
	for stage in ipairs(stages) do
		fixtures = stages[stage].Fixtures:Children();
		for fixture in ipairs(fixtures) do
			linkedfixtures = fixtures[fixture]:Children();
			
			if #linkedfixtures == 0 then
				if fixtureName == fixtures[fixture].fixturetype.name and modeName == fixtures[fixture].modedirect.name then
					fixture_to_presets_select_fixtures_check(fixtureName, modeName, fixtures[fixture].no);
				end
			else
				for linkedfixture in ipairs(linkedfixtures) do
					if fixtureName == linkedfixtures[linkedfixture].fixturetype.name and modeName == linkedfixtures[linkedfixture].modedirect.name then
						fixture_to_presets_select_fixtures_check(fixtureName, modeName, linkedfixtures[linkedfixture].no);
					end
				end
			end

		end
	end
end

function fixture_to_presets_select_fixtures_check(fixtureName, modeName, fixtureNo)

	-- check if fixture is the main fixture, or a subfixture
	if GetVar(UserVars(),"ftpClickedIsSubFixture") ~= "1" then
		Cmd('Fixture ' .. fixtureNo)
	else
		local geometryName = ShowData().Livepatch.FixtureTypes[fixtureName].DMXModes[modeName].geometry;
		local g11 = ShowData().Livepatch.FixtureTypes[fixtureName].Geometries[geometryName]:Children();
		for g1 in ipairs(g11) do
			--Printf(g11[g1].name)
			g22 = g11[g1]:Children()
			for g2 in ipairs(g22) do
				--Printf(g22[g2].name)
				g33 = g22[g2]:Children()
				for g3 in ipairs(g33) do
					--Printf(g33[g3].name)
					references = g33[g3]:Children()
					for reference in ipairs(references) do
						if references[reference].geometry ~= nil then
							Cmd('Fixture ' .. fixtureNo .. '.' .. references[reference].no)
						end
					end
				end
			end
		end
	end
end

function fixture_to_presets_get_subfixtures(fixtureName, geometryName)

	local subFixtures = {"Main"}
	local g11 = ShowData().Livepatch.FixtureTypes[fixtureName].Geometries[geometryName]:Children();
	for g1 in ipairs(g11) do
		--Printf(g11[g1].name)
		g22 = g11[g1]:Children()
		for g2 in ipairs(g22) do
			--Printf(g22[g2].name)
			g33 = g22[g2]:Children()
			for g3 in ipairs(g33) do
				--Printf(g33[g3].name)
				references = g33[g3]:Children()
				for reference in ipairs(references) do
					if references[reference].geometry ~= nil then
						--if type(references[reference].geometry) == "string" then 
							subFixture = references[reference].geometry;
							table.insert(subFixtures, subFixture)
						--end
					end
				end
			end
		end
	end

	return fixture_to_presets_array_unique(subFixtures);
end

function fixture_to_presets_array_unique(array)
	local hash = {}
	local res = {}
	for _,v in ipairs(array) do
	   if (not hash[v]) then
	       res[#res+1] = v -- you could print here instead of saving to result table if you wanted
	       hash[v] = true
	   end
	end
	return res;
end

function fixture_to_presets_find_first_empty_preset(direction)
	presetType = string.sub(GetVar(UserVars(),"ftpPresetType"), 2)
	presetVarName = "ftpPresetNumber" .. presetType
	presets = ShowData().DataPools.Default.PresetPools[presetType]:Children()
	-- define the startposition
	presetStep = '1'
	-- check if presets exist
	if #presets == 0 then
		DelVar(UserVars(), presetVarName)
	end
	if GetVar(UserVars(), presetVarName) ~= nil then
		presetStep = GetVar(UserVars(), presetVarName)
	end
	if GetVar(UserVars(), "ftpPresetSetNo") ~= nil and tonumber(GetVar(UserVars(), "ftpPresetSetNo")) > 0 then
		presetStep = GetVar(UserVars(), "ftpPresetSetNo")
		DelVar(UserVars(), "ftpPresetSetNo")
	end	
	presetStep = tonumber(presetStep)
	-- check for first empty step from the startposition
	emptyPresetFound = '0'
	while(emptyPresetFound == '0') do
		presetFound = '0'
		for preset in ipairs(presets) do
			if tostring(presets[preset].no) == tostring(presetStep) then
				presetFound = '1'
			end
		end
		if presetFound == '1' then
			if direction == '>' then
				presetStep = presetStep + 1;
			end
			if direction == '<' then
				presetStep = presetStep - 1;
				if presetStep < 1 then
					direction = '>'
					presetStep = 1
				end
			end
		else
			emptyPresetFound = '1'
		end
	end

	SetVar(UserVars(), presetVarName, presetStep)
	btnDMX.Text = presetStep
end
		
return fixture_to_presets;
