# SwiftEmbed Benchmarks

Repository of benchmarking scripts for the SwiftEmbed embedding system, a static token lookup approach for ultra-low latency text embeddings.

## 📋 Description

This repository contains Lua scripts used to evaluate the performance of the SwiftEmbed system as described in the paper "SwiftEmbed: Ultra-Fast Text Embeddings via Static Token Lookup for Real-Time Applications". These scripts measure latency, throughput, and scalability under different workload patterns.

## 🚀 Features

- **Single embedding benchmark**: Performance measurement for individual requests
- **Batch processing**: Evaluation with batches of 100 texts
- **JSON Lines streaming**: Throughput testing with JSONL format
- **Comprehensive evaluation**: Combined testing with various batch sizes

## 📊 Included Scripts

### single.lua
Performance testing for single text embedding. Measures:
- p50/p99 latency for individual requests
- Maximum throughput for simple requests
- Error rates under load

### batch100.lua
Batch processing tests with 100 texts. Measures:
- Batch processing performance
- Memory optimization with fixed-size batches
- Scalability with heavy loads

### jsonl.lua
JSON Lines streaming tests. Measures:
- Throughput with streaming format
- Large volume data handling
- Performance with continuous processing

### benchmark.lua
Comprehensive performance evaluation. Measures:
- Performance across different batch sizes
- Comparative analysis between scenarios
- Detailed statistics and latency percentiles

## 🛠️ Installation & Usage

### Prerequisites
- [wrk](https://github.com/wg/wrk) (version 4.1.0 or higher)
- SwiftEmbed server running
- Lua JSON library (if needed)

### Installing wrk
```bash
# On Ubuntu/Debian
sudo apt install wrk

# On macOS
brew install wrk

# Compile from source
git clone https://github.com/wg/wrk.git
cd wrk
make
sudo cp wrk /usr/local/bin/
```

### Running Tests
```bash
# Single embedding test (12 threads, 400 connections, 30 seconds)
wrk -t12 -c400 -d30s -s scripts/single.lua http://localhost:3000

# Batch processing test
wrk -t12 -c400 -d30s -s scripts/batch100.lua http://localhost:3000

# JSONL streaming test
wrk -t12 -c400 -d30s -s scripts/jsonl.lua http://localhost:3000

# Comprehensive performance test
wrk -t12 -c400 -d30s -s scripts/benchmark.lua http://localhost:3000
```

## 📈 Measured Metrics

Each script captures the following performance metrics:
- **Latency**: p50, p75, p90, p99 (in milliseconds)
- **Throughput**: Requests per second (RPS)
- **Errors**: HTTP error rates and socket errors
- **Memory usage**: RAM consumption during tests
- **Processing time**: Extracted from X-Processing-Time-Ms headers

## 🔧 Configuration

Scripts are configurable through direct Lua code modification:
- Batch sizes in `batch100.lua` and `benchmark.lua`
- Sample texts in all scripts
- Test duration and intensity via wrk command line parameters

## 📖 Expected Results

Based on the research paper, typical SwiftEmbed performance metrics are:

| Metric | Value |
|--------|-------|
| p50 Latency | 1.12 ms |
| p99 Latency | 5.04 ms |
| Max Throughput | 50,000 RPS |
| MTEB Score | 60.6 (89% of Sentence-BERT) |

## 📚 References

- [Research Paper] SwiftEmbed: Ultra-Fast Text Embeddings via Static Token Lookup for Real-Time Applications
- [Main Repository](https://github.com/edlansiaux/swiftembed-benchmarks) SwiftEmbed (proprietary)
- [Benchmarking Tool] wrk - HTTP benchmarking tool

## 🤝 Contribution

This repository contains benchmarking scripts only. To contribute to the main SwiftEmbed project, please check the main repository.

## 📄 License

These benchmarking scripts are provided under the MIT License. See the LICENSE file for details.

## 🐛 Issue Reporting

To report issues or suggest improvements for these benchmarking scripts, please create an issue on this GitHub repository.

---

*These scripts were used for performance evaluation in SwiftEmbed research. Complete results are available in the associated research paper.*
