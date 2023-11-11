/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLRocAIX.aml, Thu Nov  9 22:25:13 2023
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000D0 (208)
 *     Revision         0x02
 *     Checksum         0x08
 *     OEM ID           "hack"
 *     OEM Table ID     "UHD620"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "UHD620", 0x00000000)
{
    External (_SB_.PCI0.GFX0, DeviceObj)

    Method (\_SB.PCI0.GFX0._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (!Arg2)
        {
            Return (Buffer (One)
            {
                 0x03                                             // .
            })
        }

        If (_OSI ("Darw15"))
        {
            Return (Package (0x04)
            {
                "device-id", 
                Buffer (0x04)
                {
                     0x16, 0x19, 0x00, 0x00                           // ....
                }, 

                "AAPL,ig-platform-id", 
                Buffer (0x04)
                {
                     0x02, 0x00, 0x26, 0x19                           // ..&.
                }
            })
        }

        Return (Package (0x04)
        {
            "device-id", 
            Buffer (0x04)
            {
                 0x16, 0x59, 0x00, 0x00                           // .Y..
            }, 

            "AAPL,ig-platform-id", 
            Buffer (0x04)
            {
                 0x02, 0x00, 0x26, 0x59                           // ..&Y
            }
        })
    }
}

