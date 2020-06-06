// +build arm64,!gccgo,!appengine

#include "textflag.h"

TEXT ·countBytesASM(SB), NOSPLIT, $0
	MOVD src+0(FP), R1
	MOVD len+8(FP), R2

	WORD $0xF9800022  // PRFM $0, R1  (Prefetch address R1 offset 0)
	MOVD ZR, R0
	CMP  $8, R2
	BLT  tail

	CMP $128, R2
	BLT loop

bigloop:
	VLD1.P 64(R1), [V16.B16, V17.B16, V18.B16, V19.B16]
	VLD1.P 64(R1), [V20.B16, V21.B16, V22.B16, V23.B16]
	// These instrutions should work -- and are represented by the below WORDs
	// However, Go (as of 1.14) silently treats them as the .B8 versions
	//VCNT   V16.B16, V0.B16
	//VCNT   V17.B16, V1.B16
	//VCNT   V18.B16, V2.B16
	//VCNT   V19.B16, V3.B16
	WORD $0x4E205A00
	WORD $0x4E205A21
	WORD $0x4E205A42
	WORD $0x4E205A63
	WORD $0x4E205A84
	WORD $0x4E205AA9
	WORD $0x4E205ACA
	WORD $0x4E205AEB

	VADD V4.B16, V9.B16, V12.B16
	VADD V10.B16, V11.B16, V13.B16
	VADD V12.B16, V13.B16, V14.B16
	VADD V0.B16, V1.B16, V5.B16
	VADD V2.B16, V3.B16, V6.B16
	VADD V5.B16, V6.B16, V7.B16
	VADD V14.B16, V7.B16, V7.B16
	WORD $0x6E3038E8            // UADDLV V7.B16, V8.H
	VMOV V8.H[0], R3
	ADD  R3, R0, R0

	SUB $128, R2
	CMP ZR, R2
	BEQ ret

	CMP $128, R2
	BGE bigloop

	CMP $8, R2
	BLT tail

loop:
	VEOR V7.B16, V7.B16, V7.B16
	VLD1.P 8(R1), [V16.B8]
	VCNT   V16.B8, V7.B8
	WORD   $0x2E3038E8     // UADDLV V7.B8, V8.H
	VMOV   V8.H[0], R3
	ADD    R3, R0, R0

	SUB $8, R2
	CMP ZR, R2
	BEQ ret

	CMP $8, R2
	BGE loop

tail:
	VEOR V9.B16, V9.B16, V9.B16

	CMP  $4, R2
	BLT  tail_2

	WORD $0x0DDF8029     // LD1.P 4(R1), V9.S[0]

	SUB $4, R2
	CMP ZR, R2
	BEQ tail_4

tail_2:
	CMP $2, R2
	BLT tail_3

	WORD $0x0DDF5029         // LD1.P 2(R1), V9.H[2]

	SUB $2, R2
	CMP ZR, R2
	BEQ tail_4

tail_3:
	WORD $0x0DDF1829        // LD1.P 2(R1), V9.B[6]

tail_4:
	VCNT   V9.B8, V7.B8
	WORD   $0x2E3038E8     // UADDLV V7.B8, V8.H
	VMOV   V8.H[0], R3
	ADD    R3, R0, R0

ret:
	MOVD R0, ret+16(FP)
	RET
