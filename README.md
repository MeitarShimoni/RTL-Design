# 8-bit Adder in Verilog: Behavioral vs. Structural

This project, part of the **Google & Reichman Tech School Chip Design & Verification** course, implements and compares two versions of an 8-bit adder.

1.  **Behavioral Implementation (`FA_behav.sv`):** A high-level, abstract model using Verilog's `+` operator.
2.  **Structural Implementation (`Top_RCA.sv`):** A low-level, "flat" Ripple-Carry Adder (RCA) built by manually instantiating 8 1-bit `Full_Adder` modules.

The goal is to verify that both are functionally identical and to compare their synthesized hardware implementation in Vivado.

---

## 🚀 Key Features
- **Behavioral vs. Structural Design** – Compares two fundamental RTL design methodologies.
- **Bottom-Up Structural Build** – Demonstrates a classic Ripple-Carry Adder (RCA) architecture.
- **Shared Testbench Verification** – A single testbench (`tb_Top_RCA.sv`) validates both designs simultaneously.
- **Assertion-Based Verification** – Uses SystemVerilog `assert` statements to confirm functional correctness for test cases[cite: 39].
- **Synthesis & Resource Comparison** – Analyzes Vivado reports to compare the final hardware (LUT usage) for both styles[cite: 62, 64].

---

## 🖥 Design Architecture
The project consists of two separate adder designs (DUTs) that are instantiated in parallel.

1.  **Structural (RCA) Path:**
    * Based on a 1-bit `Full_Adder` module using logic gates.
    * The `Top_RCA` module instantiates this `Full_Adder` 8 times.
    * The `Cout` of each adder is "rippled" to the `Cin` of the next, creating the carry chain.

2.  **Behavioral Path:**
    * Implemented in a single module (`FA_behav.sv`).
    * Uses one line of code: `assign {cout, sum} = a + b + cin;`
    * This high-level description lets the synthesis tool (Vivado) infer the optimal hardware implementation.

---

## 🛠 Vivado RTL Schematics
These diagrams (from "Elaborated Design") show how Vivado interpreted the Verilog code for each design *before* optimization.

**Structural RCA Schematic**
This schematic perfectly matches our manual block diagram, showing the 8 `Full_Adder` instances and the carry chain.
![Vivado Structural Schematic](images/structural_lint_design.png)

**Behavioral Adder Schematic**
This schematic shows the synthesizer inferred two `RTL_ADD` blocks to handle the 8-bit addition and the final carry-out logic.
![Vivado Behavioral Schematic](images/behavioral_lint_design.png)

---

## 📊 Simulation Results
A shared testbench (`tb_Top_RCA.sv`) was used to run 5 directed test cases.

**Simulation Waveform (Snapshot)**
*(הערה: העלה לכאן את צילום המסך של גלי הסימולציה שלך)*
![Simulation Waveform](images/simulation_waveform.png)

**Console Output**
The `$monitor` output confirms that for every test case, the results from the behavioral (`beh`) and structural (`struc`) adders are identical. All assertions passed. [cite: 52]

```tcl
Time resolution is 1 ps
Time:                    0 | a:   0 | b:   0 | beh sum:   0 | beh cout: 0| struc sum:   0 | struc cout: 0
Time:                10000 | a:   5 | b:   3 | beh sum:   8 | beh cout: 0| struc sum:   8 | struc cout: 0
ASSERT 1 : No Carry-out SUCCEED!
Time:                20000 | a: 192 | b:  64 | beh sum:   0 | beh cout: 1| struc sum:   0 | struc cout: 1
ASSERT 2 : No Carry-out SUCCEED!
Time:                30000 | a:  15 | b: 240 | beh sum: 255 | beh cout: 0| struc sum: 255 | struc cout: 0
ASSERT 3 : no carry_out, max value SUCCEED!
Time:                40000 | a: 255 | b: 255 | beh sum: 255 | beh cout: 1| struc sum: 255 | struc cout: 1
ASSERT 4 : max overflow SUCCEED!
Time:                50000 | a: 120 | b:  56 | beh sum: 176 | beh cout: 0| struc sum: 176 | struc cout: 0
ASSERT 5 : no carry-out SUCCEED!
SIMULATION COMPLETED SUCCESSFULLY!
