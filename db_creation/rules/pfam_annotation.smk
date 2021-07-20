rule pfam_annotation:
    input:
        gp=config["rdir"] + "/gene_prediction/{smp}_orfs.fasta"
    params:
        pfamdb = config["pfam_db"],
        hmmout = config["rdir"] + "/pfam_annotation/{smp}_hmmsearch_pfam_annot.out",
        hmmlog = config["rdir"] + "/pfam_annotation/{smp}_hmmsearch_pfam_annot.log"
    output:
        annot=config["rdir"] + "/pfam_annotation/{smp}_pfam.tsv"
    threads: 28
    log:
        out="logs/{smp}_annot_stdout.log",
        err="logs/{smp}_annot_stderr.err"
    benchmark:
        "benchmarks/pfam_annotation/{smp}.annot.tsv"
    shell:
        """
        set -x
        set -e
        # Dirty by working...
        . /appli/bioinfo/hmmer-mpi/3.3/env.sh 
        
        NPFAM=$(grep -c '^NAME' {params.pfamdb})
        NSEQS=$(grep -c '^>' {input.gp})
        N=$(($NSEQS * $NPFAM))

        # Run hmmsearch (MPI-mode)
    	$MPI_LAUNCH hmmsearch --mpi --cut_ga -Z "${{N}}" --domtblout {params.hmmout} -o {params.hmmlog} {params.pfamdb} {input.gp} 2>{log.err} 1>{log.out}

        # Collect the results
        grep -v '^#' {params.hmmout} > {output.annot}

        """

rule pfam_annotation_done:
    input:
        annot = config["rdir"] + "/pfam_annotation/{smp}_pfam.tsv"
    output:
        annot_done = touch(config["rdir"] + "/pfam_annotation/{smp}.annotation.done")
    run:
        shell("echo 'ANNOTATION DONE'")
