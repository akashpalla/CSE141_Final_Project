import sys

# map registers to binary (4-bit register inputs)
registers_four_bit = {
    "r0": "0000",
    "r1": "0001",
    "r2": "0010",
    "r3": "0011",
    "r4": "0100",
    "r5": "0101",
    "r6": "0110",
    "r7": "0111",
    "r8": "1000",
    "r9": "1001",
    "r10": "1010",
    "r11": "1011",
    "r12": "1100",
    "r13": "1101",
    "r14": "1110",
    "r15": "1111",
}

# map opcode to binary
opcode = {
    "add": "000",
    "sub": "001",
    "and": "010",
    "xor": "011",
    "cmp": "100",
    # "ceq": "101",
    "lsl": "110",
    "lsr": "111",
    "mov": "00",
    "load": "0",
    "store": "1",
    "jmp": "00",
    "jcnd": "01",
    "jcnd!": "10",
    "imm": "11",
    "nop": "011010000",
    "invert": "011010011",
    "clear": "011011111"
}

# classify instructions into different types
rtype = ['add', 'sub', 'and', 'xor', 'cmp', 'ceq', 'lsl', 'lsr']
btype = ['mov']
ctype = ['load', 'store']
dtype = ['jmp', 'jcnd', 'jcnd!', 'imm']
special_type = ['nop', 'invert', 'clear']


comment_char = '#'

with open("in.txt", "r") as read, open("simulation/modelsim/mach_code.txt", "w") as write:
    # read lines from input file
    lines = read.readlines()

    for line in lines:
        # strip takes away whitespace from left and right
        line = line.strip()

        # split comments out
        line = line.split(comment_char, 1)
        inst = line[0].strip()
        comment = line[1].strip() if len(line) > 1 else ""

        # split instruction into arguments
        inst = inst.split()

        # initialize the string that contains the machine code binary
        writeline = ''

        # write the opcode
        if inst[0] in opcode:
            # Determine instruction type and format accordingly
            if inst[0] in special_type:
                writeline += opcode[inst[0]]
            elif inst[0] in rtype:
                # Type A: 2-bit type (00), 3-bit opcode, 4-bit register input
                writeline += '01' + opcode[inst[0]] + registers_four_bit[inst[1]]
            elif inst[0] in btype:
                # Type B: 1-bit type (1), 4-bit output register, 4-bit input register
                writeline += '1' + registers_four_bit[inst[1][0:-1]] + registers_four_bit[inst[2]]
            elif inst[0] in ctype:
                # Type C: 4-bit type (0001), 1-bit opcode, 4-bit register input
                writeline += '0001' + opcode[inst[0]] + registers_four_bit[inst[1]]
            elif inst[0] in dtype:
                # Type D: 3-bit type (001), 2-bit opcode, 4-bit LUT
                writeline += '001' + opcode[inst[0]] + format(int(inst[1]), '04b')
            else:
                # If it is an instruction that doesn't exist, exit
                sys.exit("Unknown instruction 1")
        else:
            sys.exit("Unknown instruction 2")

        # SystemVerilog ignores comments prepended with // with readmemb or readmemh
        writeline += ' //' + comment if comment else ''
        writeline += '\n'

        # write the line into the desired file
        write.write(writeline)
