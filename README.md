## Overview

This project builds a custom MongoDB 8.0.* server package for different Ubuntu distributions (Focal and Jammy) with specific patches and configuration adjustments.

It applies patches from the `patches/` directory to build MongoDB **without AVX** compiler flags, enabling compatibility with older CPUs that do not support AVX or AVX2 instructions.

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
  Improve compatibility and portability by avoiding advanced CPU-specific features.


---

## Dockerfiles

The following Dockerfiles are provided to build mongod serber file:

- `Dockerfile-focal` – Targets Ubuntu 20.04 (Focal)
- `Dockerfile-jammy` – Targets Ubuntu 22.04 (Jammy)

Each Dockerfile includes build dependencies and scripts to produce a custom `mongod` file for the respective platform.

---

## Build Instructions

To build the Docker image and generate a custom `mongod` file, run:

```sh
./builder.sh "<REVISION>" <DISTRIBUTION> <NUMBER_OF_CPU_CORES>