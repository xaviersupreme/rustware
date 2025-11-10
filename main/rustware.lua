                                                                                 local player=game.    
                                                                        Players.LocalPlayer;local gui=Instance.new(     
                                                                    "ScreenGui");gui.Name="rustware";gui.ResetOnSpawn=false;gui.  
                                                                Parent=player:WaitForChild("PlayerGui");local frame=Instance.new(       
                                                            "Frame");frame.Size=UDim2.new(0,300,0,400);frame.Position=UDim2.new(0.5, -150 
                                                          ,0.5, -185);frame.BackgroundColor3=Color3.fromRGB(25,25,25);frame.BorderSizePixel 
                                                        =0;local UserInputService=game:GetService("UserInputService");local RunService=game:  
                                                      GetService("RunService");frame.Active=true;frame.Draggable=false;task.defer(function()    
                                                    local cam=workspace.CurrentCamera or workspace:WaitForChild("Camera") ;local screenSize=cam.  
                                                  ViewportSize;local scale=math.clamp(screenSize.X/1920 ,0.6,1);frame.Size=UDim2.new(0,300 * scale  
                                                  ,0,400 * scale );if ((typeof(title)=="Instance") and title:IsA("TextLabel")) then title.TextSize=20 
                                                 * scale ;end end);local dragging=false;local dragStart,startPos;local velocity=Vector2.new(0,0);local  
                                                lastPos=Vector2.new(0,0);local smoothPos=frame.Position;local function updateDrag(input) local delta=     
                                              input.Position-dragStart ;local newPos=UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X ,startPos.Y.    
                                              Scale,startPos.Y.Offset + delta.Y );smoothPos=smoothPos:Lerp(newPos,0.3);frame.Position=smoothPos;end         
                                            RunService.RenderStepped:Connect(function(dt) if  not dragging then frame.Position=frame.Position:Lerp(UDim2.new( 
                                            frame.Position.X.Scale,frame.Position.X.Offset + (velocity.X * dt) ,frame.Position.Y.Scale,frame.Position.Y.Offset  
                                          + (velocity.Y * dt) ),0.1);velocity*=0.85 if (velocity.Magnitude<0.05) then velocity=Vector2.new(0,0);end end end);     
                                          local function startDrag(input) dragging=true;dragStart=input.Position;startPos=frame.Position;lastPos=input.Position;end 
                                           local function stopDrag() dragging=false;end local function drag(input) updateDrag(input);local delta=input.Position-      
                                          lastPos ;velocity=velocity:Lerp(Vector2.new(delta.X,delta.Y) * 10 ,0.2);lastPos=input.Position;end frame.InputBegan:Connect 
                                        (function(input) if ((input.UserInputType==Enum.UserInputType.MouseButton1) or (input.UserInputType==Enum.UserInputType.Touch)) 
                                         then startDrag(input);input.Changed:Connect(function() if (input.    --[[==============================]]UserInputState==Enum.   
                                        UserInputState.End) then stopDrag();end end);end end);      --[[============================================]]UserInputService.   
                                        InputChanged:Connect(function(input) if (dragging and ( --[[======================================================]](input.         
                                      UserInputType==Enum.UserInputType.MouseMovement) or ( --[[==========================================================]]input.            
                                      UserInputType==Enum.UserInputType.Touch))) then     --[[==============================================================]]drag(input);end 
                                       end);frame.Parent=gui;local corner=Instance.new(   --[[================================================================]]"UICorner");    
                                      corner.CornerRadius=UDim.new(0,12);corner.Parent=   --[[==================================================================]]frame;local   
                                      titleBar=Instance.new("Frame");titleBar.Size=UDim2. --[[==================================================================]]new(1,0,0,35);    
                                    titleBar.BackgroundColor3=Color3.fromRGB(35,35,35);   --[[====================================================================]]titleBar.     
                    BorderSizePixel=0;titleBar.Parent=frame;local titleCorner=Instance.   --[[====================================================================]]new("UICorner") 
              ;titleCorner.CornerRadius=UDim.new(0,12);titleCorner.Parent=titleBar;local  --[[======================================================================]]title=        
            Instance.new("TextLabel");title.Size=UDim2.new(1,0,1,0);title.                --[[======================================================================]]              
          BackgroundTransparency=1;title.Text="rustware";title.Font=Enum.Font.GothamBold; --[[======================================================================]]title.        
        TextSize=17;title.Parent=titleBar;local UserInputService=game:GetService(         --[[======================================================================]]              
        "UserInputService");local RunService=game:GetService("RunService");local          --[[======================================================================]]              
      UserInputService=game:GetService("UserInputService");local RunService=game:         --[[======================================================================]]GetService(   
      "RunService");local Players=game:GetService("Players");task.spawn(function() while    --[[==================================================================]]task.wait() do  
      title.TextColor3=Color3.fromHSV((tick()%5)/5 ,0.9,1);end end);local tabBar=Instance.  --[[================================================================]]new("Frame");     
    tabBar.Size=UDim2.new(1,0,0,30);tabBar.Position=UDim2.new(0,0,0,38);tabBar.             --[[==============================================================]]                  
    BackgroundTransparency=1;tabBar.Parent=frame;local tabLayout=Instance.new("UIListLayout") --[[==========================================================]];tabLayout.         
    FillDirection=Enum.FillDirection.Horizontal;tabLayout.HorizontalAlignment=Enum.             --[[====================================================]]HorizontalAlignment.    
    Center;tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center;tabLayout.Padding=UDim.new(0 --[[==============================================]],8);tabLayout.Parent=     
    tabBar;local function makeTabButton(text) local btn=Instance.new("TextButton");btn.Size=UDim2.new --[[====================================]](0,100,0,20);btn.             
    BackgroundColor3=Color3.fromRGB(40,40,40);btn.Text=text;btn.Font=Enum.Font.Gotham;btn.TextSize=14;btn --[[========================]].AutoButtonColor=true;btn.Parent=     
    tabBar;local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,6);c.Parent=btn;task.spawn(function() while task.wait() do btn.TextColor3=Color3.fromHSV((tick()%5)/5 
   ,0.9,1);end end);return btn;end local pagesHolder=Instance.new("Frame");pagesHolder.Size=UDim2.new(1,0,1, -70);pagesHolder.Position=UDim2.new(0,0,0,70);pagesHolder.   
  BackgroundTransparency=1;pagesHolder.Parent=frame;local mainPage=Instance.new("Frame");mainPage.Size=UDim2.new(1,0,1,0);mainPage.BackgroundTransparency=1;mainPage.   
  Parent=pagesHolder;local telePage=Instance.new("Frame");telePage.Size=UDim2.new(1,0,1,0);telePage.BackgroundTransparency=1;telePage.Visible=false;telePage.Parent=      
  pagesHolder;local mainLayout=Instance.new("UIListLayout");mainLayout.Padding=UDim.new(0,10);mainLayout.FillDirection=Enum.FillDirection.Vertical;mainLayout.            
  HorizontalAlignment=Enum.HorizontalAlignment.Center;mainLayout.VerticalAlignment=Enum.VerticalAlignment.Top;mainLayout.Parent=mainPage;local teleLayout=Instance.new(   
  "UIListLayout");teleLayout.Padding=UDim.new(0,10);teleLayout.FillDirection=Enum.FillDirection.Vertical;teleLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center;  
  teleLayout.VerticalAlignment=Enum.VerticalAlignment.Top;teleLayout.Parent=telePage;local function makeButtonIn(parentFrame,name,callback) local button=Instance.new(    
  "TextButton");button.Size=UDim2.new(0,230,0,35);button.BackgroundColor3=Color3.fromRGB(40,40,40);button.Text=name;button.Font=Enum.Font.Gotham;button.TextSize=16;      
  button.AutoButtonColor=true;button.Parent=parentFrame;local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,8);corner.Parent=button;task.spawn(function( 
  ) while task.wait() do if (button and button.Parent) then button.TextColor3=Color3.fromHSV((tick()%5)/5 ,0.9,1);else break;end end end);button.MouseButton1Click:       
  Connect(function() callback(button);end);return button;end local mainTabBtn=makeTabButton("main");local teleTabBtn=makeTabButton("teleports");mainTabBtn.               
  MouseButton1Click:Connect(function() mainPage.Visible=true;telePage.Visible=false;mainTabBtn.BackgroundColor3=Color3.fromRGB(50,50,50);teleTabBtn.BackgroundColor3=Color3 
  .fromRGB(40,40,40);end);teleTabBtn.MouseButton1Click:Connect(function() mainPage.Visible=false;telePage.Visible=true;mainTabBtn.BackgroundColor3=Color3.fromRGB(40,40,40) 
  ;teleTabBtn.BackgroundColor3=Color3.fromRGB(50,50,50);end);mainTabBtn.BackgroundColor3=Color3.fromRGB(50,50,50);teleTabBtn.BackgroundColor3=Color3.fromRGB(40,40,40);     
  local spamOxygen=false;local oxygenButton;oxygenButton=makeButtonIn(mainPage,"spam oxygen (off)",function(btn) spamOxygen= not spamOxygen;btn.Text=(spamOxygen and        
  "spam oxygen (on)") or "spam oxygen (off)" ;if spamOxygen then task.spawn(function() local event=workspace:FindFirstChild("Values") and workspace.Values:FindFirstChild(  
  "RepumpAirEvent") ;if  not event then warn("could not find workspace.Values.RepumpAirEvent");spamOxygen=false;btn.Text="spam oxygen (off)";return;end while spamOxygen do 
   local ok,err=pcall(function() event:FireServer();end);if  not ok then warn("RepumpAirEvent failed:",err);spamOxygen=false;btn.Text="spam oxygen (off)";break;end task.   
  wait(0.01);end end);end end);makeButtonIn(mainPage,"fix lights",function() local event=player:WaitForChild("PlayerGui"):WaitForChild("FixLightMinigame"):WaitForChild(    
  "Frame"):WaitForChild("CablesFrame"):WaitForChild("FixLight");for i=1,5 do event:FireServer("Light"   .. i );end end);makeButtonIn(mainPage,"fix fires",function() for i= 
  1,160 do local args={[1]="Fire"   .. i };game:GetService("ReplicatedStorage"):WaitForChild("FixFire",8999999488):FireServer(unpack(args));end end);makeButtonIn(mainPage, 
  "fix holes (need tape)",function(btn) local rs=game:GetService("ReplicatedStorage");local player=game:GetService("Players").LocalPlayer;local remote=rs:FindFirstChild(   
  "HoleFix") or rs:FindFirstChild("FixHole") ;if  not remote then for _,v in ipairs(rs:GetChildren()) do if ((v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and v.Name:  
  lower():find("hole")) then remote=v;break;end end end if  not remote then warn("[fix holes] remote not found");return;end local character=player.Character or player.     
  CharacterAdded:Wait() ;local backpack=player:WaitForChild("Backpack");local tape=backpack:FindFirstChild("Tape") or character:FindFirstChild("Tape") ;if tape then tape 
  .Parent=character;task.wait(0.15);else warn("[fix holes] Tape not found");end local isEvent=remote:IsA("RemoteEvent");task.spawn(function() for i=1,160 do task.spawn(  
  function() local arg="Hole"   .. i ;pcall(function() if isEvent then remote:FireServer(arg);else remote:InvokeServer(arg);end end);end);end end);pcall(function() game. 
    StarterGui:SetCore("SendNotification",{Title="\n[DEBUG] fixed holes",Text="",Duration=2});end);end);local separator=Instance.new("Frame");separator.Size=UDim2.new(0, 
    230,0,1);separator.BackgroundColor3=Color3.fromRGB(70,70,70);separator.BorderSizePixel=0;separator.Parent=mainPage;local separator=Instance.new("Frame");separator.   
    Size=UDim2.new(0,230,0,1);separator.BackgroundColor3=Color3.fromRGB(70,70,70);separator.BorderSizePixel=0;separator.Parent=telePage;makeButtonIn(mainPage,"fix nav",  
    function() local args={};game:GetService("ReplicatedStorage"):WaitForChild("FixNav",8999999488):FireServer(unpack(args));end);local speedHooked=false;local orig_mt,  
      orig_index;makeButtonIn(mainPage,"loop walkspeed (off)",function(btn) speedHooked= not speedHooked;btn.Text=(speedHooked and "loop walkspeed (on)") or            
      "loop walkspeed (off)" ;if speedHooked then local ok,err=pcall(function() local mt=getrawmetatable(game);orig_mt=mt;orig_index=mt.__index;if setreadonly then     
      setreadonly(mt,false);end mt.__index=newcclosure(function(self,key) if ((typeof(self)=="Instance") and self:IsA("Humanoid") and ((key=="WalkSpeed") or (tostring( 
        key)=="WalkSpeed"))) then return 15;end return orig_index(self,key);end);if setreadonly then setreadonly(mt,true);end end);if  not ok then warn(                
        "hookmetamethod installation failed, falling back to direct WalkSpeed sets:",err);task.spawn(function() while speedHooked do local char=player.Character or     
        player.CharacterAdded:Wait() ;local hum=char:FindFirstChildOfClass("Humanoid");if hum then pcall(function() hum.WalkSpeed=15;end);end task.wait(0.1);end end);  
          else task.spawn(function() while speedHooked do local char=player.Character or player.CharacterAdded:Wait() ;local hum=char:FindFirstChildOfClass(          
            "Humanoid");if hum then pcall(function() hum.WalkSpeed=25;end);end task.wait(0.5);end end);end else local ok2,err2=pcall(function() if (orig_mt and       
              orig_index) then if setreadonly then setreadonly(orig_mt,false);end orig_mt.__index=orig_index;if setreadonly then setreadonly(orig_mt,true);end end    
                end);if  not ok2 then warn("failed to restore original metatable __index:",err2);end task.spawn(function() local char=player.Character or player.     
                  CharacterAdded:Wait() ;local hum=char:FindFirstChildOfClass("Humanoid");if hum then pcall(function() hum.WalkSpeed=16;end);end end);end end);     
                      makeButtonIn(mainPage,"instant interact",function() local function makePromptInstant(prompt) if prompt:IsA("ProximityPrompt") then prompt.    
                                  HoldDuration=0;end end for _,descendant in ipairs(workspace:GetDescendants()) do makePromptInstant(descendant);end workspace.     
                                      DescendantAdded:Connect(makePromptInstant);game.DescendantAdded:Connect(makePromptInstant);end);local function safeTeleportTo 
                                      (part) local ok,err=pcall(function() local char=player.               Character;if  not char then return false;end local hrp= 
                                      char:FindFirstChild("HumanoidRootPart") or char:                      FindFirstChild("Torso") or char:FindFirstChild(       
                                      "UpperTorso") ;if  not hrp then return false;end hrp.CFrame=          part.CFrame + Vector3.new(0,3,0) ;return true;end);   
                                      return ok,err;end makeButtonIn(telePage,"teleport to gas",            function(btn) local target=game:GetService(           
                                      "Workspace").Plane.GrabGasCan.GrabGasCan;if  not target then            warn("teleport: gas not found");return;end local ok 
                                      ,err=safeTeleportTo(target);if  not ok then warn(                       "teleport failed:",err);end end);makeButtonIn(      
                                      telePage,"teleport to generator",function(btn) local ss=                Instance.new("Part",game.Workspace);ss.Name=      
                                        "TeleportPart6767";ss.CanCollide=false;ss.Transparency=1;ss           .Anchored=true;ss.CFrame=CFrame.new(0.628192008,  
                                        18.8988991, -86.9489975, -0.0265148599,6.0853914e-8, -                 0.999648392,3.583086e-8,1,5.9924936e-8,       
                                        0.999648392, -3.422936e-8, -0.0265148599);local spawn=game             :GetService("Workspace").TeleportPart6767;if  
                                          not spawn then warn(                                                  "teleport: TeleportPart6767 not found");      
                                        return;end local ok,err=safeTeleportTo(spawn);if  not ok                  then warn("teleport failed:",err);end end 
                                        );makeButtonIn(telePage,"teleport to pilotseat",function(                 btn) local target=game:GetService(        
                                          "Workspace").Plane.PilotSeat.Seat;if  not target then                     warn("teleport: pilotseat not found") 
                                          ;return;end local ok,err=safeTeleportTo(target);if                          not ok then warn(               
                                            "teleport failed:",err);end game.StarterGui:SetCore                         ("SendNotification",{     
                                            Title="ø¤º°`°๑۩۞۩๑°`°º¤ø",Text=                                                               
                                              "DO NOT TELEPORT WHILE IN SEAT!",Duration=1.8 
                                                });end);makeButtonIn(telePage,            
                                                    "teleport to mid",function(btn)     
                                                          local target=game:      


GetService("Workspace").Plane.Fuselage;if  not target then warn("teleport: FuseLage not found");return;end local ok,err=safeTeleportTo(target);if  not ok then warn("teleport failed:",err);end end);
