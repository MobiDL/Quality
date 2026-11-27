version 1.0

import "modules/samtools.wdl" as runSamtools
import "modules/bedtools.wdl" as runBedtools

workflow Quality {
    meta {
        author: "Felix VANDERMEEREN"
        email: "felix.vandermeeren(at)chu-montpellier.fr"
        version: "0.0.1"
        date: "2026-11-26"
    }
    input {
        ## resources
        Int cpuHigh = 24
        Int cpuLow = 1
        # Int avxCpu
        Int memoryLow = 2500
        Int memoryHigh = 12000
        # memoryLow = scattered tasks =~ mem_per_cpu in HPC or not
        # memoryHigh = one cpu tasks => high mem ex 10Gb

        ## Global
        String sample
        File bam
        File bamIndex
        String outDir

        File refFasta
        File refFai = refFasta + ".fai"
        File refDict

        File targetBed
        File baitBed = targetBed  # Default to 'targetBed'

        ## computePoorCoverage
        Int bedtoolsLowCoverage = 20
        Int bedToolsSmallInterval = 20
        String genomeVersion = "hg38"

        ## computeCoverage
        Int minCovBamQual = 30

        ## Identito (default = SNPXplex. rsIDs order here will be maintained)
        String idList = "rs11702450,rs843345,rs1058018,rs8017,rs3738494,rs1065483,rs2839181,rs11059924,rs2075144,rs6795772,rs456261,rs1131620,rs2231926,rs352169,rs3739160"

        ## covreport
        String? covReportDir
        File? geneFile
    }

    call runSamtools.bedcov {
        input:
            threads = cpuLow,
            memory = memoryHigh,
            name = sample,
            outputPath = outDir,
            intervalBedFile = targetBed,
            bam = bam,
            bamIndex = bamIndex,
            minCovBamQual = minCovBamQual
    }

    call runBedtools.computeCoverage {
        input:
            threads = cpuLow,
            memory = memoryHigh,
            name = sample,
            outputPath = outDir,
            bedCovFile = bedcov.outputBedcov
    }

    call runBedtools.computeCoverageClamms {
        input:
            threads = cpuLow,
            memory = memoryHigh,
            name = sample,
            outputPath = outDir,
            bedCovFile = bedcov.outputBedcov
    }

    output {
        File samtoolsBedcov = bedcov.outputBedcov
    }

}
