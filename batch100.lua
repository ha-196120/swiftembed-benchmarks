-- batch100.lua - Benchmark for batch processing (100 textes par requête)
-- Teste les performances pour des requêtes par lots de 100 textes

local random = math.random
local json = require("json")

-- Liste de textes d'exemple pour les tests
local sample_texts = {
    -- (même liste que dans single.lua, étendue avec plus d'exemples)
}

-- Initialisation
function init(args)
    -- Préparer les requêtes de batch de 100 textes
    requests = {}
    for i = 1, 100 do  -- Pré-générer 100 requêtes de batch
        local batch_texts = {}
        for j = 1, 100 do  -- 100 textes par batch
            table.insert(batch_texts, sample_texts[random(#sample_texts)])
        end
        local body = json.encode({texts = batch_texts})
        requests[i] = wrk.format("POST", "/embed", {["Content-Type"] = "application/json"}, body)
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
        print("Error: " .. status .. " - " .. body)
    end
    -- Vérifier le nombre d'embeddings retournés
    local data = json.decode(body)
    if data and data.embeddings and #data.embeddings ~= 100 then
        print("Warning: incorrect number of embeddings returned: " .. #data.embeddings)
    end
end
