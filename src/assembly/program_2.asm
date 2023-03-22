###############################################################################
# Program 2 Assembly
###############################################################################
#
###############################################################################
# Pseudocode:
#
# p1	p2	1	p4	2	3	4	p8	5	6	7	8	9	10	11
#
# - Let S8, S4, S2, S1, S0 be parity calculated from input
#
# - For each message
#	- Read message from data memory
#	- Create p = {S8, S4, S2, S1}
#	- If S0 == 0: 0 or 2 errors
#		- Extract and store LSW
#		- Extract MSW to register
#		- If p == 0:
#			- 0 errors; do nothing
#		- Else (p != 0):
#			- 2 errors; set bit
#		- Store MSW
#	- Else (S0 != 0): 1 error
#		- Flip pth bit in input
#			- input ^ (1 << p)
#			- Note: input is split between 2 bytes, so more complicated.
#				- < 8:  LSW ^ (1 << p)
#				- else: MSW ^ (1 << (p & 0b111))
#		- Extract data bits to output
#			- Flip F0 bit in MSW
#		- Store output
###############################################################################
# Register layout:
# 0: Scratch register
# 1:
# 2: Working output MSW
# 3: p = {S8, S4, S2, S1}
# 4: In LSW
# 5: In MSW
# 6: Input address [30, 60)
# 7: Output address [0, 30)
###############################################################################

###########################################################


# Initialize r6
loadv	i 7	# 0
sl	i 2
or	i 2
storev	r 6
# Initialize r7
loadv	i 0	# 4
storev	r 7

# NOP sled
add	i 0
add	i 0
add	i 0	# 8
add	i 0
add	i 0
add	i 0

# Loop through messages:
# Address: (12 >> 2 = 3)

	## Read message
	# LSW
	loadm	r 6
	storev	r 4
	# Increment address to get MSW address
	loadv	r 6
	add	i 1
	storev	r 6
	# MSW
	loadm	r 6
	storev	r 5
	# Increment address to get next message address
	loadv	r 6
	add	i 1
	storev	r 6

	## Extract p = {S8, S4, S2, S1}
	# S8
	loadv	r 5
	dxor	i 0
	sl	i 3
	storev	r 3
	# S4
	loadv	r 5
	xp4	r 4
	dxor	i 0
	sl	i 2
	or	r 3
	storev	r 3
	# S2
	loadv	r 5
	xp2	r 4
	dxor	i 0
	sl	i 1
	or	r 3
	storev	r 3
	# S1
	loadv	r 5
	xp1	r 4
	dxor	i 0
	or	r 3
	storev	r 3

	## Extract S0
	loadv	r 5
	dxor	r 4

	## If S0 == 0: 0 or 2 errors
	beq	i 6	# Skip jumping over true branch
	# TODO: update number
	loadv	i 3	# Load number of instructions to
	sl	i 3	# skip over true branch
	or	i 2	# (26 instructions)
	storev	r 0
	add	i 0	# NOP maybe neccesary for memory to update
	rb	r 0	# Jump over true branch

	## True branch (0 or 2 errors) (26 instructions)
		# Extract and store LSW
		loadv	r 5
		dlsw	r 4
		storem	r 7
		# Increment address to get MSW address
		loadv	r 7
		add	i 1
		storev	r 7

		# Extract MSW to register 2
		loadv	r 5
		dmsw	r 4
		storev	r 2

		# If p != 0: 2 errors, set bit
		# (if p == 0, skip branch)
		loadv	r 3	# load p
		beq	i 5

		## 2 errors: set bit (3 instructions)
			loadv	i 1
			sl	i 7
			or	r 2
			storev	r 2
			add	i 0	# NOP for memory safety
		
		# Store MSW
		loadv	r 2
		storem	r 7
		# Increment address to get next message address
		loadv	r 7
		add	i 1
		storev	r 7

		# Skip over false branch
		# TODO: Number of instructions may be wrong
		loadv	i 7	# Load number of instructions to
		sl	i 2	# skip over false branch
				# (28 instructions)
		storev	r 0
		add	i 0	# NOP maybe neccesary for memory to update
		rb	r 0	# Jump over false branch
	
	## False branch (1 error) (28 instructions)

		## Flip pth bit in input

		# p < 8:  LSW ^ (1 << p)
		#	If p >= 8, shifts to nothing.
		loadv	i 1	# Shifts a bit by p
		sl	r 3
		#
		xor	r 4	# XORs LSW with shifted bit
		storev	r 4	# Stores LSW

		# p >= 8: MSW ^ (1 << (p >> 3))
		# 	Invert S8 before shifting
		loadv	i 1
		sl	i 3
		xor	r 3	# Invert S8
		storev	r 0
		#
		loadv	i 1	# Shifts a bit by p (inverted S8)
		sl	r 0
		#
		xor	r 5	# XORs MSW with shifted bit
		storev	r 5	# Stores MSW

		## Extract and store LSW
		loadv	r 5
		dlsw	r 4
		storem	r 7
		# Increment address to get MSW address
		loadv	r 7
		add	i 1
		storev	r 7

		## Extract, flip F0 bit, and store MSW
		loadv	r 5	# Extract MSW
		dmsw	r 4
		storev	r 2
		#
		loadv	i 1	# Load bit to flip
		sl	i 6
		#
		xor	r 2	# Flip bit in MSW
		storem	r 7
		# Increment address to get next message address
		loadv	r 7
		add	i 1
		storev	r 7

	## NOPs for debugging
	add	i 0
	add	i 0
	add	i 0
	add	i 0
	add	i 0

	## Branching
	# Increment addresses (Temporary, will be done when accessing memory)
	# In
	# loadv	r 6
	# add	i 1
	# storev	r 6
	# Out
	#loadv	r 7
	#add	i 2
	#storev	r 7
	# Compare and branch
	loadv	i 7
	sl	i 2
	or	i 2
	xor	r 7
	#
	beq	i 1
	ab	i 3	#

# Temporary thing
done i 7