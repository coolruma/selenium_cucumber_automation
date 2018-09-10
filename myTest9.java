package com.asx.dlt.integration.tests.helpers.util;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.xpath.XPathExpressionException;

import com.asx.dlt.automation.core.definitions.DefinitionExtractor;
import com.asx.dlt.automation.core.helpers.beans.XmlField;
import com.asx.dlt.automation.core.helpers.parsers.xml.XpathXmlParser;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.integration.tests.constants.TestDataConstants;
import com.asx.dlt.integration.tests.constants.TestDataConstants;
import com.asx.dlt.integration.tests.glue.TestScenarioSetup;
import com.asx.dlt.integration.tests.helpers.localcache.ScenarioContext;
import com.mifmif.common.regex.Generex;

public class TestUtil {

	public static boolean isStringAlphanumericWithoutAnySpecialCharacters(String sourceString) {
		Pattern pattern = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE);
		Matcher matcher = pattern.matcher(sourceString);
		if (matcher.find())
			return false;
		return true;

	}

	public static String getValueFromXml(XpathXmlParser xmlParser, Map<String, XmlField> xmlFieldMap, String eachKey)
			throws XPathExpressionException {
		return xmlParser.getValueForXpath(xmlFieldMap.get(eachKey.trim()).getXpath());
	}

	public static String getStringFromRegex(String regex) {
		Generex generex = new Generex(regex);
		return generex.random();
	}

	public static void evaluateValidationResults() {
		boolean exceptionOnValidationError = Boolean.valueOf(System.getProperty("FAIL_ON_VALIDATION", "true"));
		if (exceptionOnValidationError) {
			if (!ScenarioContext.getInstance().getTestRunStatus()) {
				throw new RuntimeException(String.format("Scenario %s FAILED. Look at logs for more information... ",
						TestScenarioSetup.getScenario().getName()));
			}
		}
	}

	public static String getFieldXpath(String messageType, String fieldName) {
		String fieldXpath = DefinitionExtractor.getInstance()
				.getXmlDefinitionMap(messageType).get(fieldName);

		if(CoreUtil.isStringNullOrEmpty(fieldXpath)) {
			if(fieldName.equalsIgnoreCase(TestDataConstants.BAH_BIZ_MSG_IDENTIFIER)) {
				fieldXpath = DefinitionExtractor.getInstance()
						.getBAHDefinitionMap(messageType).get(fieldName).getXpath();

			}else {
				fieldXpath = DefinitionExtractor.getInstance()
						.getRltdBAHDefinitionMap(messageType).get(fieldName).getXpath();

			}

		}
		return fieldXpath;
	}

	public static void logSubstitutedValueToReport(String origValue, String newValue) {

		if(origValue.contains(TestDataConstants.VARIABLE_PREFIX)) {
			TestScenarioSetup.getScenario().write(String.format("** Substituted Runtime Value - Variable Expression: %s, Value: %s",origValue.trim(),newValue));
		}
	}
}
