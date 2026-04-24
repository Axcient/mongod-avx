## Overview

This project builds a custom MongoDB 8.0.* server package for Ubuntu 22.04 (Jammy) with specific patches and configuration adjustments.

It applies patches from the `patches/` directory to build MongoDB **without AVX** compiler flags, enabling compatibility with older CPUs that do not support AVX or AVX2 instructions.

Now supporting older CPUs like Core 2, which lack SSE4.2, AVX, and AVX2 instructions.

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

### For core2 CPUs

- **core2/0005-disable-crc32-snappy**
    Disables CRC32 support in Snappy compression for better compatibility with older CPUs.

---

## Dockerfiles

The following Dockerfile is provided to build the mongod server file:

- `Dockerfile-jammy` – Targets Ubuntu 22.04 (Jammy)

The Dockerfile includes build dependencies and scripts to produce a custom `mongod` file.

---

## Build Instructions

To build the Docker image and generate a custom `mongod` file, run:

```sh
./builder.sh "<REVISION>" <CPU_ARCH>
```

Example:

```sh
./builder.sh "12" "core2"

or

./builder.sh "12" "nehalem"
```