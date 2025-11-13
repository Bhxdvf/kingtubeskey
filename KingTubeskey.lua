local REQUIRED_KEY="KingTubes"
local CoreGui=game:GetService("CoreGui")
local keyUI=Instance.new("ScreenGui")
keyUI.Name="Flow_KeyCheck"
keyUI.Parent=CoreGui
local frame=Instance.new("Frame",keyUI)
frame.Size=UDim2.new(0,280,0,155)
frame.Position=UDim2.new(0.5,-140,0.5,-80)
frame.BackgroundColor3=Color3.fromRGB(20,0,25)
frame.BorderSizePixel=0
local top=Instance.new("TextLabel",frame)
top.Size=UDim2.new(1,0,0,45)
top.BackgroundColor3=Color3.fromRGB(45,0,55)
top.TextColor3=Color3.new(1,1,1)
top.Font=Enum.Font.SourceSansBold
top.TextSize=26
top.Text="FLOW ACCESS"
local box=Instance.new("TextBox",frame)
box.Size=UDim2.new(1,-20,0,40)
box.Position=UDim2.new(0,10,0,55)
box.BackgroundColor3=Color3.fromRGB(30,0,40)
box.TextColor3=Color3.new(1,1,1)
box.PlaceholderText="Enter Key..."
box.Font=Enum.Font.SourceSansBold
box.TextSize=20
local btn=Instance.new("TextButton",frame)
btn.Size=UDim2.new(1,-20,0,38)
btn.Position=UDim2.new(0,10,0,100)
btn.BackgroundColor3=Color3.fromRGB(70,0,100)
btn.TextColor3=Color3.new(1,1,1)
btn.Text="UNLOCK"
btn.Font=Enum.Font.SourceSansBold
btn.TextSize=20
local unlocked=false
btn.MouseButton1Click:Connect(function()
if box.Text==REQUIRED_KEY then
unlocked=true
keyUI:Destroy()
else
keyUI:Destroy()
end
end)
repeat task.wait() until unlocked
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local TS=game:GetService("TweenService")
local CoreGui=game:GetService("CoreGui")
local plr=Players.LocalPlayer
local cam=workspace.CurrentCamera
local freecamEnabled=false
local noclipEnabled=false
local flyEnabled=false
local invisEnabled=false
local tpEnabled=false
local godEnabled=false
local regenEnabled=false
local guiVisible=true
local moveSpeed=2
local keysDown={}
local camRot=Vector2.new()
local bodyVelocity=nil
local bodyGyro=nil
local tpMarker=nil
local lastTP=nil
local healthConn=nil
local regenConn=nil
local noclipConn=nil
local slideKey=Enum.KeyCode.C
local slideActive=false
local lastMouseDelta=Vector2.new()
local slideSensitivity=0.15
local maxSlideForce=40
local screenGui=Instance.new("ScreenGui")
screenGui.IgnoreGuiInset=true
screenGui.ResetOnSpawn=false
screenGui.Parent=CoreGui
local fadeFrame=Instance.new("Frame",screenGui)
fadeFrame.Size=UDim2.new(1,0,1,0)
fadeFrame.BackgroundColor3=Color3.new(0,0,0)
fadeFrame.BackgroundTransparency=1
fadeFrame.ZIndex=10
local function fadeInOut(cb)
TS:Create(fadeFrame,TweenInfo.new(0.25),{BackgroundTransparency=0}):Play()
task.wait(0.25)
if cb then cb() end
TS:Create(fadeFrame,TweenInfo.new(0.25),{BackgroundTransparency=1}):Play()
end
local PURPLE_DARK_1=Color3.fromRGB(30,0,45)
local PURPLE_DARK_2=Color3.fromRGB(45,0,70)
local PURPLE_DARK_3=Color3.fromRGB(68,0,98)
local PURPLE_DARK_4=Color3.fromRGB(90,0,130)
local TELEPORT_MAX_DIST=1200
local DROP_HEIGHT=3000
local DROP_STEPS=10
local frame=Instance.new("Frame",screenGui)
frame.Size=UDim2.new(0,410,0,330)
frame.Position=UDim2.new(0.3,0,0.2,0)
frame.BackgroundColor3=PURPLE_DARK_1
frame.Active=true
frame.Draggable=true
local banner=Instance.new("TextLabel",frame)
banner.Size=UDim2.new(1,0,0,35)
banner.Position=UDim2.new(0,0,0,0)
banner.BackgroundColor3=PURPLE_DARK_2
banner.Text="Made by Tubes"
banner.TextColor3=Color3.fromRGB(255,255,255)
banner.Font=Enum.Font.SourceSansBold
banner.TextSize=24
local tabFrame=Instance.new("Frame",frame)
tabFrame.Size=UDim2.new(1,0,0,30)
tabFrame.Position=UDim2.new(0,0,0,35)
tabFrame.BackgroundColor3=PURPLE_DARK_2
local contentFrame=Instance.new("Frame",frame)
contentFrame.Size=UDim2.new(1,0,1,-65)
contentFrame.Position=UDim2.new(0,0,0,65)
contentFrame.BackgroundColor3=PURPLE_DARK_1
local function makeTab(name,x)
local b=Instance.new("TextButton",tabFrame)
b.Size=UDim2.new(0,100,1,0)
b.Position=UDim2.new(0,x,0,0)
b.Text=name
b.BackgroundColor3=PURPLE_DARK_3
b.TextColor3=Color3.fromRGB(255,255,255)
b.Font=Enum.Font.SourceSansBold
b.TextSize=20
return b
end
local movementTab=makeTab("Movement",5)
local otherTab=makeTab("Other",110)
local teleportTab=makeTab("Teleport",215)
local pages={}
local function makePage(name)
local p=Instance.new("Frame",contentFrame)
p.Size=UDim2.new(1,0,1,0)
p.BackgroundTransparency=1
p.Visible=false
pages[name]=p
return p
end
local function switchPage(name)
for n,p in pairs(pages)do
p.Visible=(n==name)
end
end
local function makeButton(parent,name,y)
local b=Instance.new("TextButton",parent)
b.Size=UDim2.new(0,200,0,40)
b.Position=UDim2.new(0.5,-100,0,y)
b.Text=name
b.BackgroundColor3=PURPLE_DARK_4
b.TextColor3=Color3.fromRGB(255,255,255)
b.Font=Enum.Font.SourceSansBold
b.TextSize=22
return b
end
local movePage=makePage("Movement")
local otherPage=makePage("Other")
local tpPage=makePage("Teleport")
local freecamBtn=makeButton(movePage,"Freecam",10)
local noclipBtn=makeButton(movePage,"Noclip",60)
local flyBtn=makeButton(movePage,"Fly",110)
local teleportBtn=makeButton(movePage,"Teleport Tool",160)
local invisBtn=makeButton(otherPage,"Invisibility",10)
local godBtn=makeButton(otherPage,"God Mode",60)
local regenBtn=makeButton(otherPage,"Regen Mode",110)
local tpFrame=Instance.new("ScrollingFrame",tpPage)
tpFrame.Size=UDim2.new(0,350,0,220)
tpFrame.Position=UDim2.new(0.5,-175,0,20)
tpFrame.CanvasSize=UDim2.new(0,0,0,0)
tpFrame.ScrollBarThickness=6
tpFrame.BackgroundColor3=PURPLE_DARK_2
movementTab.MouseButton1Click:Connect(function()switchPage("Movement")end)
otherTab.MouseButton1Click:Connect(function()switchPage("Other")end)
teleportTab.MouseButton1Click:Connect(function()switchPage("Teleport")end)
switchPage("Movement")
local function character()
return plr.Character or plr.CharacterAdded:Wait()
end
freecamBtn.MouseButton1Click:Connect(function()
freecamEnabled=not freecamEnabled
local char=character()
if freecamEnabled then
cam.CameraType=Enum.CameraType.Scriptable
cam.CFrame=(char:FindFirstChild("Head")and char.Head.CFrame)or cam.CFrame
local hrp=char:FindFirstChild("HumanoidRootPart")
if hrp then hrp.Anchored=true end
UIS.MouseBehavior=Enum.MouseBehavior.LockCurrentPosition
UIS.MouseIconEnabled=false
freecamBtn.Text="Freecam ON"
else
cam.CameraType=Enum.CameraType.Custom
cam.CameraSubject=char:FindFirstChildWhichIsA("Humanoid")
local hrp=char:FindFirstChild("HumanoidRootPart")
if hrp then hrp.Anchored=false end
UIS.MouseBehavior=Enum.MouseBehavior.Default
UIS.MouseIconEnabled=true
freecamBtn.Text="Freecam"
end
end)
UIS.InputChanged:Connect(function(input)
if freecamEnabled and input.UserInputType==Enum.UserInputType.MouseMovement then
camRot=camRot+Vector2.new(-input.Delta.y,-input.Delta.x)*0.2
end
end)
local function startNoclip()
if noclipConn then noclipConn:Disconnect() end
noclipConn=RS.Stepped:Connect(function()
local c=plr.Character
if c then
for _,part in ipairs(c:GetDescendants())do
if part:IsA("BasePart")then
part.CanCollide=false
end
end
end
end)
end

