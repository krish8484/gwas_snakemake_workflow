import os
from glob import glob

rule all:
    input:
        png = glob("*.png")

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
        "bash parse_metadata.sh -c {input.metadata}"

rule run_gwas:
    input:
        variants = config["variants"]["path"],
        covariates = "covariates.txt",
        phenotypes = "phenotypes.txt",
        sex = "sex.txt",
        ids = "ids.txt",
        SCRIPT_ = os.path.join(
            "docker",
            "shell_scripts",
            "run_gwas.sh"
        )
    singularity:
        "docker://elixircloud/plink:1.9-cwl-20200901"
    output:
        logistic = glob("*.assoc.logistic")  
    shell:
        "bash {input.SCRIPT_} {input.variants} {input.ids} {input.sex} {input.phenotypes} {input.covariates}"
    
rule create_plot:
    input:
        logistic = glob("*.assoc.logistic"),
        SCRIPT_ = os.path.join(
            "docker",
            "shell_scripts",
            "create_plot.sh"
        )
    singularity:
        "docker://elixircloud/plink:1.9-cwl-20200901"
    output:
        png = glob("*.png")
    shell:
        "bash {input.SCRIPT_} {input.logistic}"

