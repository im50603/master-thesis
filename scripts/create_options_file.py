import re

fin = open(snakemake.input[0], 'rt')
fout = open(snakemake.output[0], 'wt')

# get {sample}
# parts = snakemake.input[1].split('/')
# sample = parts[-1]
# parts = sample.split('.')
# sample = parts[0]
sample = snakemake.wildcards.sample

for line in fin:
    new_line = line.replace('{PATH_TO_DATA}/', '/storage2/imartinovic/data/')
    new_line = new_line.replace('{FILENAME}', sample)
    fout.write(new_line)

fin.close()
fout.close()


