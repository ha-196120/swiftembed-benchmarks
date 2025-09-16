-- benchmark.lua - Comprehensive performance evaluation
-- Teste différents scénarios avec des tailles de lot variables

local random = math.random
local json = require("json")

local sample_texts = {} -- Remplir avec des textes d'exemple

-- Configuration des scénarios de test
local scenarios = {
    {name = "single", weight = 0.3, size = 1},
    {name = "small_batch", weight = 0.4, size = 10},
    {name = "medium_batch", weight = 0.2, size = 50},
    {name = "large_batch", weight = 0.1, size = 100}
}

-- Initialisation
function init(args)
    requests = {}
    local request_id = 1
    
    -- Préparer des requêtes pour chaque scénario
    for _, scenario in ipairs(scenarios) do
        for i = 1, 50 do  -- 50 requêtes par scénario
            local batch_texts = {}
            for j = 1, scenario.size do
                table.insert(batch_texts, sample_texts[random(#sample_texts)])
            end
            
            local body = json.encode({texts = batch_texts})
            requests[request_id] = {
                req = wrk.format("POST", "/embed", 
                    {["Content-Type"] = "application/json"}, 
                    body),
                scenario = scenario.name
            }
            request_id = request_id + 1
        end
    end
    
    req_index = 1
    stats = {
        single = {count = 0, total_time = 0},
        small_batch = {count = 0, total_time = 0},
        medium_batch = {count = 0, total_time = 0},
        large_batch = {count = 0, total_time = 0}
    }
end

-- Sélection de requête avec distribution pondérée
function request()
    if req_index > #requests then
        req_index = 1
    end
    
    local request_data = requests[req_index]
    req_index = req_index + 1
    return request_data.req
end

-- Traitement de la réponse avec collecte de métriques
function response(status, headers, body)
    if status ~= 200 then
        print("Error: " .. status)
        return
    end
    
    -- Extraire le temps de traitement depuis les headers
    local processing_time = tonumber(headers["X-Processing-Time-Ms"]) or 0
    
    -- Identifier le scénario de la requête
    local current_req = requests[req_index - 1] or requests[#requests]
    local scenario = current_req.scenario
    
    -- Mettre à jour les statistiques
    if stats[scenario] then
        stats[scenario].count = stats[scenario].count + 1
        stats[scenario].total_time = stats[scenario].total_time + processing_time
    end
end

-- Fonction appelée à la fin du test
function done(summary, latency, requests)
    print("\n=== BENCHMARK RESULTS ===")
    
    -- Afficher les statistiques par scénario
    for _, scenario in ipairs(scenarios) do
        local name = scenario.name
        if stats[name] and stats[name].count > 0 then
            local avg_time = stats[name].total_time / stats[name].count
            print(string.format("%s: %d requests, avg latency: %.2f ms", 
                name, stats[name].count, avg_time))
        end
    end
    
    -- Statistiques globales
    print("\nGlobal statistics:")
    print(string.format("Total requests: %d", summary.requests))
    print(string.format("Duration: %.2f s", summary.duration / 1000000))
    print(string.format("Throughput: %.2f req/s", summary.requests / (summary.duration / 1000000)))
    print(string.format("Non-2xx responses: %d", summary.errors.status))
    print(string.format("Socket errors: %d", summary.errors.connect + summary.errors.read + summary.errors.write + summary.errors.timeout))
    
    -- Percentiles de latence
    print("\nLatency percentiles (ms):")
    print(string.format("50%%: %.2f", latency:percentile(50) / 1000))
    print(string.format("75%%: %.2f", latency:percentile(75) / 1000))
    print(string.format("90%%: %.2f", latency:percentile(90) / 1000))
    print(string.format("99%%: %.2f", latency:percentile(99) / 1000))
end
