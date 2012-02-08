#!/bin/awk -f

function usage() {
	print "USAGE: awk -v conf_num=<conf index (1 base) in the csv file> -v conf_dir=<output conf dir> -f <script.awk>  <csv file>"
	system("dirname $0")
}

function getFilenameByHeader(header,i) {
	tmp1=""
	tmp=""
	j=index(header,"@")
	l=length(header)
	if (j > 0) {
	tmp1=substr(header,j+1,l+1-j)
	       if (i==NF){
		l=l-1
		tmp1=substr(header,j+1,l-j)
		}
	  tmp1=substr(header,j+1,l+1-j)
	  if (tmp1 ~ /core/){
		name="core-site.xml"
		return conf_dir"/"name
          }	
	  return conf_dir"/"tmp1"-site.xml"
	}
	else
	  return conf_dir"/tmp_file"
	exit
}

function getPropertyByHeader(header) {
	x=index(header,"@")
        if (x > 0){
	var=substr(header,0,x-1)
	if (header ~ /tmp.dir/){
	}
          return substr(header,0,x-1)
	}
        else
          return header
}


function putHeadersInFile(file_name){
	counter=$counter+1
	file=conf_dir"/"file_name"-site.xml"
	print "<?xml version=\"1.0\"?>" > file
	print "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" > file
	print "<configuration>\n" > file
}

function sendHeadersToFile(){
	putHeadersInFile("core")
	putHeadersInFile("hdfs")
	putHeadersInFile("mapred")
	
}

function putConfigInEndOfFile(){
print "</configuration>\n" > conf_dir"/core-site.xml"
print "</configuration>\n" > conf_dir"/hdfs-site.xml"
print "</configuration>\n" > conf_dir"/mapred-site.xml"

}



BEGIN {
	FS=","
	if (conf_num=="") {
	  usage()
	  exit 1
	}
	if (conf_dir=="") 
	  conf_dir="conf"
	
	slaves=0
	master=0
	default_row=-1000000000000
	slave_master_update=0
	interface=0
	InterfaceFlag=0
	counter=0
}

$1=="" { 
	#continue; 
}


$1=="master" {
	master=$2
}

$1=="slaves" {
	slaves=$2
}

$1=="headers" {
	for (i=2; i<=NF; i++){
	  headers[i]=$i
	}
}


$1=="DEFAULT" {
        for (i=2; i<=NF; i++) {
          gsub(";",",",$i)
	  defaults[i]=$i
        }
	default_row=NR;

}

$1=="data_collector" {
	print $2 > conf_dir"/dataCollectorNode.txt"
}


$1=="log_dir" {
	print $2 > conf_dir"/logDir.txt"
}

$1=="end" {

linesNum= NR-1-default_row
print linesNum > conf_dir"/excelLineNumber.txt"

}

NR==(default_row+conf_num) {

	sendHeadersToFile()

	for (i=2; i<=NF-1; i++) {
	    if ($i == "")
	       currValue=defaults[i]
	    else
	       currValue=$i
	    gsub(";",",",currValue)
	   if (headers[i] ~ /interface/ && InterfaceFlag==0 ){
		interface=currValue
		InterfaceFlag=1
		}
	     if (headers[i] ~ /mapred.tasktracker.map.tasks.maximum/){
		print currValue > conf_dir"/mappersNum.txt"
	  	}
	     if (headers[i] ~ /mapred.tasktracker.reduce.tasks.maximum@mapred/){
                print currValue > conf_dir"/reducersNum.txt"
          	}
	     if (headers[i] ~ /#slaves/){
		print currValue > conf_dir"/clusterNodesNum.txt"
		}
	     if (headers[i] ~ /teragen.map.tasks/){
		print currValue > conf_dir"/teragenMapTasks.txt"
		}
	     if (headers[i] ~ /data.set.size/){
		print currValue > conf_dir"/dataSetSize.txt"
	        }
	     if (headers[i] ~ /#samples/){
                print currValue > conf_dir"/samplesNum.txt"
                }

	  filename=getFilenameByHeader(headers[i],i)
	  property=getPropertyByHeader(headers[i])
	  print "<property>" > filename
	  print "  <name>"property"</name>" > filename
	  print "  <value>"currValue"</value>" > filename
	  print "</property>" > filename
	  
	} 
	slave_master_update=1
	putConfigInEndOfFile()
	
}


END {
        gsub(";","-"interface"\n", slaves)
        print slaves > conf_dir"/slaves"
        print master"-"interface > conf_dir"/masters"
        slave_master_update=0
        InterfaceFlag=0
	counter=0
	default_row=-1
}

