// (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
////////////////////////////////////////////////////////////
#ifndef _V_DEMOSAIC_H_
#define _V_DEMOSAIC_H_

#include "hls_video.h"
#include "ap_int.h"

typedef unsigned char      U8;
typedef unsigned short     U16;
typedef unsigned int       U32;
typedef ap_uint<1>         U1;
typedef ap_uint<6>         U6;
typedef ap_uint<MAX_DATA_WIDTH>     U_DW;
typedef ap_uint<MAX_DATA_WIDTH+3>   U_DW_3;

typedef signed char        I8;
typedef signed short       I16;
typedef signed int         I32;

typedef ap_int<MAX_DATA_WIDTH+1>    DW_plus1;
typedef ap_int<MAX_DATA_WIDTH+2>    DW_plus2;
typedef ap_int<MAX_DATA_WIDTH+3>    DW_plus3;
typedef ap_int<MAX_DATA_WIDTH+4>    DW_plus4;
typedef ap_int<MAX_DATA_WIDTH+5>    DW_plus5;
typedef ap_int<MAX_DATA_WIDTH+6>    DW_plus6;

// Bayer phases
#define RGRG                    0
#define GRGR                    1
#define BGBG                    2
#define GBGB                    3

#define R_CH    2
#define G_CH    0
#define B_CH    1

#define MAX(a,b)    ((a)>(b)?(a):(b))

typedef ap_uint<MAX_DATA_WIDTH>                                     PIXEL_TYPE;
typedef hls::Scalar<NR_COMPONENTS, PIXEL_TYPE>                      YUV_PIXEL;
typedef ap_uint<MAX_DATA_WIDTH>                                     BAYER_PIXEL;
typedef ap_uint<NR_COMPONENTS*SAMPLES_PER_CLOCK*MAX_DATA_WIDTH>     MEM_PIXEL_TYPE;
typedef ap_uint<SAMPLES_PER_CLOCK*MAX_DATA_WIDTH>                   BAYER_MEM_PIXEL_TYPE;
typedef hls::Scalar<NR_COMPONENTS*SAMPLES_PER_CLOCK, PIXEL_TYPE>    YUV_MULTI_PIXEL;
typedef hls::Scalar<SAMPLES_PER_CLOCK, PIXEL_TYPE>                  BAYER_MULTI_PIXEL;

typedef hls::stream<ap_axiu<IN_BITS_PER_CLOCK,1,1,1> >              AXI_STREAM_IN;
typedef hls::stream<ap_axiu<OUT_BITS_PER_CLOCK,1,1,1> >             AXI_STREAM_OUT;
typedef hls::stream<BAYER_MULTI_PIXEL>                              STREAM_MULTIBAYER;
typedef hls::stream<YUV_MULTI_PIXEL>                                STREAM_MULTIPIX;

//Static functions
#define BAYER_KERNEL_H_SIZE 5
#define BAYER_KERNEL_V_SIZE 5
#define BAYER_KERNEL_WIDTH                                                        MAX((BAYER_KERNEL_H_SIZE/2+2*SAMPLES_PER_CLOCK),BAYER_KERNEL_H_SIZE)
typedef hls::Window<BAYER_KERNEL_V_SIZE, BAYER_KERNEL_WIDTH, BAYER_PIXEL>         BAYER_WINDOW;

//HW Registers
typedef struct
{
    U16 width;
    U16 height;
//    U16 video_format;
    U16 bayer_phase;
}HW_STRUCT_REG;

// top level function for HW synthesis
void v_demosaic( U16 width, U16 height, U16 bayer_phase,
        AXI_STREAM_IN& s_axis_video,
        AXI_STREAM_OUT& m_axis_video
);

#endif


