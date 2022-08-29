# Understanding the benefits of normative decoding in genomic data compression and sharing
Here will be the material I use for my bachelor's thesis.
In case you want to execute the samtools testing you should at least have 1200GB of free memory.

This project helps automating the generic execution of the compressors: Genie, Samtools, Spring, Scalce and Gzip.

For testing each file one at a time, execute the menu.sh executable. 
Overthere you will find the different options for compression.
When asked for a file be aware where you have it, if not in the same folder, put the full path.
With menu.sh you will be able to compress a fastq or sam file formats to the final compression file 
 format for each compressors or biceversa, not from any intermidiate file, for that use the proper commands.

For adding any special parameters apart from the generic ones, use the actual command.

On the folder /executables there is a folder for the executables of each compressor used,
a bash file executed by menu.sh for an standard compression and the folder from each GitHub page.
Be aware of the version, still if you want to reinstall it again you can delete the folder with the name of
 the compressor, NOT the /name_executables and install it again using the installing bash script in the folder
 ( installing_nameOfCompressor.sh ).

The /samples folder should be empty of files, there was where I store the files for execution although you can
 have them else where.

The History.txt file keeps the records of the files created using any script I created. 
There it will be display with which compressor was created, when was created, the size in bytes and the name of the file.
With this we can keep track of the files even if you remove them afterwards. 
