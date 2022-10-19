
/*********************************************************************************
Copyright (c) 2021 Wavious LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*********************************************************************************/

// Word Address 0x00000000 : WAV_MCUINTF_HOST2MCU_MSG_DATA (RW)
`define WAV_MCUINTF_HOST2MCU_MSG_DATA_DATA_FIELD 31:0
`define WAV_MCUINTF_HOST2MCU_MSG_DATA_DATA_FIELD_WIDTH 32
`define WAV_MCUINTF_HOST2MCU_MSG_DATA_RANGE 31:0
`define WAV_MCUINTF_HOST2MCU_MSG_DATA_WIDTH 32
`define WAV_MCUINTF_HOST2MCU_MSG_DATA_ADR 32'h00000000
`define WAV_MCUINTF_HOST2MCU_MSG_DATA_POR 32'h00000000
`define WAV_MCUINTF_HOST2MCU_MSG_DATA_MSK 32'hFFFFFFFF

// Word Address 0x00000004 : WAV_MCUINTF_HOST2MCU_MSG_ID (RW)
`define WAV_MCUINTF_HOST2MCU_MSG_ID_ID_FIELD 31:0
`define WAV_MCUINTF_HOST2MCU_MSG_ID_ID_FIELD_WIDTH 32
`define WAV_MCUINTF_HOST2MCU_MSG_ID_RANGE 31:0
`define WAV_MCUINTF_HOST2MCU_MSG_ID_WIDTH 32
`define WAV_MCUINTF_HOST2MCU_MSG_ID_ADR 32'h00000004
`define WAV_MCUINTF_HOST2MCU_MSG_ID_POR 32'h00000000
`define WAV_MCUINTF_HOST2MCU_MSG_ID_MSK 32'hFFFFFFFF

// Word Address 0x00000008 : WAV_MCUINTF_HOST2MCU_MSG_REQ (W1T)
`define WAV_MCUINTF_HOST2MCU_MSG_REQ_REQ_FIELD 0
`define WAV_MCUINTF_HOST2MCU_MSG_REQ_REQ_FIELD_WIDTH 1
`define WAV_MCUINTF_HOST2MCU_MSG_REQ_RANGE 0:0
`define WAV_MCUINTF_HOST2MCU_MSG_REQ_WIDTH 1
`define WAV_MCUINTF_HOST2MCU_MSG_REQ_ADR 32'h00000008
`define WAV_MCUINTF_HOST2MCU_MSG_REQ_POR 32'h00000000
`define WAV_MCUINTF_HOST2MCU_MSG_REQ_MSK 32'h00000001

// Word Address 0x0000000C : WAV_MCUINTF_HOST2MCU_MSG_ACK (W1T)
`define WAV_MCUINTF_HOST2MCU_MSG_ACK_ACK_FIELD 0
`define WAV_MCUINTF_HOST2MCU_MSG_ACK_ACK_FIELD_WIDTH 1
`define WAV_MCUINTF_HOST2MCU_MSG_ACK_RANGE 0:0
`define WAV_MCUINTF_HOST2MCU_MSG_ACK_WIDTH 1
`define WAV_MCUINTF_HOST2MCU_MSG_ACK_ADR 32'h0000000C
`define WAV_MCUINTF_HOST2MCU_MSG_ACK_POR 32'h00000000
`define WAV_MCUINTF_HOST2MCU_MSG_ACK_MSK 32'h00000001

// Word Address 0x00000010 : WAV_MCUINTF_MCU2HOST_MSG_DATA (RW)
`define WAV_MCUINTF_MCU2HOST_MSG_DATA_DATA_FIELD 31:0
`define WAV_MCUINTF_MCU2HOST_MSG_DATA_DATA_FIELD_WIDTH 32
`define WAV_MCUINTF_MCU2HOST_MSG_DATA_RANGE 31:0
`define WAV_MCUINTF_MCU2HOST_MSG_DATA_WIDTH 32
`define WAV_MCUINTF_MCU2HOST_MSG_DATA_ADR 32'h00000010
`define WAV_MCUINTF_MCU2HOST_MSG_DATA_POR 32'h00000000
`define WAV_MCUINTF_MCU2HOST_MSG_DATA_MSK 32'hFFFFFFFF

// Word Address 0x00000014 : WAV_MCUINTF_MCU2HOST_MSG_ID (RW)
`define WAV_MCUINTF_MCU2HOST_MSG_ID_ID_FIELD 31:0
`define WAV_MCUINTF_MCU2HOST_MSG_ID_ID_FIELD_WIDTH 32
`define WAV_MCUINTF_MCU2HOST_MSG_ID_RANGE 31:0
`define WAV_MCUINTF_MCU2HOST_MSG_ID_WIDTH 32
`define WAV_MCUINTF_MCU2HOST_MSG_ID_ADR 32'h00000014
`define WAV_MCUINTF_MCU2HOST_MSG_ID_POR 32'h00000000
`define WAV_MCUINTF_MCU2HOST_MSG_ID_MSK 32'hFFFFFFFF

// Word Address 0x00000018 : WAV_MCUINTF_MCU2HOST_MSG_REQ (W1T)
`define WAV_MCUINTF_MCU2HOST_MSG_REQ_REQ_FIELD 0
`define WAV_MCUINTF_MCU2HOST_MSG_REQ_REQ_FIELD_WIDTH 1
`define WAV_MCUINTF_MCU2HOST_MSG_REQ_RANGE 0:0
`define WAV_MCUINTF_MCU2HOST_MSG_REQ_WIDTH 1
`define WAV_MCUINTF_MCU2HOST_MSG_REQ_ADR 32'h00000018
`define WAV_MCUINTF_MCU2HOST_MSG_REQ_POR 32'h00000000
`define WAV_MCUINTF_MCU2HOST_MSG_REQ_MSK 32'h00000001

// Word Address 0x0000001C : WAV_MCUINTF_MCU2HOST_MSG_ACK (W1T)
`define WAV_MCUINTF_MCU2HOST_MSG_ACK_ACK_FIELD 0
`define WAV_MCUINTF_MCU2HOST_MSG_ACK_ACK_FIELD_WIDTH 1
`define WAV_MCUINTF_MCU2HOST_MSG_ACK_RANGE 0:0
`define WAV_MCUINTF_MCU2HOST_MSG_ACK_WIDTH 1
`define WAV_MCUINTF_MCU2HOST_MSG_ACK_ADR 32'h0000001C
`define WAV_MCUINTF_MCU2HOST_MSG_ACK_POR 32'h00000000
`define WAV_MCUINTF_MCU2HOST_MSG_ACK_MSK 32'h00000001
