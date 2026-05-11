--!strict
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))();

local Workspace: Workspace = game:GetService("Workspace");
local Players: Players = game:GetService("Players");
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer: Player = Players.LocalPlayer;

type CharacterController = {
    Player: Player,
    TeleportToCFrame: (self: CharacterController, TargetCFrame: CFrame) -> boolean,
    TeleportToPart: (self: CharacterController, TargetPart: BasePart) -> boolean,
    PerformRefuel: (self: CharacterController) -> boolean
};

local CharacterController = {};
CharacterController.__index = CharacterController;

function CharacterController.new(TargetPlayer: Player): CharacterController
    local self = setmetatable({}, CharacterController);
    self.Player = TargetPlayer;
    return self;
end

function CharacterController:TeleportToCFrame(TargetCFrame: CFrame): boolean
    local Success: boolean = pcall(function()
        local Character: Model? = self.Player.Character;
        if (not Character) then return; end
        local RootPart: BasePart? = Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso");
        if (RootPart) then 
            RootPart.CFrame = TargetCFrame + Vector3.new(0, 3, 0); 
        end
    end);
    return Success;
end

function CharacterController:TeleportToPart(TargetPart: BasePart): boolean
    return self:TeleportToCFrame(TargetPart.CFrame);
end

function CharacterController:PerformRefuel(): boolean
    local Success: boolean = pcall(function()
        local Plane = Workspace:FindFirstChild("Plane");
        if (not Plane) then return; end
        
        local GasCan = Plane:FindFirstChild("GrabGasCan") and Plane.GrabGasCan:FindFirstChild("GrabGasCan");
        if (GasCan) then
            self:TeleportToPart(GasCan);
            task.wait(0.1);
            local Prompt = GasCan:FindFirstChild("GrabCan");
            if (Prompt) then fireproximityprompt(Prompt); end
        end
        
        local TempPart: Part = Instance.new("Part");
        TempPart.CanCollide = false;
        TempPart.Transparency = 1;
        TempPart.Anchored = true;
        TempPart.CFrame = CFrame.new(0.628192008, 18.8988991, -86.9489975);
        TempPart.Parent = Workspace;
        
        self:TeleportToPart(TempPart);
        task.wait(0.2);
        TempPart:Destroy();
        
        local Generator = Plane:FindFirstChild("Machines") and Plane.Machines:FindFirstChild("Generator");
        local DumpFuel = Generator and Generator:FindFirstChild("DumpFuel");
        local FuelUpPrompt = DumpFuel and DumpFuel:FindFirstChild("FuelUp");
        if (FuelUpPrompt) then fireproximityprompt(FuelUpPrompt); end
    end);
    return Success;
end

type UiManager = {
    Window: any,
    Notify: (self: UiManager, Title: string, Text: string) -> nil
};

local UiManager = {};
UiManager.__index = UiManager;

function UiManager.new(Title: string, Version: string): UiManager
    local self = setmetatable({}, UiManager);
    self.Window = OrionLib:MakeWindow({
        Name = Title .. " " .. Version, 
        HidePremium = true, 
        SaveConfig = false, 
        ConfigFolder = "rustware"
    });
    return self;
end

function UiManager:Notify(Title: string, Text: string): nil
    OrionLib:MakeNotification({
        Name = Title,
        Content = Text,
        Image = "rbxassetid://4483345998",
        Time = 3
    });
    return nil;
end

local CharController: CharacterController = CharacterController.new(LocalPlayer);
local Interface: UiManager = UiManager.new("rustware", "v7.0");

local MainTab: any = Interface.Window:MakeTab({ Name = "Main", Icon = "rbxassetid://7733960981", PremiumOnly = false });
local TeleportsTab: any = Interface.Window:MakeTab({ Name = "Teleports", Icon = "rbxassetid://7733992789", PremiumOnly = false });
local ClassesTab: any = Interface.Window:MakeTab({ Name = "Classes", Icon = "rbxassetid://7743876054", PremiumOnly = false });
local MiscTab: any = Interface.Window:MakeTab({ Name = "Misc", Icon = "rbxassetid://8997386997", PremiumOnly = false });

