-- jsonl.lua - Benchmark for JSON Lines streaming
-- Teste les performances pour le format JSON Lines

local random = math.random

-- Générer un corpus de textes plus important
local sample_texts = {}
-- Remplir avec des centaines de textes d'exemple...

-- Initialisation
function init(args)
    requests = {}
    
    -- Préparer des requêtes JSONL avec 1000 lignes chacune
    for i = 1, 10 do  -- 10 requêtes JSONL différentes
        local jsonl_body = ""
        for j = 1, 1000 do  -- 1000 lignes JSON par requête
            local text = sample_texts[random(#sample_texts)]
            jsonl_body = jsonl_body .. '{"text":"' .. text:gsub('"', '\\"') .. '"}\n'
        end
        
        requests[i] = wrk.format("POST", "/embed/jsonl", 
            {["Content-Type"] = "application/jsonl"}, 
            jsonl_body)
    end
    req_index = 1
end

-- Génération de requête
function request()
    local request = requests[req_index]
    req_index = req_index + 1
    if req_index > #requests then
        req_index = 1
    end
    return request
end

-- Traitement de la réponse
function response(status, headers, body)
    if status ~= 200 then
        print("Error: " .. status)
        return
    end
    
    -- Compter le nombre de lignes dans la réponse JSONL
    local line_count = 0
    for _ in body:gmatch("[^\n]+") do
        line_count = line_count + 1
    end
    
    if line_count ~= 1000 then
        print("Warning: incorrect number of lines in response: " .. line_count)
    end
end
