# PipeLine-Implementation

### The processor support the following instructions:

- Data processing instructions where the second source can be either an
immediate value or a source register, with no shifts. The data processing
instructions must include ADD, SUB, AND, ORR, BIC, and EOR. The
Arithmetic Logic Unit (ALU) must be extended to support all these
instructions but try to minimize the number of logic gates in the ALU as much
as you can.
  - The LDR and STR instructions with positive immediate offset (offset mode).
  - Branch instruction

Also, the processor handle the following hazards:
- Read After Write (RAW) Hazard
- LDR Hazard
- Control Hazards due to Branch or PC write