local SpamOxygenEnabled: boolean = false;
MainTab:AddToggle({
    Name = "spam oxygen",
    Default = false,
    Callback = function(Value: boolean)
        SpamOxygenEnabled = Value;
        if (Value) then 
            task.spawn(function()
                local AirEvent: RemoteEvent? = Workspace:FindFirstChild("Values") and Workspace.Values:FindFirstChild("RepumpAirEvent");
                if (not AirEvent) then 
                    Interface:Notify("Error", "event not found"); 
                    SpamOxygenEnabled = false; 
                    return; 
                end
                while (SpamOxygenEnabled) do 
                    pcall(function() AirEvent:FireServer(); end); 
                    task.wait(0.01); 
                end
            end); 
        end
    end
});

local SpamTempEnabled: boolean = false;
MainTab:AddToggle({
    Name = "keep temp stable (22C)",
    Default = false,
    Callback = function(Value: boolean)
        SpamTempEnabled = Value;
        if (Value) then 
            task.spawn(function()
                local TempEvent: RemoteEvent? = ReplicatedStorage:FindFirstChild("ACTempChange");
                if (not TempEvent) then 
                    Interface:Notify("Error", "event not found"); 
                    SpamTempEnabled = false; 
                    return; 
                end
                while (SpamTempEnabled) do 
                    pcall(function()
                        local Plane = Workspace:FindFirstChild("Plane");
                        if (not Plane) then return; end
                        local Label: TextLabel? = Plane:FindFirstChild("Machines") and Plane.Machines:FindFirstChild("AirConditionner") and Plane.Machines.AirConditionner:FindFirstChild("Screen") and Plane.Machines.AirConditionner.Screen:FindFirstChild("SurfaceGui") and Plane.Machines.AirConditionner.Screen.SurfaceGui:FindFirstChild("Frame") and Plane.Machines.AirConditionner.Screen.SurfaceGui.Frame:FindFirstChild("TemperatureLabel");
                        if (not Label) then return; end
                        local CurrentTemp: number? = tonumber(Label.Text:match("%d+"));
                        if (not CurrentTemp) then return; end
                        if (CurrentTemp < 22) then 
                            TempEvent:FireServer(true); 
                        elseif (CurrentTemp > 22) then 
                            TempEvent:FireServer(false); 
                        end
                    end); 
                    task.wait(0.1); 
                end
            end); 
        end
    end
});

local AutoBirdEnabled: boolean = false;
local BirdConnection: RBXScriptConnection? = nil;
MainTab:AddToggle({
    Name = "auto birdstrike fix (fast)",
    Default = false,
    Callback = function(Value: boolean)
        AutoBirdEnabled = Value;
        if (BirdConnection) then 
            BirdConnection:Disconnect(); 
            BirdConnection = nil; 
        end
        if (Value) then
            local Success: boolean, ErrorMessage: string? = pcall(function()
                local Plane = Workspace:FindFirstChild("Plane");
                local ConditionFrame: Frame = Plane.Machines.EngineConditionMachine.Screen2.SurfaceGui.Frame;
                local RightBtnDetector: ClickDetector = Plane.Machines.CenterConsole.RightButton.ClickDetector;
                local LeftBtnDetector: ClickDetector = Plane.Machines.CenterConsole.LeftButton.ClickDetector;
                
                BirdConnection = ConditionFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                    if (not AutoBirdEnabled) then return; end
                    if (ConditionFrame.Visible) then
                        fireclickdetector(RightBtnDetector); 
                        task.wait(0.05); 
                        fireclickdetector(LeftBtnDetector);
                        Interface:Notify("birdstrike", "engines off");
                    end
                end);
            end);
            if (not Success and ErrorMessage) then Interface:Notify("Error", "birdstrike UI missing (Lobby?)"); end
        end
    end
});

