# Quiz2 Problem A
.data
    multiplier: .word -9
    multiplicand: .word 7
    result: .word 0

# .text
#     la a0, multiplier         # Load multiplier address
#     lw a1, 0(a0)              # Load multiplier value
#     la a2, multiplicand       # Load multiplicand address
#     lw a3, 0(a2)              # Load multiplicand value
#     li t0, 0                  # Initialize accumulator
#     li t1, 32                 # Set bit counter (#A01)

#     # Check for negative values
#     bltz a1, handle_negative1 # If multiplier negative (#A02)
#     j shift_and_add_loop      # Skip to main loop (#A05)
#     bltz a3, handle_negative2 # If multiplicand negative (#A03)
#     j shift_and_add_loop      # Continue to main loop (#A04)

# handle_negative1:
#     neg a1, a1                # Make multiplier positive

# handle_negative2:
#     neg a3, a3                # Make multiplicand positive

# shift_and_add_loop:
#     beqz t1, end_shift_and_add # Exit if bit count is zero
#     andi t2, a1, 1            # Check least significant bit (#A06)
#     beqz t2, skip_add         # Skip add if bit is 0
#     add t0, t0, a3            # Add to accumulator

# skip_add:
#     srai a1, a1, 1            # Right shift multiplier
#     slli a3, a3, 1            # Left shift multiplicand
#     addi t1, t1, -1           # Decrease bit counter
#     j shift_and_add_loop      # Repeat loop (#A07)

# end_shift_and_add:
#     la a4, result             # Load result address
#     sw t0, 0(a4)              # Store final result (#A08)
#     ecall
.text
    lui a0, %hi(multiplier)      # Load the upper 20 bits of multiplier address
    addi a0, a0, %lo(multiplier) # Add the lower 12 bits to complete the address
    lw a1, 0(a0)                 # Load multiplier value

    lui a2, %hi(multiplicand)    # Load the upper 20 bits of multiplicand address
    addi a2, a2, %lo(multiplicand) # Add the lower 12 bits
    lw a3, 0(a2)                 # Load multiplicand value

    # Initialize accumulator (t0 = 0)
    lui t0, 0                    # Load upper 20 bits (0) into t0
    addi t0, t0, 0               # Add lower 12 bits (0) to t0

    # Initialize bit counter (t1 = 32)
    lui t1, 0                    # Load upper 20 bits (0) into t1
    addi t1, t1, 32              # Add lower 12 bits (32) to t1

    # Check for negative values
    bltz a1, handle_negative1    # If multiplier negative, go to handle_negative1
    j shift_and_add_loop         # Skip to main loop
    bltz a3, handle_negative2    # If multiplicand negative, go to handle_negative2
    j shift_and_add_loop         # Continue to main loop

handle_negative1:
    add t2, zero, zero           # t2 = 0
    sub a1, t2, a1               # a1 = 0 - a1
    j shift_and_add_loop         # Jump back to main loop

handle_negative2:
    add t2, zero, zero           # t2 = 0
    sub a3, t2, a3               # a3 = 0 - a3
    j shift_and_add_loop         # Jump back to main loop

shift_and_add_loop:
    beqz t1, end_shift_and_add   # Exit if bit count is zero
    andi t2, a1, 1               # Check least significant bit of a1
    beqz t2, skip_add            # Skip add if bit is 0
    add t0, t0, a3               # Add a3 to accumulator (t0)

skip_add:
    srai a1, a1, 1               # Right shift a1 (logical shift)
    slli a3, a3, 1               # Left shift a3
    addi t1, t1, -1              # Decrement bit counter
    j shift_and_add_loop         # Repeat loop

end_shift_and_add:
    lui a4, %hi(result)          # Load the upper 20 bits of result address
    addi a4, a4, %lo(result)     # Add the lower 12 bits
    sw t0, 0(a4)                 # Store accumulator (t0) in result
    ecall