local function stopNoclip()
if noclipConn then noclipConn:Disconnect() end
noclipConn=nil
local c=plr.Character
if c then
for _,part in ipairs(c:GetDescendants())do
if part:IsA("BasePart")then
part.CanCollide=true
end
end
end
end

noclipBtn.MouseButton1Click:Connect(function()
noclipEnabled=not noclipEnabled
noclipBtn.Text=noclipEnabled and "Noclip ON" or "Noclip"
if noclipEnabled then startNoclip() else stopNoclip() end
end)
UIS.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement then
lastMouseDelta=input.Delta
end
end)

UIS.InputBegan:Connect(function(input)
if input.KeyCode==slideKey then
slideActive=true
end
keysDown[input.KeyCode]=true
end)

UIS.InputEnded:Connect(function(input)
if input.KeyCode==slideKey then
slideActive=false
end
keysDown[input.KeyCode]=nil
end)
local function setInvisibleLocal(state)
local c=plr.Character
if not c then return end
for _,d in ipairs(c:GetDescendants())do
if d:IsA("BasePart")then
d.LocalTransparencyModifier=state and 1 or 0
d.CanCollide=not state
elseif d:IsA("Decal")or d:IsA("Texture")then
d.Transparency=state and 1 or 0
elseif d:IsA("Accessory")then
local h=d:FindFirstChild("Handle")
if h then
h.LocalTransparencyModifier=state and 1 or 0
h.CanCollide=not state
end
end
end
end

