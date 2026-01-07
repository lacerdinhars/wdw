-- DIVISIONAL NINJA V17 (WDW - THE LOOSE MAGNET)
-- Focado em: Magnetismo Real, Sem Visuais, Sem Trava de Câmera

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- CONFIGURAÇÕES IGUAL AO VÍDEO DO LOOSE
local MagnetAtivo = true
local ForcaIma = 0.18 -- Suavidade da puxada
local RaioInvisivel = 75 -- Alcance da assistência

local function GetClosestTarget()
    local target = nil
    local shortestDist = RaioInvisivel

    for _, p in pairs(Players:GetPlayers()) do
        -- Ignora você, seu time e quem já morreu
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

                if dist < shortestDist then
                    target = screenPos
                    shortestDist = dist
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if MagnetAtivo then
        local target = GetClosestTarget()
        if target then
            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
            -- Calcula o movimento sutil (Magnet)
            local diffX = (target.X - mousePos.X) * ForcaIma
            local diffY = (target.Y - mousePos.Y) * ForcaIma
            
            -- Usa o método de movimento de mouse real do Solara
            if typeof(mousemoverel) == "function" then
                mousemoverel(diffX, diffY)
            else
                -- Fallback suave para evitar travas de câmera
                local currentCF = Camera.CFrame
                local newCF = CFrame.new(currentCF.Position, Camera:ViewportPointToRay(target.X, target.Y).Direction * 100 + currentCF.Position)
                Camera.CFrame = currentCF:Lerp(newCF, ForcaIma)
            end
        end
    end
end)

-- Tecla [V] para o ESP (Apenas contorno discreto)
local EspOn = false
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "v" then
        EspOn = not EspOn
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if EspOn then
                    local h = p.Character:FindFirstChild("LooseWDW") or Instance.new("Highlight", p.Character)
                    h.Name = "LooseWDW"
                    h.FillTransparency = 1 
                    h.OutlineColor = (p.Team == LocalPlayer.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                else
                    if p.Character:FindFirstChild("LooseWDW") then p.Character.LooseWDW:Destroy() end
                end
            end
        end
    end
end)
