SAMPLES = ['1DDNA', '1DEWA', '1L3XA', '1LATA', '1U9GA', '2B2EA', '2BCBA', '2BCDA', '2BCQA', '2R8GA', '2R9BA', '2RHIA', '2RLKA', '3ERYA', '3EWFA', '3EXBA', '3EXLA', '3EY1A', '3FBDA', '3PY8A', '3Q2PA', '4F4SA', '4F6MA', '4F8DA', '4FBXA', '4FGNA', '5GMVB', '5GU4A', '5T2HA', '6JN0A', '9ICKA'] # ignored: '4F8RA',  .... failed: '5GMGA', '3F73A','2RE8A', '5T7BA', '3Q8PB', '7U73A', '3Q4KA', '1L2DA', '2BD4A', '2RDLA', '2RD4A', '4FGAA', '1L1VB', '4FGXA', '1U9EA', '1L6OA', '4FGTA', '2R7VA', '2RD4B',  '3Q0NA',  

#SAMPLES = ['1A32A', '1A43A', '1A70A', '1A91A', '1CNRA', '1AB3A', '1BTBA', '1ABQA', '1AE2A', '1AEYA', '1BV2A', '1AG6A', '1AHOA', '5DSUA', '1AMEA', '1AP4A', '1B5BA', '1AZHA', '5D8VA', '5AI3A', '1B5MA', '1B6QA', '1B75A', '1BDDA', '1BH0A', '7RN3A', '1BMGA', '1BO0A', '1C54A', '7PTIA', '1BQTA', '1BT0A', '1C3TA', '7O2KA', '1CISA', '1CM3A', '1CMGA', '1CNLA', '1COIA', '6QJKA', '6SHRA', '6SVCA', '4XDXA', '4YDXA', '4YOBA', '4ZYFA', '5BMIA', '5C02A', '5CN0A', '5DKQA', '5EBXA'] # '1AZ5A','6SZZA', '1BODA', '1C4DA', '1A8OA', '1A7YA', '7PDIA', '1BA6A',  

VAL = ['1AMEA', '1C54A', '1AP4A', '5C02A', '6SHRA', '7O2KA', '7PTIA', '1A70A', '4XDXA', '1A32A']
TRAIN = [x for x in SAMPLES if x not in VAL]

#SAMPLES_ALL = ['1GHLA', '1N36P', '3AXLB', '3OTOQ', '5JYIA', '6TQNE', '7K4MB', '7SR9B', '1N36F', '1N36T', '3CB9A', '3OTOS', '5TBBA', '6U421', '7KKLB', '1N36H', '1X18E', '3IA3B', '3TLRA', '6G5BA', '6W51A', '7LX5B', '1N36I', '1X18F', '3OTOD', '3WKJD', '6MUPB', '6YHSC', '7OJXC', '1N36K', '210LA', '3OTOE', '4KQ4L', '6NJ2A', '6YR8A', '7QGHP', '1N36L', '2NZDC', '3OTOJ', '4M8YA', '6PZEL', '7CBTA', '7S0EH', '1N36M', '2V22A', '3OTOO', '5DX4A', '6SPBD', '7JILr', '7S1KR']
     #["2WIHA"] #,"3TLRA", "1N36H"] # ["2LZMA", "2jsvX"]
#SAMPLES = ['6TQOC'] #['3CBEA', '3OTOG']  #['1I91A', '3SCMD', '1H8DH', '1BPEA', '1N36B']
    #['1GHLA', '1N36P', '3OTOQ', '1N36T', '3OTOS', '6U421', '7KKLB', '1N36H', '3IA3B', '7LX5B', '3WKJD', '6MUPB', '7OJXC', '3OTOE', '4KQ4L', '7QGHP', '1N36L', '2NZDC', '3OTOJ', '4M8YA', '7CBTA', '7S0EH', '5DX4A', '6SPBD', '7JILr', '7S1KR', '6M2KA', '209LA'] # izbaceni '5TBCA' i '3UOPA' i '3RUGF', dodana zadnja dva - dodaj '1N36M' kad dodas frag