invisBtn.MouseButton1Click:Connect(function()
invisEnabled=not invisEnabled
setInvisibleLocal(invisEnabled)
invisBtn.Text=invisEnabled and "Invis ON" or "Invis"
end)
local function enableGod(hum)
if healthConn then healthConn:Disconnect() end
healthConn=hum.HealthChanged:Connect(function()
if godEnabled then hum.Health=hum.MaxHealth end
end)
hum.TakeDamage=function()end
hum.Health=hum.MaxHealth
end

local function disableGod()
if healthConn then healthConn:Disconnect() end
healthConn=nil
end

godBtn.MouseButton1Click:Connect(function()
godEnabled=not godEnabled
godBtn.Text=godEnabled and "God Mode ON" or "God Mode"
local c=plr.Character
if c then
local hum=c:FindFirstChildOfClass("Humanoid")
if hum then
if godEnabled then enableGod(hum) else disableGod() end
end
end
end)

local function enableRegen(hum)
if regenConn then regenConn:Disconnect() end
regenConn=hum.HealthChanged:Connect(function(v)
if regenEnabled and v<hum.MaxHealth then
task.delay(0.1,function()
if regenEnabled and hum then hum.Health=hum.MaxHealth end
end)
end
end)
end

local function disableRegen()
if regenConn then regenConn:Disconnect() end
regenConn=nil
end

regenBtn.MouseButton1Click:Connect(function()
regenEnabled=not regenEnabled
regenBtn.Text=regenEnabled and "Regen Mode ON" or "Regen Mode"
local c=plr.Character
if c then
local hum=c:FindFirstChildOfClass("Humanoid")
if hum then
if regenEnabled then enableRegen(hum) else disableRegen() end
end
end
end)
local function buildRayParams()
local p=RaycastParams.new()
local ignore={plr.Character}
if tpMarker then table.insert(ignore,tpMarker) end
p.FilterDescendantsInstances=ignore
p.FilterType=Enum.RaycastFilterType.Blacklist
return p
end

