package com.asx.dlt.integration.tests.runners;

import org.junit.AfterClass;

import com.asx.dlt.automation.core.drivers.AdapterDriverFactory;
import com.asx.dlt.automation.core.helpers.threads.CustomExecutorService;
import com.asx.dlt.integration.tests.reports.CucumberReports;

import cucumber.api.CucumberOptions;

/**
 * kamboj_a
 * This runner is to run you tests from remote windows machine
 */
// -Dcucumber.options="--tags @Market-Setup,@Issuer-Setup,@Instruments-Setup" -DCLEAN_START=true
@CucumberOptions(plugin = { "pretty", "html:target/cucumber-report/", "json:target/dlt-cucumber-local.json",
		"junit:target/cucumber-junit.xml", "usage:target/cucumber-usage.json" },
		features = ".\\src\\test\\resources\\scenarios",
		tags="@Ruma")
//@RunWith(Cucumber.class)
public class LocalRunner extends SuperRunner {

	@AfterClass
	public static void afterSuite() throws Exception {
		System.out.println("Performing teardown after tests...\n");
		//System.out.println("****************************** \n" + FrameworkCache.getInstance().getListOfISOMessages("EIS164"));
		// Close all the ESB Consumers
		/*System.out.println("****** By Feature Name -- " +
				FrameworkCache.getInstance().getListOfMessagesByFeatureByScenario("TradeRegistration.feature", "Register FIX Trades", "EIS164").size());

		System.out.println("******** By Scenario for Current Feature -- " +
		FrameworkCache.getInstance().getListOfMessagesForCurrentFeatureByScenario("Register FIX Trades", "EIS164").size());
		System.out.println("******* By Current Scenario -- \n" +
				FrameworkCache.getInstance().getListOfMessagesForCurrentScenario("EIS164").size());
		System.out.println("******* By Current Feature for AR \n" +
				FrameworkCache.getInstance()R.getListOfMessagesForCurrentFeatureByScenario("Register FIX Trades", "AR"));*/
		//CustomReport.getInstance().publishStatsAtScenarioLevel();
		//CustomReport.getInstance().publishStats();
		//CustomReport.getInstance().logStatsToHTML();
		try {
			new CucumberReports().runReportGeneration();
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		/*System.out.println("***** All Message of EIS164 -- " +
				FrameworkCache.getInstance().getListOfAllMessagesForCurrentFeature("EIS164").size());
		System.out.println("***** All Message of AR -- " +
				FrameworkCache.getInstance().getListOfAllMessagesForCurrentFeature("AR").size());*/
		AdapterDriverFactory.cleanAllAdapters();
		// Shutdown all executor service threads
		CustomExecutorService.getInstance().shutdownAllExecutorServices();
	}
}