local AutoSteerEnabled: boolean = false;
local SteerConnection: RBXScriptConnection? = nil;
MainTab:AddToggle({
    Name = "auto steer (dodge missiles)",
    Default = false,
    Callback = function(Value: boolean)
        AutoSteerEnabled = Value;
        if (SteerConnection) then 
            SteerConnection:Disconnect(); 
            SteerConnection = nil; 
        end
        if (Value) then
            pcall(function()
                local Plane = Workspace:FindFirstChild("Plane");
                local DirectionText: TextLabel = Plane.Machines.MissileDodgerMachine.Screen.SurfaceGui.Frame.Direction;
                local DodgeEvent: RemoteEvent = ReplicatedStorage.SteeringWheelDodge;
                SteerConnection = DirectionText:GetPropertyChangedSignal("Text"):Connect(function()
                    if (not AutoSteerEnabled) then return; end
                    if (DirectionText.Text ~= "WAIT BEFORE STEERING") then
                        DodgeEvent:FireServer(math.random() < 0.5);
                        Interface:Notify("auto steer", "dodged missile");
                    end
                end);
            end);
        end
    end
});

local AutoRefuelEnabled: boolean = false;
MainTab:AddToggle({
    Name = "auto refuel",
    Default = false,
    Callback = function(Value: boolean)
        AutoRefuelEnabled = Value;
        if (Value) then 
            task.spawn(function()
                while (AutoRefuelEnabled) do
                    local Success: boolean, GasLevel: number? = pcall(function()
                        return Workspace.Plane.Machines.GasAmount.SurfaceGui.MainFrame.Frame.Bar.Size.X.Scale;
                    end);
                    if (Success and GasLevel and GasLevel <= 0.45) then
                        local RootPart: BasePart? = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
                        local OriginalCFrame: CFrame? = RootPart and RootPart.CFrame;
                        local JerryCan: Tool? = LocalPlayer.Backpack:FindFirstChild("JerryCan");
                        
                        if (JerryCan) then
                            JerryCan.Parent = LocalPlayer.Character;
                        else
                            local TargetGasCan: BasePart? = Workspace:FindFirstChild("Plane") and Workspace.Plane:FindFirstChild("GrabGasCan") and Workspace.Plane.GrabGasCan:FindFirstChild("GrabGasCan");
                            if (TargetGasCan) then
                                CharController:TeleportToPart(TargetGasCan);
                                task.wait(0.51);
                                local Prompt: ProximityPrompt? = TargetGasCan:FindFirstChild("GrabCan");
                                if (Prompt) then fireproximityprompt(Prompt); end
                            end
                            continue;
                        end
                        
                        task.wait(0.1); 
                        CharController:PerformRefuel();
                        Interface:Notify("Done", "auto refueled");
                        
                        if (OriginalCFrame) then
                            local UpdatedRoot: BasePart? = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
                            if (UpdatedRoot) then UpdatedRoot.CFrame = OriginalCFrame; end
                        end
                    end
                    task.wait(1);
                end
            end); 
        end
    end
});

MainTab:AddButton({
    Name = "fix lights",
    Callback = function()
        local LightEvent: RemoteEvent = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("FixLightMinigame"):WaitForChild("Frame"):WaitForChild("CablesFrame"):WaitForChild("FixLight");
        for Index = 1, 5 do 
            LightEvent:FireServer("Light" .. Index); 
        end
        LightEvent:FireServer("LightPilot"); 
        Interface:Notify("Done", "lights fixed");
    end
});

MainTab:AddButton({
    Name = "fix fires",
    Callback = function()
        for Index = 1, 160 do 
            pcall(function() ReplicatedStorage:WaitForChild("FixFire"):FireServer("Fire" .. Index); end); 
        end
        Interface:Notify("Done", "fires extinguished");
    end
});

MainTab:AddButton({
    Name = "fix holes (need tape)",
    Callback = function()
        local HoleRemote: RemoteEvent | RemoteFunction = ReplicatedStorage:FindFirstChild("HoleFix") or ReplicatedStorage:FindFirstChild("FixHole");
        if (not HoleRemote) then Interface:Notify("Error", "remote not found"); return; end
        
        local TapeItem: Tool? = LocalPlayer.Backpack:FindFirstChild("Tape") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Tape"));
        if (TapeItem) then 
            TapeItem.Parent = LocalPlayer.Character; 
            task.wait(0.15); 
        end
        
        local IsEvent: boolean = HoleRemote:IsA("RemoteEvent");
        for Index = 1, 160 do 
            task.spawn(function() 
                pcall(function()
                    if (IsEvent) then 
                        HoleRemote:FireServer("Hole" .. Index); 
                    else 
                        HoleRemote:InvokeServer("Hole" .. Index); 
                    end
                end); 
            end); 
        end
        Interface:Notify("Done", "holes patched");
    end
});

