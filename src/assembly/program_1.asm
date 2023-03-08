# The assembly for the first program required for this project.

# Registers usages:
# 0:	Input LSW
# 1:	Input MSW
# 2:	Output LSW
# 3:	Output MSW
# 4:	Input addresses
# 5:	Output addresses
# ~~6:	Loop instruction addresses~~ (not used, static value 8 >> 2 = 2)
# 7:	Loop limit (30)

# Set initial input/output data addresses
loadv	i 0	# 0
storev	r 4
loadv	i 3	#	(load 30)
sl	i 3
or	i 6	# 4
storev	r 5

# Set loop limit (30, same as initial MSW address)
loadv	r 5
storev	r 7

# Loop (8 >> 2 = 2)

# Load data
loadm	r 4	# 8	Load LSW
storev	r 0
#
loadv	r 4	#	Increment input address to get MSW address
add	i 1
storev	r 4	# 12
#
loadm	r 4	#	Load MSW
storev	r 1

# Set data bits in outputs
# loadv	r 1	#	LSW
elsw	r 0
storev	r 2
#
loadv	r 1	#	MSW
emsw	r 0
storev	r 3

# p8	(MSW still in acc)
dxor	i 0
or	r 3
storev	r 3

# p4	(MSW still in acc)
xp4	r 2
dxor	i 0
sl	i 4
or	r 2
storev	r 2

# p2
loadv	r 3
xp2	r 2
dxor	i 0
sl	i 2
or	r 2
storev	r 2

# p1
loadv	r 3
xp1	r 2
dxor	i 0
sl	i 1
or	r 2
storev	r 2

# p0
loadv	r 3
dxor	r 2
or	r 2
storev	r 2

# Store
loadv	r 2	#	Store LSW
storem	r 5
#
loadv	r 5	#	Increment output address to get MSW
add	i 1
storev	r 5
#
loadv	r 3	#	Store MSW
storem	r 5

# Increment addresses (by 1; already incremented once)
loadv	r 5
add	i 1
storev	r 5
#
loadv	r 4
add	i 1
storev	r 4

# Loop branching
# Note: r4 is still in the accumulator
xor	r 7
beq	i 1	# Skip next instruction if reached end
ab	i 2

done	i 7
