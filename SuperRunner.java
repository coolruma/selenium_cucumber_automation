package com.asx.dlt.integration.tests.runners;

import java.io.File;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

import com.asx.dlt.automation.core.constants.CoreConstants;
import com.asx.dlt.automation.core.helpers.executor.CommandExecutorFactory;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.integration.tests.helpers.util.FrameworkUtil;
import com.asx.dlt.integration.tests.helpers.util.PrepareSystem;
import com.asx.dlt.integration.tests.helpers.util.TestExecutionInfo;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

/**
@author kamboj_a
*/
@RunWith(Cucumber.class)
@CucumberOptions(glue = {"com.asx.dlt.integration.tests.glue" })
public class SuperRunner {

	private static Logger logger = LogManager.getLogger(DltTradesRunner.class.getName());
	private static boolean isInitialised = false;

	// Do the system clean up once in the beginning of test run
	@BeforeClass
	public static void cleanUpBeforeStart() throws Exception {

		FrameworkUtil.cleanupExecId();

		if (!isInitialised) {
			System.out.println("Before Start... Performing cleanup...");
			try {
				CoreUtil.setExecutionLocation();

				String log = String.format("Running tests with Environment config File -- %s with execution location as -- %s ",
						CoreUtil.getEnvironmentConfigFile(), CoreUtil.getExecutionLocation());
				System.out.println(log);
				logger.info(log);

				String activeContractsDir = !CoreUtil.isLocalExecution() ? CoreConstants.DLT_REMOTE_ACTIVE_CONTRACTS_CMD_DIR :
						                                                  CoreConstants.DLT_LOCAL_ACTIVE_CONTRACTS_CMD_DIR;

				File file = new File(activeContractsDir);
				if (file.exists()) {
					FileUtils.cleanDirectory(file);
				} else {
					file.mkdirs();
				}

				String activeContractsDirOut = !CoreUtil.isLocalExecution() ? CoreConstants.DLT_REMOTE_ACTIVE_CONTRACTS_CMD_DIR_OUT :
						CoreConstants.DLT_LOCAL_ACTIVE_CONTRACTS_CMD_DIR_OUT;

				File fileOut = new File(activeContractsDirOut);
				if (fileOut.exists()) {
					FileUtils.cleanDirectory(fileOut);
				} else {
					fileOut.mkdirs();
				}

				String executionOutputParentDir = !CoreUtil.isLocalExecution() ? CoreConstants.DLT_REMOTE_TIMESTAMPED_EXEC_DIR :
						CoreConstants.DLT_LOCAL_TIMESTAMPED_EXEC_DIR;

				File executionOutputDir = new File(executionOutputParentDir + File.separator + "executionOutput");
				if (executionOutputDir.exists()) {
					FileUtils.cleanDirectory(executionOutputDir);
				}
				//CommandExecutorFactory.getCommandExecutorInstance().prepareSystemForTest();
				//PrepareSystem.performCleanupAndSetup();
				isInitialised = true;

				//Extract & log test execution details info
				//List<String> execDetails = TestExecutionInfo.getTestExecutionDetails();
				//execDetails.forEach(line -> logger.info(line));

			} catch (Throwable e) {
				String error = "FAILED: Aborting tests... \nClean Up before start failed with exception -- "
						+ e.getMessage();
				logger.debug(error);
				System.out.println(error);
				e.printStackTrace();
				throw new RuntimeException(error);
			}

		}
	}

	// after block will run as a part of CleanupRunner.
}