local function resolveGroundFromView()
local origin=cam.CFrame.Position
local dir=cam.CFrame.LookVector*TELEPORT_MAX_DIST
local params=buildRayParams()
local hit=workspace:Raycast(origin,dir,params)
if hit then return hit.Position end
local farEnd=origin+dir
local fromAbove=farEnd+Vector3.new(0,DROP_HEIGHT,0)
local drop1=workspace:Raycast(fromAbove,Vector3.new(0,-DROP_HEIGHT*2,0),params)
if drop1 then return drop1.Position end
for i=1,DROP_STEPS do
local t=i/DROP_STEPS
local stepPoint=origin+dir*t
local probeStart=stepPoint+Vector3.new(0,DROP_HEIGHT,0)
local d=workspace:Raycast(probeStart,Vector3.new(0,-DROP_HEIGHT*2,0),params)
if d then return d.Position end
end
local camAbove=origin+Vector3.new(0,DROP_HEIGHT,0)
local camDrop=workspace:Raycast(camAbove,Vector3.new(0,-DROP_HEIGHT*2,0),params)
if camDrop then return camDrop.Position end
return lastTP
end

teleportBtn.MouseButton1Click:Connect(function()
tpEnabled=not tpEnabled
teleportBtn.Text=tpEnabled and "Teleport ON" or "Teleport Tool"
if tpEnabled then
if not tpMarker then
tpMarker=Instance.new("Part")
tpMarker.Size=Vector3.new(2,0.5,2)
tpMarker.Anchored=true
tpMarker.Color=Color3.fromRGB(200,0,255)
tpMarker.Material=Enum.Material.Neon
tpMarker.CanCollide=false
tpMarker.Transparency=0.3
tpMarker.Parent=workspace
end
else
if tpMarker then tpMarker:Destroy() end
tpMarker=nil
lastTP=nil
end
end)

UIS.InputBegan:Connect(function(input,processed)
if tpEnabled and freecamEnabled and input.UserInputType==Enum.UserInputType.MouseButton2 then
local pos=resolveGroundFromView()
if pos then
local hrp=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
if hrp then
fadeInOut(function()
hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,0))
end)
end
end
end
end)

RS.RenderStepped:Connect(function()
if tpEnabled and freecamEnabled and tpMarker then
local p=resolveGroundFromView()
if p then
tpMarker.CFrame=CFrame.new(p+Vector3.new(0,0.25,0))
lastTP=p
end
end
end)
RS.RenderStepped:Connect(function(dt)
if freecamEnabled then
local cf=cam.CFrame
local mv=Vector3.zero
if keysDown[Enum.KeyCode.W] then mv+=cf.LookVector end
if keysDown[Enum.KeyCode.S] then mv-=cf.LookVector end
if keysDown[Enum.KeyCode.A] then mv-=cf.RightVector end
if keysDown[Enum.KeyCode.D] then mv+=cf.RightVector end
if keysDown[Enum.KeyCode.E] then mv+=cf.UpVector end
if keysDown[Enum.KeyCode.Q] then mv-=cf.UpVector end
local sp=moveSpeed
if keysDown[Enum.KeyCode.LeftShift] then sp*=6 end
if keysDown[Enum.KeyCode.LeftControl] then sp*=0.3 end
if mv.Magnitude>0 then cf=cf+mv.Unit*sp*dt*60 end
local rx=CFrame.Angles(0,math.rad(camRot.Y),0)
local ry=CFrame.Angles(math.rad(camRot.X),0,0)
cam.CFrame=rx*ry+cf.Position
end

if flyEnabled and bodyVelocity and bodyGyro and plr.Character then
local cf=cam.CFrame
local mv=Vector3.zero
if keysDown[Enum.KeyCode.W] then mv+=cf.LookVector end
if keysDown[Enum.KeyCode.S] then mv-=cf.LookVector end
if keysDown[Enum.KeyCode.A] then mv-=cf.RightVector end
if keysDown[Enum.KeyCode.D] then mv+=cf.RightVector end
if keysDown[Enum.KeyCode.Space] then mv+=Vector3.yAxis end
if keysDown[Enum.KeyCode.LeftControl] then mv-=Vector3.yAxis end
local sp=moveSpeed*30
if keysDown[Enum.KeyCode.LeftShift] then sp*=60 end
if slideActive then
local side=-lastMouseDelta.X
side=math.clamp(side,-maxSlideForce,maxSlideForce)
if math.abs(side)>0.1 then mv+=cf.RightVector*(side*slideSensitivity) end
end
if mv.Magnitude>0 then
bodyVelocity.Velocity=mv.Unit*sp
else
bodyVelocity.Velocity=Vector3.zero
end
bodyGyro.CFrame=cf
end
end)
UIS.InputBegan:Connect(function(input,processed)
if not processed then
keysDown[input.KeyCode]=true
if input.KeyCode==Enum.KeyCode.RightControl then
guiVisible=not guiVisible
frame.Visible=guiVisible
end
end
end)
local flyEnabled = false
local flySpeed = 50
local flyUpdateCooldown = 0

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local plr = game:GetService("Players").LocalPlayer
local cam = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local bodyVelocity = nil
local bodyGyro = nil