MainTab:AddButton({ 
    Name = "fix nav", 
    Callback = function()
        ReplicatedStorage:WaitForChild("FixNav"):FireServer(); 
        Interface:Notify("Done", "nav fixed");
    end 
});

MainTab:AddButton({
    Name = "fix engines",
    Callback = function()
        task.spawn(function()
            local EngineRemote: RemoteEvent? = ReplicatedStorage:FindFirstChild("EngineFixEvents") and ReplicatedStorage.EngineFixEvents:FindFirstChild("FixEngineMinigame");
            if (not EngineRemote) then Interface:Notify("Error", "FixEngineMinigame remote not found"); return; end
            pcall(function() EngineRemote:FireServer(true); end);
            pcall(function() EngineRemote:FireServer(false); end);
            Interface:Notify("Done", "engines fixed");
        end);
    end
});

MainTab:AddButton({
    Name = "fix windows",
    Callback = function()
        for Index = 1, 20 do 
            pcall(function() ReplicatedStorage:WaitForChild("WindowMinigame"):FireServer("Window" .. Index, false); end); 
        end
        Interface:Notify("Done", "windows repaired");
    end
});

MainTab:AddButton({ 
    Name = "send flares", 
    Callback = function()
        local FlareEvent: RemoteEvent? = ReplicatedStorage:FindFirstChild("SteeringFlares");
        if (FlareEvent) then 
            FlareEvent:FireServer(); 
            Interface:Notify("Done", "flares sent"); 
        else 
            Interface:Notify("Error", "not found"); 
        end
    end 
});

MainTab:AddButton({
    Name = "give all tools",
    Callback = function()
        local BuyEvent: RemoteEvent = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Shop"):WaitForChild("ShopFrame"):WaitForChild("BuyItem");
        for _, ToolName: string in ipairs({"Tape", "Screwdriver", "Mop", "PropaneTorch", "DoorStopper", "Hammer", "Wrench"}) do
            pcall(function() BuyEvent:FireServer(ToolName, 0); end);
        end
        Interface:Notify("Done", "all tools given");
    end
});

MainTab:AddButton({
    Name = "instant interact",
    Callback = function()
        local function ApplyHook(TargetObject: Instance)
            if (TargetObject:IsA("ProximityPrompt")) then
                TargetObject.HoldDuration = 0;
                if (not TargetObject:GetAttribute("InstantHooked")) then
                    TargetObject:GetPropertyChangedSignal("HoldDuration"):Connect(function()
                        if (TargetObject.HoldDuration ~= 0) then TargetObject.HoldDuration = 0; end
                    end);
                    TargetObject:SetAttribute("InstantHooked", true);
                end
            end
        end
        for _, Object: Instance in ipairs(Workspace:GetDescendants()) do ApplyHook(Object); end
        Workspace.DescendantAdded:Connect(ApplyHook); 
        game.DescendantAdded:Connect(ApplyHook);
        Interface:Notify("Done", "instant interact enabled");
    end
});

local function CreateTeleportButton(Tab: any, ButtonName: string, PartFinder: () -> BasePart?): nil
    Tab:AddButton({ 
        Name = ButtonName, 
        Callback = function() 
            pcall(function() 
                local TargetPart: BasePart? = PartFinder();
                if (TargetPart) then
                    CharController:TeleportToPart(TargetPart); 
                else
                    Interface:Notify("Error", "Location not found (are you in the lobby?)");
                end
            end); 
        end 
    });
    return nil;
end

