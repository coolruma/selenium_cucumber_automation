package com.asx.dlt.integration.tests.runners;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import com.asx.dlt.integration.tests.reports.CucumberReports;

@RunWith(Suite.class)
@SuiteClasses({
	DltMarketSetupRunner.class,
	DltEntityRunner.class,
	DltCalendarRunner.class,
	DltAccountsRunner.class,
	DltInstrumentsRunner.class,
	DltBoqBomRunner.class,
	DltReferenceDatesRunner.class,
	DltSchedulerRunner.class,
	CucumberReports.class,
	CleanupRunner.class
})
public class DltTestSuite {

}
