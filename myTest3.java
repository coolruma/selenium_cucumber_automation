package com.asx.dlt.integration.tests.glue.preconditions;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

import com.asx.dlt.automation.core.drivers.AdapterDriverFactory;
import com.asx.dlt.automation.core.drivers.esb.InboundESBAdapterDriver;
import com.asx.dlt.automation.core.drivers.esb.OutboundESBAdapterDriver;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.integration.tests.constants.DltConstants;
import com.asx.dlt.integration.tests.constants.TestDataConstants;
import com.asx.dlt.integration.tests.glue.TestScenarioSetup;
import com.asx.dlt.integration.tests.preconditions.PreconditionFactory;
import com.asx.dlt.integration.tests.preconditions.PreconditionManager;

import cucumber.api.DataTable;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;

public class PreconditionDefs {

	private static CopyOnWriteArrayList _cachedFeaturePreoondStep = new CopyOnWriteArrayList();

	@Given("^the following \"([^\"]*)\" level precondition \"([^\"]*)\" are generated and published via adapter \"([^\"]*)\"$")
	public void theFollowingPreconditionAreCreatedOncePerFeatureExecutionViaTemplateBasedApproach(
			TestDataConstants.PreconditionType precondType, String messageType, String adapterType, DataTable dataTable)
			throws Throwable {
		theFollowingPreconditionAreGeneratedFromTemplateFileAndPublished(precondType, messageType, null, adapterType,
				dataTable);
	}

	@Given("^the following \"([^\"]*)\" level precondition \"([^\"]*)\" are generated from template file \"([^\"]*)\" and published via adapter \"([^\"]*)\"$")
	public void theFollowingPreconditionAreGeneratedFromTemplateFileAndPublished(
			TestDataConstants.PreconditionType precondType, String messageType, String templateName, String adapterType,
			DataTable dataTable) throws Throwable {
		PreconditionManager preconditionMgr = PreconditionFactory.getPreconditionManager(precondType);

		if (precondType == TestDataConstants.PreconditionType.Feature) {
			String uniquePrecondKey = TestScenarioSetup.getFeatureName();
			if (!_cachedFeaturePreoondStep.contains(uniquePrecondKey)) {
				Map<String, Map<String, String>> preconditionData = preconditionStages(preconditionMgr, messageType,
						adapterType, templateName, dataTable);
				for (String key : preconditionData.keySet()) {
					uniquePrecondKey += "-" + messageType + "-" + adapterType + "-" + key;
					_cachedFeaturePreoondStep.add(uniquePrecondKey);
				}
			} else {
				// TODO - load properties from Feature file (for concurrent scenario cases)
			}

		}
	}

	@Given("^existing \"([^\"]*)\" precondition properties are loaded from file \"([^\"]*)\"$")
	public void existingFeaturePreconditionPropertiesAreLoadedFromFile(TestDataConstants.PreconditionType precondType,
			String filePath) throws Throwable {
		// PreconditionFactory.disposePreconditionManager(TestDataConstants.PreconditionType.Feature);
		PreconditionManager preconditionMgr = PreconditionFactory.getPreconditionManager(precondType, filePath);
		preconditionMgr.loadPropertiesFromSource();

	}

	@And("^the following precondition table are persisted to \"([^\"]*)\" properties file$")
	public void theFollowingPreconditionTableArePersistedToPropertiesFile(
			TestDataConstants.PreconditionType precondType, DataTable dataTable) throws Exception {
		PreconditionManager preconditionMgr = PreconditionFactory.getPreconditionManager(precondType);
		List<Map<String, String>> listOfEvaluatedValueRowMaps = preconditionMgr
				.convertDataTableToMapWithEvaluatedValues(dataTable);

		HashMap<String, Map<String, String>> results = new HashMap<String, Map<String, String>>();
		listOfEvaluatedValueRowMaps.forEach(rm -> {
			results.put(rm.get("PreconditionKey"), rm);
		});

		preconditionMgr.persistProperties(results, true);

	}

	public Map<String, Map<String, String>> preconditionStages(PreconditionManager preconditionMgr, String messageType,
			String adapterType, String templateName, DataTable dataTable) throws Exception {

		// Step 1 - Create precondition objects based on the data passed in
		Map<String, Map<String, String>> preconditions = preconditionMgr.createPreconditionObjects(messageType,
				adapterType, templateName, dataTable);

		// TODO - Minimal validation to ensure precondition object is created
		// successfully
		// preconditionMgr.validatePreconditionObjects(messageType,adapterType,preconditions);

		// Persist properties to file
		preconditionMgr.persistProperties(preconditions, false);

		// TODOs - load precondition properties to cache
		preconditionMgr.loadPropertiesFromSource();

		return preconditions;
	}

	@Given("^I override the default file name to persist the preconditions properties to \"([^\"]*)\"$")
	public void i_override_the_default_file_name_to_persist_the_preconditions_properties_to(String fileName)
			throws Exception {
		if (CoreUtil.isStringNullOrEmpty(fileName)) {
			throw new RuntimeException("Precondtion persist file name can't be null or empty... " + fileName);
		}
		String name = null;
		if (fileName.endsWith(".properties")) {
			name = fileName;
		} else {
			name = fileName + ".properties";
		}
		System.setProperty(DltConstants.PRECONDITION_PERSIST_FILE_NAME, name);
	}

}
