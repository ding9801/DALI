// Copyright (c) 2017-2018, NVIDIA CORPORATION. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "dali/util/type_conversion.h"

#include <cmath>

namespace dali {

namespace {
template <typename IN, typename OUT>
__global__ void ConvertKernel(const IN *data, int n, OUT *out) {
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  if (tid < n) {
    out[tid] = (OUT)data[tid];
  }
}
}  // namespace

template <typename IN, typename OUT>
void Convert(const IN *data, int n, OUT *out) {
  int block_size = 512;
  int blocks = ceil(static_cast<float>(n) / block_size);
  ConvertKernel<<<blocks, block_size, 0, 0>>>(data, n, out);
}

// Note: These are used in the test suite for output verification, we
// don't care if we do extra copy from T to T.
template void Convert<uint8, double>(const uint8*, int, double*);
template void Convert<float16, double>(const float16*, int, double*);
template void Convert<int, double>(const int*, int, double*);
template void Convert<float, double>(const float*, int, double*);
template void Convert<double, double>(const double*, int, double*);

}  // namespace dali
