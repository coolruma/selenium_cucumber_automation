package com.asx.dlt.integration.tests.runners;

import cucumber.api.CucumberOptions;

/**
@author kamboj_a
*/

/*@ExtendedCucumberOptions(jsonReport = "target/dlt-cucumber-issuers.json", 
jsonUsageReport = "target/cucumber-usage.json", 
outputFolder = "target/cucumber-report", 
detailedReport = true, detailedAggregatedReport = true, 
overviewReport = true, usageReport = true, 
coverageReport = true, retryCount = 0, 
screenShotLocation = "screenshots", 
screenShotSize = "300px", toPDF = true)*/

@CucumberOptions(plugin = { "pretty", "html:target/cucumber-report/", "json:target/dlt-cucumber-issuers.json",
		"junit:target/cucumber-junit.xml", "usage:target/cucumber-usage.json" }, 
		features = "scenarios/settlement_mvp/issuer")
public class DltIssuerRunner extends SuperRunner {

}
