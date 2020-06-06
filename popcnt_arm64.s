// Cribbed from https://github.com/klauspost, which is MIT-Licensed
//
// +build arm64,!gccgo,!appengine

// func getProcFeatures
TEXT ·getProcFeatures(SB), 7, $0
	WORD $0xd5380400            // mrs x0, id_aa64pfr0_el1  /* Processor Feature Register 0 */
	MOVD R0, procFeatures+0(FP)
	RET
