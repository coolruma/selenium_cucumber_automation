package com.asx.dlt.integration.tests.runners;

import cucumber.api.CucumberOptions;

/**
@author kamboj_a
*/


@CucumberOptions(plugin = { "pretty", "html:target/cucumber-report/", "json:target/dlt-cucumber-instruments.json",
		"junit:target/cucumber-junit.xml", "usage:target/cucumber-usage.json" },
		features = "scenarios/platform/referencedata/securities")
public class DltInstrumentsRunner extends SuperRunner {

}
