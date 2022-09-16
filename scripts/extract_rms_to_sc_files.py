
scores = {}
first = True
with open(snakemake.input[0]) as fin:
    lines = fin.readlines()
    for line in lines:
        if line.startswith('SCORE'):
            if first:
                first = False
                continue
            parts = line.rstrip().split()
            name = parts[-1]
            rms = parts[-6]
            scores[name] = rms

outputs = snakemake.output
for o in outputs:
    parts = o.split('/')
    filename = parts[-1]
    parts = filename.split('.')[0].split('-')
    name = parts[1]
    description = o.split('/')[-1] .split('.')[0]
    with open(o, 'w') as fout:
        fout.write('SCORE:\trms\trms_2\tdescription\n')
        line = 'SCORE:\t' + scores[name] + '\t' + scores[name] + '\t' + description + '.pdb\n'
        fout.write(line)
        fout.write(line)


