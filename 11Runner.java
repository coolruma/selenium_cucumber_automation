package com.asx.dlt.integration.tests.runners;

import cucumber.api.CucumberOptions;

/**
@author kamboj_a
*/


@CucumberOptions(plugin = { "pretty", "html:target/cucumber-report/", "json:target/dlt-cucumber-scheduler.json",
		"junit:target/cucumber-junit.xml", "usage:target/cucumber-usage.json" }, 
		features = "scenarios/platform/referencedata/scheduler")
public class DltSchedulerRunner extends SuperRunner {

}
