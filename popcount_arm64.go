//go:build arm64 && !gccgo && !appengine && !darwin

package popcount

import "unsafe"

var usePOPCNT = hasPOPCNT()

func hasPOPCNT() bool {
	return getProcFeatures()&(0xF<<20) != 15<<20
}

// CountBytes function counts number of non-zero bits in slice of 8bit unsigned integers.
func CountBytes(s []byte) uint64 {
	if len(s) == 0 {
		return 0
	}

	if !usePOPCNT {
		return countBytesGo(s)
	}

	return countBytesASM(&s[0], uint64(len(s)))
}

// CountSlice64 function counts number of non-zero bits in slice of 64bit unsigned integers.
func CountSlice64(s []uint64) uint64 {
	if len(s) == 0 {
		return 0
	}

	if !usePOPCNT {
		return countSlice64Go(s)
	}

	return countBytesASM((*byte)(unsafe.Pointer(&s[0])), uint64(len(s)*8))
}

// This function is implemented in popcnt_arm64.s
//go:noescape
func getProcFeatures() (features uint64)

// This function is implemented in popcount_amd64.s
//go:noescape
func countBytesASM(src *byte, len uint64) (ret uint64)