num_examples = 50
FINAL_NAMES = ['S_%08d' % i for i in range(1, num_examples + 1)] # for minirosetta %05, for abinitio %08
initial_path = '/storage2/imartinovic/'
SEEDS = [i for i in range(20)]

rule all:
    input:
        expand("../data/scores/{sample}_{seed}-{name}.sc", sample=SAMPLES, name=FINAL_NAMES, seed=SEEDS),
        expand("../data/final_structures/{sample}/{seed}-{name}.pdb", sample=SAMPLES, name=FINAL_NAMES, seed=SEEDS)
        #expand("../data/train/{sample}_{seed}-{name}.pdb", sample=TRAIN, name=FINAL_NAMES, seed=SEEDS),
        #expand("../data/val/{sample}_{seed}-{name}.pdb", sample=VAL, name=FINAL_NAMES, seed=SEEDS)

rule prepare_for_fragment_creation:
    input:
        "../data/fasta_files/{sample}.fasta"
    output:
        "tmp/{sample}/{sample}.fasta"
    shell:
        "cp {input} {output}"

rule create_fragments:
    input:
        "tmp/{sample}/{sample}.fasta"
    output:
        "tmp/{sample}/{sample}.200.3mers",
        "tmp/{sample}/{sample}.200.9mers",
        "tmp/{sample}/{sample}.checkpoint"
    params:
        extension="fasta"
    shell:
        "scripts/create_fragments.sh {wildcards.sample} {params.extension}" # {name}"


rule move_frags_and_delete_others:
    input:
        "tmp/{sample}/{sample}.200.3mers",
        "tmp/{sample}/{sample}.200.9mers",
        "tmp/{sample}/{sample}.checkpoint"
    output:
        "../data/fragments/{sample}.200.3mers",
        "../data/fragments/{sample}.200.9mers",
        "../data/checkpoints/{sample}.checkpoint"
    shell:
        "scripts/move_frags.sh {input} {output} {wildcards.sample}"

rule create_abinitio_options_file:
    input:
        "../data/options/abinitio_options/default_options",
        "../data/fasta_files/{sample}.fasta"
    output:
        "/storage2/imartinovic/data/options/abinitio_options/{sample}.options"
    script:
        "scripts/create_options_file.py"

rule create_broker_options_file:
    input:
        "../data/options/broker_options/default_options",
        "../data/fasta_files/{sample}.fasta"
    output:
        "../data/options/broker_options/{sample}.options"
    script:
        "scripts/create_options_file.py"

rule create_topology_broker_file:
    input:
        "../data/topology_broker/default_topology_broker.tpb",
        "../data/fasta_files/{sample}.fasta"
    output:
        "../data/topology_broker/{sample}_toplogy_broker.tpb"
    script:
        "scripts/create_options_file.py"

rule create_structures_abinitio_seed:
    input:
        "/storage2/imartinovic/data/options/abinitio_options/{sample}.options",
        "../data/fragments/{sample}.200.3mers",
        "../data/fragments/{sample}.200.9mers"
    params:
          seed=SEEDS
    output:
        expand("../data/created_structures/{sample}/{seed}/{name}.pdb", name=FINAL_NAMES, allow_missing=True),
        "../data/created_structures/{sample}/{seed}/score.fsc"
        # "../data/created_structures/{sample}/default.out"
    shell:
         "scripts/create_structures_abinitio_seed.sh {input[0]} {wildcards.sample} {wildcards.seed} {output}"

rule collect_created_structures:
    input:
        "../data/created_structures/{sample}/{seed}/{name}.pdb" #, seed=SEEDS, sample=SAMPLES, name=FINAL_NAMES)
    output:
        "../data/created_structures/{sample}/{seed}-{name}.pdb" #, seed=SEEDS, name=FINAL_NAMES, sample=SAMPLES)
    shell:
        "mv {input} {output}"


