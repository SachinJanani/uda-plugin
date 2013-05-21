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

package org.apache.hadoop.mapred;

import java.io.IOException;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.Task;
import org.apache.hadoop.mapred.Task.TaskReporter;
import org.apache.hadoop.mapred.ReduceTask.ReduceCopier;
import org.apache.hadoop.util.ReflectionUtils;
import org.apache.hadoop.fs.FileSystem;

public class UdaMapredBridge {
	
	public static ShuffleConsumerPlugin getShuffleConsumerPlugin(Class<? extends ShuffleConsumerPlugin> clazz, ReduceTask reduceTask, 
			TaskUmbilicalProtocol umbilical, JobConf conf, Reporter reporter) throws ClassNotFoundException, IOException  {
	
		if (clazz == null) {
			clazz = ReduceCopier.class;
		}
		ShuffleConsumerPlugin plugin = ReflectionUtils.newInstance(clazz, conf);
		ShuffleConsumerPlugin.Context context = new ShuffleConsumerPlugin.Context(umbilical, conf, (TaskReporter) reporter, reduceTask);
		plugin.init(context);
		return plugin;
	}

}
