#!/bin/bash

export EXEC_JOB="bin/hadoop jar"
export EXEC_SLAVES="sbin/slaves.sh"
export HADOOP_FS="bin/hadoop fs"
export HADOOP_FS_RMR="bin/hadoop fs -rm -r"
export JOB_OPTIONS="bin/mapred job"
export DFS_START="sbin/start-dfs.sh"
export DFS_STOP="sbin/stop-dfs.sh"
export DFS_FORMAT="bin/hdfs namenode -format -force"
export DFS_SAFEMODE_GET="bin/hdfs dfsadmin -safemode get"
export DFS_FSCK_RACKS="bin/hdfs fsck -racks"
export MAPRED_START="sbin/start-yarn.sh"
export MAPRED_STOP="sbin/stop-yarn.sh"
export MAPRED_SERVICE_NAME="YARN"
export JAR_FILE_RELATIVE_DIR="share/hadoop/mapreduce/" # NEEDS TO INCLUDE / IN THE END, IF NOT NULL
export JOB_LOG_PATH="logs/yarn-*-resourcemanager*.log"
export REDUCER_LOG_PATH="app*/cont*/syslog"
export PROVIDER_LOG_PATH="yarn*nodemanager*log"
export HADOOP_CONFIGURATION_DIR_RELATIVE_PATH="etc/hadoop"
export RELATIVE_PATH_TO_JOB_CONF_ON_DFS="job.xml"
export JOB_HISTORY_SUCCESS_OUTPUT="Status: SUCCEEDED"
export DFS_PERMISSIONS=700
export MAP_TASKS="mapreduce.job.maps"
export DFS_REPLICATIONS="dfs.replication"
export RANDOM_TEXT_WRITER_DATASIZE="mapreduce.randomtextwriter.totalbytes"
export RANDOM_WRITER_DATASIZE="mapreduce.randomwriter.totalbytes"
export HADOOP_STOP_ALL="sbin/stop-dfs.sh && sbin/stop-yarn.sh"
export HADOOP_START_ALL="sbin/start-dfs.sh && sbin/start-yarn.sh"
#############
export UDA_CONSUMER_PROP="mapred.reducetask.shuffle.consumer.plugin"
export UDA_CONSUMER_VALUE="com.mellanox.hadoop.mapred.UdaShuffleConsumerPlugin"
export UDA_CONSUMER_PROP2="mapreduce.job.reduce.shuffle.consumer.plugin.class"
export UDA_CONSUMER_VALUE2="com.mellanox.hadoop.mapred.UdaShuffleConsumerPlugin"
#############

### spacial export which using logic for hadoops 2 & 3 only
export HADOOP_RESOURCES_DIR="share/hadoop/common/lib"
export PATH_TO_JOB_INFO="/tmp/*/*/*/*"
export RELATIVE_PATH_TO_JOB_HISTORY_ON_DFS="*.jhist"
export DATANODE_INDICATOR="Number of data-nodes:"
export TASKTRACKER_INDICATOR="tracker_"