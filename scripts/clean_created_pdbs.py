import os

final_lines = []
with open(snakemake.input[0]) as f:
    lines = f.readlines()
    for line in lines:
        if line.startswith('HEADER') or line.startswith('EXPDTA') or line.startswith('REMARK') or line.startswith('TER'):
            final_lines.append(line)
            continue
        parts = line.split()
        if len(parts) == 0:
            final_lines.append(line)
            continue
        if len(parts[-1]) == 0:
            final_index = -2
        else:
            final_index = -1
        if parts[0] == 'ATOM':
            if parts[final_index] == 'H' or parts[2] == 'OXT':
                continue
            final_lines.append(line)

# index = snakemake.output[0].find(snakemake.params.sample_name)
# sample_dir = snakemake.output[0][:index]
# CHECK_FOLDER = os.path.isdir(sample_dir)
#
# # If folder doesn't exist, then create it.
# if not CHECK_FOLDER:
#     os.makedirs(sample_dir)

with open(snakemake.output[0], 'w') as f:
    for line in final_lines:
        f.write(line)