local flyPopup = Instance.new("Frame")
flyPopup.Size = UDim2.new(0, 260, 0, 150)
flyPopup.Position = UDim2.new(0.5, -130, 0.5, -75)
flyPopup.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
flyPopup.BorderSizePixel = 0
flyPopup.Visible = false
flyPopup.Active = true
flyPopup.Draggable = true
flyPopup.Parent = CoreGui

local title = Instance.new("TextLabel", flyPopup)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
title.Text = "Fly Speed"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)

local sliderBack = Instance.new("Frame", flyPopup)
sliderBack.Size = UDim2.new(1, -30, 0, 10)
sliderBack.Position = UDim2.new(0, 15, 0, 60)
sliderBack.BackgroundColor3 = Color3.fromRGB(20, 0, 30)

local sliderFill = Instance.new("Frame", sliderBack)
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(200, 0, 255)

local doneBtn = Instance.new("TextButton", flyPopup)
doneBtn.Size = UDim2.new(0, 120, 0, 40)
doneBtn.Position = UDim2.new(0.5, -60, 1, -50)
doneBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
doneBtn.Text = "Done"
doneBtn.TextColor3 = Color3.new(1, 1, 1)
doneBtn.Font = Enum.Font.SourceSansBold
doneBtn.TextSize = 20

local sliding = false

sliderBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		sliding = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		sliding = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
		local rel = (input.Position.X - sliderBack.AbsolutePosition.X)
		local scale = math.clamp(rel / sliderBack.AbsoluteSize.X, 0, 1)

		sliderFill.Size = UDim2.new(scale, 0, 1, 0)
		flySpeed = math.floor(scale * 300)
		flyUpdateCooldown = tick() + 1
	end
end)

doneBtn.MouseButton1Click:Connect(function()
	flyPopup.Visible = false
end)

function ConnectFlyRightClick(button)
	button.MouseButton2Click:Connect(function()
		flyPopup.Visible = not flyPopup.Visible
	end)
end

function ToggleFly()
	flyEnabled = not flyEnabled

	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")

	if flyEnabled then
		if hum then hum.PlatformStand = true end

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.Parent = hrp

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
		bodyGyro.CFrame = cam.CFrame
		bodyGyro.Parent = hrp
	else
		if hum then hum.PlatformStand = false end
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	end
end

RS.RenderStepped:Connect(function()
	if not flyEnabled then return end
	if not bodyVelocity or not bodyGyro then return end

	local cf = cam.CFrame
	local mv = Vector3.zero

	local keys = UIS:GetKeysPressed()

	for _, key in ipairs(keys) do
		if key.KeyCode == Enum.KeyCode.W then mv += cf.LookVector end
		if key.KeyCode == Enum.KeyCode.S then mv -= cf.LookVector end
		if key.KeyCode == Enum.KeyCode.A then mv -= cf.RightVector end
		if key.KeyCode == Enum.KeyCode.D then mv += cf.RightVector end
		if key.KeyCode == Enum.KeyCode.Space then mv += Vector3.yAxis end
		if key.KeyCode == Enum.KeyCode.LeftControl then mv -= Vector3.yAxis end
	end

	if mv.Magnitude > 0 then
		bodyVelocity.Velocity = mv.Unit * flySpeed
	else
		bodyVelocity.Velocity = Vector3.zero
	end

	bodyGyro.CFrame = cf
end)
