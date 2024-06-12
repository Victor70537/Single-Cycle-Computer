#dirty script to parse output.lst and just get the instructions

#open file and read in all lines
with open('output.lst') as f:
    lines = f.readlines()
f.close()

#parse each line via whitespace and then remove the ":"
inst = []
for line in lines:
    values = line.split()
    values = values[2].split(':')
    inst.append(values[0])

#write to output.txt
with open('output.txt', "w") as f:
    for i in inst:
        if (i != inst[-1]): #add newline execpt last line
            i += " "
        f.write(i)
    f.close
print(len(lines),"x32Bit address spaces required")