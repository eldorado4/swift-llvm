; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=41668

define double @constant_fold_fdiv_by_zero(double* %p) {
; CHECK-LABEL: constant_fold_fdiv_by_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #9218868437227405312
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    ret
  %r = fdiv double 4.940660e-324, 0.0
  ret double %r
}

; frem by 0.0 --> NaN

define double @constant_fold_frem_by_zero(double* %p) {
; CHECK-LABEL: constant_fold_frem_by_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #1
; CHECK-NEXT:    fmov d1, xzr
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    b fmod
  %r = frem double 4.940660e-324, 0.0
  ret double %r
}

; Inf * 0.0 --> NaN

define double @constant_fold_fmul_nan(double* %p) {
; CHECK-LABEL: constant_fold_fmul_nan:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #9218868437227405312
; CHECK-NEXT:    fmov d0, xzr
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    fmul d0, d1, d0
; CHECK-NEXT:    ret
  %r = fmul double 0x7ff0000000000000, 0.0
  ret double %r
}

; Inf + -Inf --> NaN

define double @constant_fold_fadd_nan(double* %p) {
; CHECK-LABEL: constant_fold_fadd_nan:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #-4503599627370496
; CHECK-NEXT:    mov x9, #9218868437227405312
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    fmov d1, x9
; CHECK-NEXT:    fadd d0, d1, d0
; CHECK-NEXT:    ret
  %r = fadd double 0x7ff0000000000000, 0xfff0000000000000
  ret double %r
}

; Inf - Inf --> NaN

define double @constant_fold_fsub_nan(double* %p) {
; CHECK-LABEL: constant_fold_fsub_nan:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #9218868437227405312
; CHECK-NEXT:    fmov d0, x8
; CHECK-NEXT:    fsub d0, d0, d0
; CHECK-NEXT:    ret
  %r = fsub double 0x7ff0000000000000, 0x7ff0000000000000
  ret double %r
}

; Inf * 0.0 + ? --> NaN

define double @constant_fold_fma_nan(double* %p) {
; CHECK-LABEL: constant_fold_fma_nan:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #4631107791820423168
; CHECK-NEXT:    mov x9, #9218868437227405312
; CHECK-NEXT:    fmov d0, xzr
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    fmov d2, x9
; CHECK-NEXT:    fmadd d0, d2, d0, d1
; CHECK-NEXT:    ret
  %r =  call double @llvm.fma.f64(double 0x7ff0000000000000, double 0.0, double 42.0)
  ret double %r
}

declare double @llvm.fma.f64(double, double, double)