# rule create_structures_abinitio:
#     input:
#         "/storage2/imartinovic/data/options/abinitio_options/{sample}.options",
#         "../data/fragments/{sample}.200.3mers",
#         "../data/fragments/{sample}.200.9mers"
#     output:
#         "../data/created_structures/{sample}/{name}.pdb"
#         # "../data/created_structures/{sample}/score.fsc",
#         # "../data/created_structures/{sample}/default.out"
#     shell:
#          "scripts/create_structures_abinitio.sh {input[0]} {output} {wildcards.sample}"


rule clean_created_pdbs:
    input:
        "../data/created_structures/{sample}/{seed}-{name}.pdb"
    output:
        "../data/cleaned_created_structures/{sample}/{seed}-{name}.pdb"
    params:
        sample_name="{sample}"
    script:
        "scripts/clean_created_pdbs.py"

rule renumber_atoms_in_structure:
    input:
        "../data/cleaned_created_structures/{sample}/{seed}-{name}.pdb"
    output:
        "../data/final_structures/{sample}/{seed}-{name}.pdb"
    shell:
        "../rosetta/main/tools/protein_tools/scripts/pdb_renumber.py {input} {output}"


rule calculate_rmsd:
    input:
        "../data/original_pdbs/{sample}.pdb",
        "../data/final_structures/{sample}/{seed}-{name}.pdb"
    params:
        path=initial_path+'data/',
        sample_name="{sample}",
        final_name=FINAL_NAMES
    output:
        "../data/rmsd/{sample}/{seed}-{name}.txt"
    script:
        "scripts/calculate_rmsd.py"

rule extract_rms:
    input:
        "../data/created_structures/{sample}/{seed}/score.fsc"
    output:
        expand("../data/score_rms/{sample}/{seed}-{name}.txt", name=FINAL_NAMES, allow_missing=True)
    script:
        "scripts/extract_rms.py"
          
rule extract_scores:
    input:
        "../data/created_structures/{sample}/{seed}/score.fsc"
    output:
        expand("../data/scores/{sample}_{seed}-{name}.sc", name=FINAL_NAMES, allow_missing=True)
    script:
        "scripts/extract_rms_to_sc_files.py"

# rule create_structures_minirosetta:
#     input:
#         "../data/options/broker_options/{sample}.options",
#         "../data/fragments/{sample}.200.3mers",
#         "../data/fragments/{sample}.200.9mers",
#          "../data/checkpoints/{sample}.checkpoint",
#         "../data/topology_broker/{sample}_topology_broker.tpb"
#     params:
#           name="{name}"
#     output:
#         "../data/final_structures/{sample}/{name}.pdb"
#  #       "../data/final_structures/{sample}/score.fcs"
#     shell:
#     #    "mkdir ../data/final_structures/{wildcards.sample} | cd ../data/final_structures/{wildcards.sample} | ../rosetta/main/source/bin/minirosetta.static.linuxgccrelease @{input[0]} | cd ../SnakemakePipeline" # | for f in *.pdb; do printf '%s\n' {sample}_$f; done"
#         "scripts/create_structures_minirosetta.sh {input[0]} {output} {wildcards.sample}"

rule move_to_train_and_val:
    input:
        expand("../data/final_structures/{sample}/{seed}-{name}.pdb", sample=SAMPLES, name=FINAL_NAMES, seed=SEEDS)
    output:
        expand("../data/train/{sample}_{seed}-{name}.pdb", sample=TRAIN, name=FINAL_NAMES, seed=SEEDS),
        expand("../data/val/{sample}_{seed}-{name}.pdb", sample=VAL, name=FINAL_NAMES, seed=SEEDS)
    params:
        val_list = VAL,
        train_dir = "../data/train/",
        val_dir = "../data/val/"
    script:
        "scripts/create_train_val.py"





