package com.org.home.selenium_cucumber_automation;

import org.junit.runner.RunWith;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

@RunWith(Cucumber.class)
@CucumberOptions(
		features="features",
		glue="com.org.home.step_definition",
				plugin={"html:target/cucumber-html-report","json:target/cucumber.json"}
		)
public class TestRunnerNew {

}