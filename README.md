# go-popcount

[![GoDoc](https://godoc.org/github.com/barakmich/go-popcount?status.svg)](https://godoc.org/github.com/barakmich/go-popcount)

A population count implementation for Go. Forked from [https://github.com/tmthrgd/go-popcount](https://github.com/tmthrgd/go-popcount)

The original x86-64 implementation is provided that uses the POPCNT instruction.
This repo extends that support to using the VCNT instruction from ARM's NEON vector instructions for ARM64.

## Download

```
go get github.com/barakmich/go-popcount
```

## Benchmark x86-64

The following benchmarks relate to the assembly implementation on an
AMD64 CPU with POPCOUNT support.
```
BenchmarkCountBytes/32-8          300000000              5.47 ns/op        5854.04 MB/s
BenchmarkCountBytes/128-8         100000000              10.2 ns/op       12609.36 MB/s
BenchmarkCountBytes/1K-8           30000000              49.2 ns/op       20804.48 MB/s
BenchmarkCountBytes/16K-8           3000000               572 ns/op       28642.76 MB/s
BenchmarkCountBytes/128K-8           300000              4948 ns/op       26486.47 MB/s
BenchmarkCountBytes/1M-8              30000             50728 ns/op       20670.19 MB/s
BenchmarkCountBytes/16M-8              1000           1412299 ns/op       11879.36 MB/s
BenchmarkCountBytes/128M-8              100          11388799 ns/op       11785.06 MB/s
BenchmarkCountBytes/512M-8               30          45068056 ns/op       11912.45 MB/s
BenchmarkCountSlice64/32-8        300000000              5.51 ns/op        5804.87 MB/s
BenchmarkCountSlice64/128-8       100000000              10.6 ns/op       12047.47 MB/s
BenchmarkCountSlice64/1K-8         20000000              51.4 ns/op       19932.68 MB/s
BenchmarkCountSlice64/16K-8         2000000               597 ns/op       27414.74 MB/s
BenchmarkCountSlice64/128k-8         300000              4960 ns/op       26425.47 MB/s
BenchmarkCountSlice64/1M-8            30000             50861 ns/op       20616.24 MB/s
BenchmarkCountSlice64/16M-8            1000           1419479 ns/op       11819.28 MB/s
BenchmarkCountSlice64/128M-8            100          11287323 ns/op       11891.01 MB/s
BenchmarkCountSlice64/512M-8             30          45210522 ns/op       11874.91 MB/s
```

The following benchmarks relate to the Golang implementation using
[math/bits.OnesCount64](https://golang.org/pkg/math/bits/#OnesCount64) on
an AMD64 CPU with POPCOUNT support.
```
BenchmarkCountBytesGo/32-8        100000000              11.1 ns/op        2883.25 MB/s
BenchmarkCountBytesGo/128-8       100000000              20.6 ns/op        6204.80 MB/s
BenchmarkCountBytesGo/1k-8         10000000               115 ns/op        8896.25 MB/s
BenchmarkCountBytesGo/16k-8         1000000              1640 ns/op        9986.94 MB/s
BenchmarkCountBytesGo/128k-8         100000             13017 ns/op       10068.65 MB/s
BenchmarkCountBytesGo/1M-8            10000            105315 ns/op        9956.50 MB/s
BenchmarkCountBytesGo/16M-8            1000           2140396 ns/op        7838.37 MB/s
BenchmarkCountBytesGo/128M-8            100          17149248 ns/op        7826.45 MB/s
BenchmarkCountBytesGo/512M-8             20          68345879 ns/op        7855.21 MB/s
BenchmarkCountSlice64Go/32-8      200000000              6.61 ns/op        4840.05 MB/s
BenchmarkCountSlice64Go/128-8     100000000              16.1 ns/op        7936.33 MB/s
BenchmarkCountSlice64Go/1k-8       20000000               111 ns/op        9184.79 MB/s
BenchmarkCountSlice64Go/16k-8       1000000              1636 ns/op       10012.94 MB/s
BenchmarkCountSlice64Go/128k-8       100000             13053 ns/op       10041.31 MB/s
BenchmarkCountSlice64Go/1M-8          10000            105796 ns/op        9911.24 MB/s
BenchmarkCountSlice64Go/16M-8          1000           2145359 ns/op        7820.24 MB/s
BenchmarkCountSlice64Go/128M-8          100          17232666 ns/op        7788.56 MB/s
BenchmarkCountSlice64Go/512M-8           20          68713386 ns/op        7813.19 MB/s
```

## Benchmark ARM64

Using Amazon's m6g.xlarge Graviton 2 servers provides some impressive numbers:

```
goos: linux
goarch: arm64
pkg: github.com/barakmich/go-popcount
BenchmarkCountBytes/32              245307448          9.85 ns/op     3249.39 MB/s
BenchmarkCountBytes/128             253419275          9.55 ns/op    13405.52 MB/s
BenchmarkCountBytes/1K               59334969          40.4 ns/op    25323.71 MB/s
BenchmarkCountBytes/16K               4199566           571 ns/op    28673.85 MB/s
BenchmarkCountBytes/128K               496018          4839 ns/op    27084.88 MB/s
BenchmarkCountBytes/1M                  60721         39842 ns/op    26318.04 MB/s
BenchmarkCountBytes/16M                  3765        623579 ns/op    26904.70 MB/s
BenchmarkCountBytes/128M                  374       6390994 ns/op    21001.07 MB/s
BenchmarkCountBytes/512M                   85      27507419 ns/op    19517.31 MB/s
---
BenchmarkCountBytesGo/32            199811390          12.0 ns/op     2664.18 MB/s
BenchmarkCountBytesGo/128             9475469          25.3 ns/op     5054.35 MB/s
BenchmarkCountBytesGo/1K             16022817           150 ns/op     6838.21 MB/s
BenchmarkCountBytesGo/16K             1000000          2281 ns/op     7182.90 MB/s
BenchmarkCountBytesGo/128K             129426         18545 ns/op     7067.85 MB/s
BenchmarkCountBytesGo/1M                16136        148799 ns/op     7046.94 MB/s
BenchmarkCountBytesGo/16M                1018       2353183 ns/op     7129.58 MB/s
BenchmarkCountBytesGo/128M                124      19208578 ns/op     6987.38 MB/s
BenchmarkCountBytesGo/512M                 31      76826628 ns/op     6988.08 MB/s
```

But even the modest Raspberry Pi 4 8GB shows benefits:

```
goos: linux
goarch: arm64
pkg: github.com/barakmich/go-popcount
BenchmarkCountBytes/32               79724929          30.0 ns/op     1066.70 MB/s
BenchmarkCountBytes/128              76361557          31.4 ns/op     4076.12 MB/s
BenchmarkCountBytes/1K               15881499           151 ns/op     6776.48 MB/s
BenchmarkCountBytes/16K               1000000          2324 ns/op     7049.26 MB/s
BenchmarkCountBytes/128K               131925         18180 ns/op     7209.58 MB/s
BenchmarkCountBytes/1M                  12874        186267 ns/op     5629.42 MB/s
BenchmarkCountBytes/16M                   610       3922813 ns/op     4276.83 MB/s
BenchmarkCountBytes/128M                   72      32390129 ns/op     4143.78 MB/s
BenchmarkCountBytes/512M                   18     129570901 ns/op     4143.45 MB/s
-- -
BenchmarkCountBytesGo/32             76351704          31.4 ns/op     1018.70 MB/s
BenchmarkCountBytesGo/128            31907154          75.2 ns/op     1702.29 MB/s
BenchmarkCountBytesGo/1K              4567696           525 ns/op     1948.98 MB/s
BenchmarkCountBytesGo/16K              297778          8056 ns/op     2033.78 MB/s
BenchmarkCountBytesGo/128K              37696         63674 ns/op     2058.50 MB/s
BenchmarkCountBytesGo/1M                 4480        533732 ns/op     1964.61 MB/s
BenchmarkCountBytesGo/16M                 273       8747789 ns/op     1917.88 MB/s
BenchmarkCountBytesGo/128M                 33      70023483 ns/op     1916.75 MB/s
BenchmarkCountBytesGo/512M                  8     279380432 ns/op     1921.65 MB/s
```


## License

Unless otherwise noted, the go-popcount source files are distributed under the Modified BSD License found in the LICENSE file.


