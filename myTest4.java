package com.asx.dlt.integration.tests.glue;

import java.util.List;

import com.asx.dlt.integration.tests.constants.TestDataConstants;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.Assert;

import com.asx.dlt.automation.core.constants.CoreConstants;
import com.asx.dlt.automation.core.drivers.AdapterDriverFactory;
import com.asx.dlt.automation.core.helpers.beans.MessageHolder;
import com.asx.dlt.automation.core.helpers.calender.TradingCalendar;
import com.asx.dlt.automation.core.reports.CustomReport;
import com.asx.dlt.integration.tests.helpers.localcache.ScenarioContext;
import com.asx.dlt.integration.tests.helpers.util.PrepareSystem;

import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;

/**
 * Class to hold all the setup and tear down activities and the properties for
 * the each scenario.
 * 
 * @author kamboj_a
 *
 */

public class TestScenarioSetup {

	public static String featureName = null;
	private static Scenario scenario = null;
	private static Logger logger = LogManager.getLogger(TestScenarioSetup.class.getName());

	@Before
	public void before(Scenario s) throws Exception {
		scenario = s;
		String log = "\n\n********  STARTING SCENARIO --  " + s.getName() + " with tags - " + s.getSourceTagNames()
				+ "   ********\n";
		PrepareSystem.performCleanupAndSetup();
		logger.info(log);
		System.out.println(log);
		setFeatureName();
	}

	@After
	public void after(Scenario s) {
		try {
			logger.debug(ScenarioContext.getInstance().printData(s.getId()));
			String statusStr = "PASSED";
			boolean isFailed = s.isFailed();
			if (isFailed || !ScenarioContext.getInstance().getTestRunStatus()) {
				isFailed = true;
				statusStr = "FAILED";
			}
			String log = "\n\n********  FINISHING SCENARIO Name -  " + s.getName() + " , with tags - "
					+ s.getSourceTagNames() + " , with Status = " + statusStr + "   ********\n";
			logger.info(log);
			System.out.println(log);
			
			try {
				checkUnwantedMessagesOnQueues();
			} catch (Exception e) {
				e.printStackTrace();
			}

			if (isFailed) {
				System.out.println(
						"\n******** Please look in log file for detailed test data used in this test ********\n");

				//KN - Need to rethrow exception here as a "catch all" for ANY validation error. This would prevent the false positive scenario whereby
				// TestUtil.evaluateValidationREsults is missed in a step definition, and there is a genuine FAIL validation
				throw new RuntimeException("One or more steps failed validation. Plesae look in log file for detailed test data used in this test");
			}

		} finally {
			try {
				CustomReport.getInstance().report(s);
			} catch (Exception e) {
				System.out.println("ERROR while generating report - " + e.getMessage());
				e.printStackTrace();
			}
			// Setting TestDataHolder to null to clean old data used by previous scenario.
			// Every scenario will have its own data
			ScenarioContext.setInstance(null);
			TradingCalendar.setInstance(null);
		}
	}

	public static Scenario getScenario() {
		return scenario;
	}

	public static String getCurrentScenarioName() {
		return scenario.getName().trim();
	}

	public static void setScenario(Scenario scenario) {
		TestScenarioSetup.scenario = scenario;
	}

	public static String getFeatureName() {
		return featureName.trim();
	}

	private void setFeatureName() {
		String name = scenario.getId();
		if (name.contains("/")) {
			name = name.substring(name.lastIndexOf("/") + 1);
		} else if (name.contains("\\")) {
			name = name.substring(name.lastIndexOf("\\") + 1);
		}

		if (name.contains(":")) {
			name = name.split(":")[0];
		} else if (name.contains(";")) {
			name = name.split(";")[0];
		} else {
			throw new RuntimeException("Invalid feature name returned from cucumber - " + scenario.getId());
		}
		featureName = name;
	}
	
	private void checkUnwantedMessagesOnQueues() throws Exception {
		logger.debug("Checking for Unwanted messages in after block...");
		boolean status = false;
		// Check ingress adapter
		List<String> accessedIngressAdapterList = ScenarioContext.getInstance().getIngressAdapterList();
		for (String adapterName : accessedIngressAdapterList) {
			List<MessageHolder> listOfMessages = AdapterDriverFactory.getInboundAdapterDriver(adapterName)
					.readErrorMessage(CoreConstants.MINUS_TWO, scenario);
			if (listOfMessages !=null && !listOfMessages.isEmpty()) {
				status = true;
				logUnwantedMessages(listOfMessages, adapterName);
			}
		}
		
		// Check Egress adapter
		List<String> accessedEgressAdapterList = ScenarioContext.getInstance().getEgressAdapterList();
		for (String adapterName : accessedEgressAdapterList) {
			List<String> listOfMessages = AdapterDriverFactory.getOutboundAdapterDriver(adapterName)
					.readData(CoreConstants.ESB_READ_TIMEOUT_IN_SECS, scenario, CoreConstants.MINUS_TWO);
			if (listOfMessages !=null && !listOfMessages.isEmpty()) {
				status = true;
				logUnwantedMessages(listOfMessages, adapterName);
			}
		}
		if (status) {
			if(TestDataConstants.FAIL_TEST_ON_UNEXPECTED_MSGS_IN_QUEUE) {
				Assert.assertTrue("Unwanted Message Found on Adapter Queues. Look into logs for more details", false);
			}else {
				logger.warn("Unwanted Message Found on Adapter Queues. Look into logs for more details!");
			}

		}
	}
	
	private void logUnwantedMessages(List messageList, String adapterName) {
		String begin = String.format("******************** %d Unwanted Message Found on Adapter - %s *************************\n",
				messageList.size(), adapterName);
		String log = "List of messages found -- " + messageList.toString() + "\n";
		String end = "**************************************************************************************\n";
		System.out.println(begin + log + end);
		logger.warn(begin + log + end);
		scenario.write(String.format("WARNING :: %d Unwanted Message Found on Adapter - %s. For more information look at the logs",
				messageList.size(), adapterName));
	}
}