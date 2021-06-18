import os

samples = os.path.basename(config["variants"]["path"].split('.vcf.gz')[0])

rule all:
    input:
        png = expand("{sample}.png", sample=samples)

rule parse_metadata:
    input:
        metadata = config["metadata"]["path"]
    singularity:
        "docker://elixircloud/plink:1.9-cwl-20200901"
    output:
        covariates = "covariates.txt",
        phenotypes = "phenotypes.txt",
        sex = "sex.txt",
        ids = "ids.txt",
    shell:
        "parse_metadata.sh -c {input.metadata}"

rule run_gwas:
    input:
        variants = config["variants"]["path"],
        covariates = "covariates.txt",
        phenotypes = "phenotypes.txt",
        sex = "sex.txt",
        ids = "ids.txt",
    singularity:
        "docker://elixircloud/plink:1.9-cwl-20200901"
    output:
        logistic = "{sample}.assoc.logistic" 
    shell:
        "run_gwas.sh {input.variants} {input.ids} {input.sex} {input.phenotypes} {input.covariates}"
    
rule create_plot:
    input:
        logistic = "{sample}.assoc.logistic"
    singularity:
        "docker://krish8484/plink:1.9-20200901"
    output:
        png = "{sample}.png"
    shell:
        "create_plot.sh {input.logistic}"

