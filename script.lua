-- DIVISIONAL NINJA V15 (ULTIMATE LOOSE MAGNET)
-- FOCO: APEX HARD | SEM TRAVAS | 100% LEGIT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- AJUSTES DE PERFORMANCE (ESTILO LOOSE)
local MagnetAtivo = true
local Suavidade = 0.17 -- Velocidade do imã (Aumente se quiser que grude mais rápido)
local RaioInvisivel = 80 -- Área de alcance (Onde o imã começa a "sentir" o inimigo)

local function GetClosestTarget()
    local target = nil
    local shortestDist = RaioInvisivel

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
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

-- Mecanismo de Magnetismo Teleguiado
RunService.RenderStepped:Connect(function()
    if MagnetAtivo then
        local target = GetClosestTarget()
        if target then
            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
            -- Movimento relativo suave para a cabeça
            local diffX = (target.X - mousePos.X) * Suavidade
            local diffY = (target.Y - mousePos.Y) * Suavidade
            
            -- Usa movimento de mouse real para evitar detecção
            if typeof(mousemoverel) == "function" then
                mousemoverel(diffX, diffY)
            else
                -- Backup suave para outros executores
                local currentCF = Camera.CFrame
                local newCF = CFrame.new(currentCF.Position, Camera:ViewportPointToRay(target.X, target.Y).Direction * 100 + currentCF.Position)
                Camera.CFrame = currentCF:Lerp(newCF, Suavidade)
            end
        end
    end
end)

-- ESP de Alta Performance (Tecla V)
local EspOn = false
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "v" then
        EspOn = not EspOn
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if EspOn then
                    local h = p.Character:FindFirstChild("LooseV15") or Instance.new("Highlight", p.Character)
                    h.Name = "LooseV15"
                    h.FillTransparency = 1 -- Mantém o boneco com cor original
                    h.OutlineColor = (p.Team == LocalPlayer.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                else
                    if p.Character:FindFirstChild("LooseV15") then p.Character.LooseV15:Destroy() end
                end
            end
        end
    end
end)
