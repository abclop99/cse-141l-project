# Simple loop

# i = 0
# loop:
# i++
# if i == 7, branch over next instruction
# branch loop
# done

loadv	i 0	# 0
storev	r 0	# 1
add	i 0	# 2 (nop)
add	i 0	# 3 (nop)

# Loop:

loadv	r 0	# 4
add	i 1	# 5
storev	r 0	# 6

xor	i 7	# 7
beq	i 1	# 8
ab	i 1	# 9
done	i 7	# 10	 i 7 is stylistic so the binary is all 1s