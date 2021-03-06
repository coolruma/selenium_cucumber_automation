package com.asx.dlt.integration.tests.runners;

import cucumber.api.CucumberOptions;

/**
@author kamboj_a
*/


@CucumberOptions(plugin = { "pretty", "html:target/cucumber-report/", "json:target/dlt-cucumber-referencedates.json",
		"junit:target/cucumber-junit.xml", "usage:target/cucumber-usage.json" }, 
		features = "scenarios/platform/referencedata/referencedates")
public class DltReferenceDatesRunner extends SuperRunner {

}
