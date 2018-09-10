package com.asx.dlt.integration.tests.runners;

import org.junit.AfterClass;

import com.asx.dlt.automation.core.drivers.AdapterDriverFactory;
import com.asx.dlt.automation.core.helpers.ssh.SSHClientWrapper;
import com.asx.dlt.automation.core.helpers.threads.CustomExecutorService;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;

/**
@author kamboj_a
*/
public class CleanupRunner {
	
	@AfterClass
	public static void afterSuite() throws Exception {
		System.out.println("Performing teardown after tests...\n");
		// Close all the ESB Consumers
		AdapterDriverFactory.cleanAllAdapters();
		// Shutdown all executor service threads
		CustomExecutorService.getInstance().shutdownAllExecutorServices();
		// Close the shell instance
		if (! CoreUtil.isLocalExecution()) {
			SSHClientWrapper.getInstance().close();
		}
	}

}
