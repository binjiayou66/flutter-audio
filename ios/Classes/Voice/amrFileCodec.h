//
//  amrFileCodec.h
//  amrForiOS
//
//  Created by TX on 16/02/2017.
//  Copyright © 2017 Andrew Shen. All rights reserved.
//

#ifndef amrFileCodec_h
#define amrFileCodec_h
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "interf_enc.h"
#include "interf_dec.h"

#define AMR_MAGIC_NUMBER "#!AMR\n"

#define PCM_FRAME_SIZE 160 // 8khz 8000*0.02=160
#define MAX_AMR_FRAME_SIZE 32
#define AMR_FRAME_COUNT_PER_SECOND 50

typedef struct
{
	char chChunkID[4];
	int nChunkSize;
}XCHUNKHEADER;

typedef struct
{
	short nFormatTag;
	short nChannels;
	int nSamplesPerSec;
	int nAvgBytesPerSec;
	short nBlockAlign;
	short nBitsPerSample;
}WAVEFORMAT;

typedef struct
{
	short nFormatTag;
	short nChannels;
	int nSamplesPerSec;
	int nAvgBytesPerSec;
	short nBlockAlign;
	short nBitsPerSample;
	short nExSize;
}WAVEFORMATX;

typedef struct
{
	char chRiffID[4];
	int nRiffSize;
	char chRiffFormat[4];
}RIFFHEADER;

typedef struct
{
	char chFmtID[4];
	int nFmtSize;
	WAVEFORMAT wf;
}FMTBLOCK;

#if defined __cplusplus
extern "C" {
#endif

// WAVE The audio sampling frequency is 8khz
// Audio sample unit number = 8000*0.02 = 160 (Determined by the sampling frequency)
// Track number 1 : 160
//              2 : 160*2 = 320
// bps = 8 --> 8位 unsigned char
//       16 --> 16位 unsigned short
int EncodeWAVEFileToAMRFile(const char* pchWAVEFilename, const char* pchAMRFileName, int nChannels, int nBitsPerSample);

// AMR decoding ->WAVE
int DecodeAMRFileToWAVEFile(const char* pchAMRFileName, const char* pchWAVEFilename);
#if defined __cplusplus
};
#endif

#endif
