# SINGLE_CYCLE     :  WITHOUT FSM (MSOTLY GENRIC MODULE CREATED).
# MULTICYCLE MEANS :  WITH FSM (MOSTLY CASES USED).

# Single-cycle arbiter:
➤ "Typically implemented without an FSM; often uses purely combinational logic or a generic module with generate/for loops. Makes grant decisions in one clock cycle."

# Multi-cycle arbiter:
➤ "Usually implemented with an FSM (e.g., using case statements) to manage arbitration across multiple clock cycles, especially when handling complex protocols or many requesters."
