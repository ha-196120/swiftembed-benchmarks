-- single.lua - Benchmark for single text embedding
-- Teste les performances pour des requêtes d'embedding sur un seul texte

local random = math.random
local json = require("json")

-- Liste de textes d'exemple pour les tests
local sample_texts = {
    "The quick brown fox jumps over the lazy dog",
    "Artificial intelligence is transforming technology",
    "Natural language processing enables human-computer interaction",
    "Machine learning models require large amounts of data",
    "Deep learning has revolutionized computer vision",
    "The weather today is sunny with a chance of rain",
    "Embeddings represent text in high-dimensional space",
    "Performance benchmarking is essential for optimization",
    "Real-time applications require low latency responses",
    "Rust provides memory safety without garbage collection"
}

-- Initialisation: exécutée une fois au début du test
function init(args)
    -- Préparer les requêtes
    requests = {}
    for i = 1, 1000 do  -- Pré-générer 1000 requêtes
        local text = sample_texts[random(#sample_texts)]
        local body = json.encode({texts = {text}})
        requests[i] = wrk.format("POST", "/embed", {["Content-Type"] = "application/json"}, body)
    end
    req_index = 1
end

-- Génération de requête: appelée pour chaque requête
function request()
    local request = requests[req_index]
    req_index = req_index + 1
    if req_index > #requests then
        req_index = 1  -- Boucler si on atteint la fin
    end
    return request
end

-- Traitement de la réponse: optionnel, pour vérifier les erreurs
function response(status, headers, body)
    if status ~= 200 then
        print("Error: " .. status .. " - " .. body)
    end
end
