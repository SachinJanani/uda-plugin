/**
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements.  See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership.  The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License.  You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package com.mellanox.hadoop.mapred;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.net.InetSocketAddress;
import java.net.URL;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;

import javax.crypto.SecretKey;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.LocalDirAllocator;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.DataInputByteBuffer;
import org.apache.hadoop.io.DataOutputBuffer;
import org.apache.hadoop.security.token.Token;
import org.apache.hadoop.yarn.api.records.ApplicationId;
import org.apache.hadoop.yarn.server.nodemanager.containermanager.AuxServices;
import org.apache.hadoop.yarn.server.nodemanager.containermanager.localizer.ContainerLocalizer;
import org.apache.hadoop.yarn.service.AbstractService;
import org.apache.hadoop.yarn.service.Service.STATE;
import org.apache.hadoop.yarn.util.ConverterUtils;
import org.apache.hadoop.yarn.util.Records;

import org.apache.hadoop.mapred.JobID;


public class UdaShuffleHandler extends AbstractService implements AuxServices.AuxiliaryService {
	

  private static final Log LOG = LogFactory.getLog(UdaShuffleHandler.class);

  private int port;

  private UdaPluginSH rdmaChannel;

 private Configuration config;
  
  public static final String MAPREDUCE_SHUFFLE_SERVICEID =
      "mapreduce.shuffle";

  private static final Map<String,String> userRsrc =
    new ConcurrentHashMap<String,String>();

  public UdaShuffleHandler() {
	  super("httpshuffle");
	  LOG.info("c-tor of UdaShuffleHandler");
  }


  @Override
  public void initApp(String user, ApplicationId appId, ByteBuffer secret) {
	 LOG.info("initApp of UdaShuffleHandler");
	  JobID jobId = new JobID(Long.toString(appId.getClusterTimestamp()), appId.getId());
	  Configuration conf = getConfig();
	  LOG.info("initApp of UdaShuffleHandler");
//	  rdmaChannel = new UdaPluginSH(conf, user, jobId);	  
	  rdmaChannel.addJob(user, jobId);
	  LOG.info("initApp of UdaShuffleHandler is done");
  }

  @Override
  public void stopApp(ApplicationId appId) {
//	rdmaChannel.close();
    LOG.info("stopApp of UdaShuffleHandler");
   JobID jobId = new JobID(Long.toString(appId.getClusterTimestamp()), appId.getId());
   rdmaChannel.removeJob(jobId);
   LOG.info("stopApp of UdaShuffleHandler is done");
   
  }

 //method of AbstractService
  @Override
  public synchronized void init(Configuration conf) {
	 this.config = conf;
    super.init(conf);
  }

  //method of AbstractService
  @Override
  public synchronized void start() {
    super.start();
    LOG.info("start of UdaShuffleHandler");
    rdmaChannel = new UdaPluginSH(config);	  
	LOG.info("start of UdaShuffleHandler is done");
  }
  
  
  //method of AbstractService
  @Override
  public synchronized void stop() {
	  LOG.info("stop of UdaShuffleHandler");
	  rdmaChannel.close();
	   LOG.info("stop of UdaShuffleHandler is done");
  }
  
  
 
  @Override
  public synchronized ByteBuffer getMeta() {
  //  try {
   //   return serializeMetaData(port); 
//    } catch (IOException e) {
//      LOG.error("Error during getMeta", e);
//      // TODO add API to AuxiliaryServices to report failures
      return null;
    }
  }

  
