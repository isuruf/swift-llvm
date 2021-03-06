; RUN: llc -mtriple=amdgcn-amd-amdhsa -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GCN %s

; GCN-LABEL: {{^}}scratch_buffer_known_high_masklo16:
; GCN: v_mov_b32_e32 [[FI:v[0-9]+]], 4
; GCN: v_and_b32_e32 [[MASKED:v[0-9]+]], 0xfffc, [[FI]]
; GCN: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[MASKED]]
define amdgpu_kernel void @scratch_buffer_known_high_masklo16() #0 {
  %alloca = alloca i32, align 4, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %alloca
  %toint = ptrtoint i32 addrspace(5)* %alloca to i32
  %masked = and i32 %toint, 65535
  store volatile i32 %masked, i32 addrspace(1)* undef
  ret void
}

; GCN-LABEL: {{^}}scratch_buffer_known_high_masklo17:
; GCN: v_mov_b32_e32 [[FI:v[0-9]+]], 4
; GCN-NOT: [[FI]]
; GCN: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[FI]]
define amdgpu_kernel void @scratch_buffer_known_high_masklo17() #0 {
  %alloca = alloca i32, align 4, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %alloca
  %toint = ptrtoint i32 addrspace(5)* %alloca to i32
  %masked = and i32 %toint, 131071
  store volatile i32 %masked, i32 addrspace(1)* undef
  ret void
}

; GCN-LABEL: {{^}}scratch_buffer_known_high_mask18:
; GCN: v_mov_b32_e32 [[FI:v[0-9]+]], 4
; GCN-NOT: [[FI]]
; GCN: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[FI]]
define amdgpu_kernel void @scratch_buffer_known_high_mask18() #0 {
  %alloca = alloca i32, align 4, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %alloca
  %toint = ptrtoint i32 addrspace(5)* %alloca to i32
  %masked = and i32 %toint, 262143
  store volatile i32 %masked, i32 addrspace(1)* undef
  ret void
}

attributes #0 = { nounwind }
