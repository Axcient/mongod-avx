## Overview

This project builds a custom MongoDB 8.0.* server package for **Ubuntu 22.04 (Jammy)** or **Ubuntu 24.04 (Noble)** with specific patches and configuration adjustments.

It applies patches from the `patches/` directory to build MongoDB **without AVX** compiler flags, enabling compatibility with older CPUs that do not support AVX or AVX2 instructions.

The build uses `--copt=-march=${CPU_ARCH}` (for example `nehalem` or `core2`) so you can target older machines. Core&nbsp;2–class CPUs lack SSE4.2 as well as AVX/AVX2; when `CPU_ARCH=core2`, an extra Snappy patch is applied (see below).

This project is based on the official MongoDB source code, which is licensed under the Server Side Public License (SSPL) v1.  
The original source code is available here:  
https://github.com/mongodb/mongo

---

## Patches

The following patches are applied to the MongoDB source tree:

- **0001-Compile-without-debug-symbols.patch**  
  Removes debug symbols to reduce binary size.

- **0002-Removed_AVX-2_CCFLAG_from_mozjs.patch**  
  Eliminates AVX2-specific compile flags from the `mozjs` library.

- **0003-Disabled_AVX_in_mozjs_SIMD.patch**  
  Disables AVX instruction use inside `mozjs` SIMD implementation.

- **0004-Disable-advanced-features-gcc.patch**
  Improves compatibility and portability by avoiding advanced CPU-specific features.

### For core2 (`--build-arg CPU_ARCH=core2`)

- **core2/0005-disable-crc32-snappy.patch**  
  Disables the x86 CRC32 fast path in Snappy (uses a portable hash instead), avoiding SSE4.2 `crc32` instructions that Core&nbsp;2 does not support.

---

## Dockerfiles

Use one of the following to build the `mongod` binary inside a matching Ubuntu image:

- `Dockerfile-jammy` – Ubuntu 22.04 (Jammy)
- `Dockerfile-noble` – Ubuntu 24.04 (Noble; Bazel adds GCC 13 workarounds: `-Wno-interference-size`, `-Wno-mismatched-new-delete`, `-Wno-array-bounds`, `-Wno-stringop-overflow`)

The Dockerfile includes build dependencies and scripts to produce a custom `mongod` file.

**Noble vs Jammy compiler:** Noble’s default **GCC 13** is stricter than Jammy’s **GCC 11** for diagnostics that MongoDB 8.0.x triggers under **`-Werror`**. APT packages here are normal LTS compilers, not outdated. Extra `--cxxopt`/`--copt` on Noble work around GCC-13-specific issues (`immer`, `std::hardware_*_interference_size`, etc.). In **`.bazelrc.local`** this repo uses **`--cxxopt=-Wno-pessimizing-move`** instead of `-Wpessimizing-move` so redundant `std::move` diagnostics are not enabled on top of Mongo’s warning set.

---

## Build Instructions

To build the Docker image and generate a custom `mongod` file, run:

```text
./builder.sh [<REVISION>] [<CPU_ARCH>] [<UBUNTU_CODENAME>]
```

Example:

```sh
./builder.sh "12" "nehalem"
./builder.sh "12" "core2"
```

`CPU_ARCH` is any valid GCC `-march=` value (default in Dockerfile: `nehalem`). For Core&nbsp;2, use `core2` so the Dockerfile merges in the Snappy CRC32 patch.

### Examples (Noble)

```sh
./builder.sh "12" "nehalem" noble
./builder.sh "12" "core2" noble
```