CreateTeleportButton(TeleportsTab, "gas can", function() return Workspace:FindFirstChild("Plane") and Workspace.Plane:FindFirstChild("GrabGasCan") and Workspace.Plane.GrabGasCan:FindFirstChild("GrabGasCan"); end);
CreateTeleportButton(TeleportsTab, "pilot seat", function() return Workspace:FindFirstChild("Plane") and Workspace.Plane:FindFirstChild("PilotSeat") and Workspace.Plane.PilotSeat:FindFirstChild("Seat"); end);
CreateTeleportButton(TeleportsTab, "mid plane", function() return Workspace:FindFirstChild("Plane") and Workspace.Plane:FindFirstChild("Fuselage"); end);
CreateTeleportButton(TeleportsTab, "mop (plane tools)", function() return Workspace:FindFirstChild("Plane") and Workspace.Plane:FindFirstChild("Tools") and Workspace.Plane.Tools:FindFirstChild("Mop"); end);

TeleportsTab:AddButton({ 
    Name = "generator", 
    Callback = function()
        local TempPart: Part = Instance.new("Part");
        TempPart.CanCollide = false; 
        TempPart.Transparency = 1; 
        TempPart.Anchored = true;
        TempPart.CFrame = CFrame.new(0.628192008, 18.8988991, -86.9489975);
        TempPart.Parent = Workspace;
        CharController:TeleportToPart(TempPart); 
        task.wait(0.5); 
        TempPart:Destroy();
    end 
});

for Index = 1, 3 do
    CreateTeleportButton(TeleportsTab, "jet position " .. Index, function() return Workspace:FindFirstChild("JetPosition" .. Index) :: BasePart?; end);
end


type ClassData = { Name: string, Id: string };
local ClassList: {ClassData} = {
    { Name = "Co-Pilot", Id = "CoPilot" },
    { Name = "Pilot", Id = "Pilot" },
    { Name = "Electrician", Id = "Electrician" },
    { Name = "Mechanic", Id = "Mechanic" },
    { Name = "Welder", Id = "Welder" },
    { Name = "Janitor", Id = "Janitor" },
    { Name = "Handyman", Id = "Handyman" },
    { Name = "Pumper", Id = "Pumper" },
    { Name = "Military Pilot", Id = "Military" },
    { Name = "Retired FMRA", Id = "FMRA" },
    { Name = "Ornithologist", Id = "Ornithologist" },
    { Name = "Jogger", Id = "Jogger" },
    { Name = "Engineer", Id = "Engineer" },
    { Name = "Construction Worker", Id = "Construction" },
    { Name = "Experienced Technician", Id = "ExperiencedTechnician" },
    { Name = "Experienced Pilot", Id = "ExperiencedPilot" },
    { Name = "Santa", Id = "Santa" },
    { Name = "Jenkins", Id = "Jenkins" },
    { Name = "Planet Pilot", Id = "PlanetPilot" }
};

for _, ClassInfo: ClassData in ipairs(ClassList) do
    ClassesTab:AddButton({ 
        Name = ClassInfo.Name, 
        Callback = function()
            pcall(function() ReplicatedStorage.GameEvent:FireServer("Equip", ClassInfo.Id); end);
            pcall(function() ReplicatedStorage.GameEvent:FireServer("BuyClass", ClassInfo.Id); end);
            pcall(function() 
                local MainEvent: RemoteEvent = LocalPlayer.PlayerGui.Classes.Frame.MainClassEvent;
                MainEvent:FireServer("Buy", 0, ClassInfo.Id == "ExperiencedTechnician" and "Technician" or ClassInfo.Id);
                MainEvent:FireServer("Equip", 0, ClassInfo.Id);
            end);
            Interface:Notify("Class", "equipping " .. ClassInfo.Name);
        end 
    });
end

MiscTab:AddButton({ 
    Name = "give 10K points", 
    Callback = function()
        pcall(function() LocalPlayer.PlayerGui.Shop.ShopFrame.BuyItem:FireServer("Mop", -10000); end);
        Interface:Notify("Done", "10k points given");
    end 
});

MiscTab:AddButton({ 
    Name = "give 50K points", 
    Callback = function()
        pcall(function() LocalPlayer.PlayerGui.Shop.ShopFrame.BuyItem:FireServer("Mop", -50000); end);
        Interface:Notify("Done", "50k points given");
    end 
});

MiscTab:AddButton({ 
    Name = "refuel (manual)", 
    Callback = function()
        CharController:PerformRefuel();
        Interface:Notify("Done", "refueled");
    end 
});

Interface:Notify("Loaded", "Successfully loaded rustware v7.0");
OrionLib:Init();
