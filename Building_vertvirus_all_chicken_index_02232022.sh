#VertVirus_all (Not including refseqs)
#	Search string from NCBI nucleotide and export all the data as FASTA files: 
(txid10292[ORGN] OR txid548682[ORGN] OR txid10508[ORGN] OR txid151340[ORGN] OR txid151341[ORGN] OR txid137992[ORGN] OR txid10486[ORGN] OR txid10240[ORGN] OR txid687329[ORGN] OR txid39724[ORGN] OR txid1542744[ORGN] OR txid10780[ORGN] OR txid10993[ORGN] OR txid585893[ORGN] OR txid10880[ORGN] OR txid291484[ORGN] OR txid76803[ORGN] OR txid11118[ORGN] OR txid12058[ORGN] OR txid39733[ORGN] OR txid11974[ORGN] OR txid11050[ORGN] OR txid12283[ORGN] OR txid11018[ORGN] OR txid178830[ORGN] OR txid1513294[ORGN] OR txid11270[ORGN] OR txid11266[ORGN] OR txid11158[ORGN] OR txid11617[ORGN] OR "Peribunyaviridae"[Organism] OR txid11308[ORGN] OR txid11632[ORGN] OR txid10404[ORGN]) NOT phage[All Fields] NOT patent[All Fields] NOT unverified[Title] NOT vector[Title] NOT synthetic[Title] NOT chimeric[Title] NOT miRNA NOT txid28384[ORGN] NOT method[Title] NOT "partial"[Title] NOT "region"[Title] NOT "uncultured virus"[Organism] AND 00000000101[SLEN] : 00001300000[SLEN] AND ("complete genome" OR "complete segment" OR "whole genome" OR "full genome" OR "whole segment" OR "full segment" OR ("segment" AND ("complete sequence" OR "complete CDS"))) NOT txid2697049[ORGN]
## how do you come up with these txids?????? 
#	081222: 867427 sequences.  I successfully downloaded 867427 of them. (why less?) 
		#used the following to count how many sequences I downloaded:
			grep '^>' '/home/garcialab/centrifuge/indices/files_for_index_building/seqid2tax_maps/VertVirus08112022.fasta' | wc -l
#    **NOTE**: Too many sequences for Sars CoV 2 (over 300,000 seqs have been deposited since April 2021). So, only download one seq and cat with vertvirus file that doesn't contain Sars CoV 2:
       cat VertVirus_02232022.fasta NC_045512.fasta > VertVirus_NC_045512_02232022.fasta	 
# here, down load the sequence with accession number of NC_045512
	
#Dustmask: install dustmaser by command "sudo apt install ncbi-blast+"

	dustmasker -in VertVirus_NC_045512_08122022.fasta -out dustmasked_VertVirus_NC_045512_08122022.fna -outfmt fasta
	cd
#Replace lowercase letters with N
	sed '/^>/! s/a/N/g' dustmasked_VertVirus_NC_045512_08122022.fna | sed '/^>/! s/c/N/g' | sed '/^>/! s/t/N/g' | sed '/^>/! s/g/N/g' > N_sedded_dustmasked_VertVirus_NC_045512_08122022.fna




	#3. Download the seqid2taxid map, nodes, and names for NCBI 
	####Using seqid2taxid created 10292018 (see below)
#	#download seqid2taxid file. go to NCBI and click the taxomony tab > taxomoy FTP
#		https://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/
#		#download this file: nucl_gb.accession2taxid.gz
#			#downloaded to garcialabls
/centrifuge/indices/files_for_index_building/seqid2tax_maps/
#		#unzip the file
#		#open terminal in this folder
#		#remove columns 1 and 4 (keep columns 2 (accession ID with version (decimal)) and 3 (taxID))
			cut -f2,3 data > NCBI_Genbank_08122022_seqID2taxid.map
			#the data is the extracted file from the download file
#			#the above file is now used as the map file for centrifuge-build
#	#download nodes and names file from NCBI
#		ftp://ftp.ncbi.nih.gov/pub/taxonomy/
		# go to NCBI and click the taxomony tab
#		#download taxdump.tar.gz
#		#unzip
#		#keep only the nodes.dmp and names.dmp files

#4. Download Chicken genome using centrifuge
	centrifuge-download -o library -m -d "vertebrate_other" -a "Chromosome" -t 9031 refseq > seqID2taxID_chicken.map
		#-o indicates the output folder to be used
		#-m indicates dustmasking
		#-d indicates the folder in the NCBI FTP website to use to find the taxid.  For most other instances, this will be "vertebrate_mammalian"
			#ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq
		#-a	assembly type, use the "assembly_summary.txt" that is on the NCBI ftp site above, download, open in excel (libre on linux), find the species you are interested in.
			#the assembly type (chromosome, scaffold, etc.) are the different choices, see how the genome you are interested in is classified
		#-t taxid used to identify
			#this is also found in the "assembly_summary.txt" file
		#> you can name the output file anything you want
		
#5. Cat sequence files together
	cat N_sedded_dustmasked_VertVirus_NC_045512_08122022.fna GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic_dustmasked.fna > vert_virusALL_08122022_GRCg7b.fna

# Building database (includes Green Sea Turtle)
	
	centrifuge-build -p 4 --conversion-table NCBI_Genbank_08122022_seqID2taxid.map --taxonomy-tree nodes.dmp --name-table names.dmp vert_virusALL_08122022_GRCg7b.fna vert_virusALL_08122022_GRCg7b_index
	# use 4 threads to run this command
	# once the four cf files are generated these will be the cf indexing file for this particular species and all of the virus genome
	# to build another centrifuge data base for another species, you have to go back to step 4 and specify the species you are looking for. know the tax id of the species you are testing
	# the cf file have to be save under centrifugeindex directory for centrifuge to work 
	
