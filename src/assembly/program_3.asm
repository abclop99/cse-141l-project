# Program 3: Pattern Matching

# 0: Scratch
# 1: Counter
# 2: Current/left byte
# 3: Next/right byte
# 4: Bit pattern
# 5: Data memory address (loop index)(changes in middle of loop)
# 6: Inner loop index
# 7: Message end address = 32 (also used for other things)

# Message string: mem[0:31]
# 5-bit pattern: mem[32][7:3]
# Outputs:
#   mem[33]: occurences of pattern (no crossing byte boundaries)
#   mem[34]: number of bytes with pattern
#   mem[35]: total occurences including byte boundaries

### Initialize Registers
# Set message end address (bit pattern address) (32)
loadv	i 1	# 0
sl	i 5
storev	r 7

# Initialize counters in data memory to 0 (33:35)
# 32 currently in memory
add	i 1	#	33
storev	r 0	# 4
loadv	i 0
storem	r 0
#
loadv	r 0
add	i 1	# 8	34
storev	r 0
loadv	i 0
storem	r 0
#
loadv	r 0	# 12
add	i 1	#	35
storev	r 0
loadv	i 0
storem	r 0	# 16

# Load bit pattern
loadm	r 7
storev	r 4

# Set initial data memory address
loadv	i 0
storev	r 5	# 20

# Set Counter
loadv	i 0
storev	r 1

# Load current byte
loadm	r 5
storev	r 2	# 24

# NOPs
add	i 0	# 25
add	i 0	# 26
add	i 0	# 27

#### Loop: (28 >> 2 = 7)

	### Match within byte; 4 tests

	# Set inner loop index
	loadv	i 4	# 28
	storev	r 6
	# NOP
	add i 0
	add i 0

	## Inner Loop: (32 >> 2 = 8 (can't branch in single instruction.))

		# Test for pattern first time in byte
		# Current byte is already loaded in acc
		loadv	r 2
		xor	r 4	#	XOR with bit pattern
		beq	i 1	#	Skip skipping add if matches
		rb	i 3	#		Skip adding to count
		# Add to count
		loadv	r 1
		add	i 1
		storev	r 1

		# Decrement inner loop index; if !0, set&shift byte and loop
		loadv	r 6
		sub	i 1
		storev	r 6
		beq	i 7	#	If end of loop, skip looping
		# shift current byte
		loadv	r 2
		sl	i 1
		storev	r 2
		# ab to 8 << 2 = 32
		loadv	i 1
		sl	i 3
		storev	r 0
		ab	r 0

	## Update byte-wise counters
	# Add to occurences in byte (Mem[33])
	loadv	r 7	#	(32)
	add	i 1	#	(33)
	storev	r 0
	loadm	r 0	#	(Mem[33])
	add	r 1	#	Add count
	storem	r 0	#	Store back to Mem[33]
	# If count != 0: increment bytes with pattern (Mem[34])
	loadv	r 7	#	(32)
	add	i 2	#	(34)
	storev	r 0
	loadv	r 1	#	Load byte count
	xor	i 0	#	Compare with 0
	beq	i 3	#	Skip increment if 0
	loadm	r 0	#	Mem[34]
	add	i 1
	storem	r 0	#	Store back to Mem[34]

	## Increment data address/loop index
	loadv	r 5
	add	i 1
	storev	r 5

	## break if reached end of loop (no next byte)
	# if (r5 == r7): add to counter in memory and done
	xor	r 7
	beq	i 1
	rb	i 7
	# Add to Mem[35]
	loadv	r 7	# Load and store address
	add	i 3
	storev	r 0
	#
	loadm	r 0	# Increment data mem at address
	add	r 1
	storem	r 0
	done	i 7

	## Load next byte
	loadm	r 5
	storev	r 3

	## Test for byte pattern across byte boundaries
	# 4 tests, unrolled loop (easier this way)

		## First test
		#          |76543|210
		# 0:       | 7654|321
		# 1: 765432|1    |
		loadv	r 2	# Load, shift, and store next byte
		sr	i 1
		storev	r 0
		#
		loadv	r 3	# Load and shift current byte
		sl	i 7
		or	r 0	# Combine with shifted next byte
		xor	r 4	# Compare with pattern
		#
		beq	i 1	# Skip skipping if match
		rb	i 3	#	Skip adding
		#
		loadv	r 1	# count++
		add	i 1
		storev	r 1

		## Second test
		#         |76543|210
		# 0:      |  765|4321
		# 1: 76543|21   |
		loadv	r 2	# Load, shift, and store next byte
		sr	i 2
		storev	r 0
		#
		loadv	r 3	# Load and shift current byte
		sl	i 6
		or	r 0	# Combine with shifted next byte
		xor	r 4	# Compare with pattern
		#
		beq	i 1	# Skip skipping if match
		rb	i 3	#	Skip adding
		#
		loadv	r 1	# count++
		add	i 1
		storev	r 1

		## Third test
		#        |76543|210
		# 0:     |   76|54321
		# 1: 7654|321  |
		loadv	r 2	# Load, shift, and store next byte
		sr	i 3
		storev	r 0
		#
		loadv	r 3	# Load and shift current byte
		sl	i 5
		or	r 0	# Combine with shifted next byte
		xor	r 4	# Compare with pattern
		#
		beq	i 1	# Skip skipping if match
		rb	i 3	#	Skip adding
		#
		loadv	r 1	# count++
		add	i 1
		storev	r 1

		## Fourth test
		#       |76543|210
		# 0:    |    7|654321
		# 1: 765|4321 |
		loadv	r 2	# Load, shift, and store next byte
		sr	i 4
		storev	r 0
		#
		loadv	r 3	# Load and shift current byte
		sl	i 4
		or	r 0	# Combine with shifted next byte
		xor	r 4	# Compare with pattern
		#
		beq	i 1	# Skip skipping if match
		rb	i 3	#	Skip adding
		#
		loadv	r 1	# count++
		add	i 1
		storev	r 1

		## Update counter in memory
		# Add to Mem[35]
		loadv	r 7	# Load and store address
		add	i 3
		storev	r 0
		#
		loadm	r 0	# Increment data mem at address
		add	r 1
		storem	r 0

	## Reset counter to 0
	loadv	i 0
	storev	r 1

	# Branch to beginning of loop
	ab	i 7