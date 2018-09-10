package com.asx.dlt.integration.tests.glue.instruments;

import java.io.IOException;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.integration.tests.constants.BDDConstants;
import com.asx.dlt.integration.tests.constants.MessageConstants;
import com.asx.dlt.integration.tests.glue.datatable.DataTableBasedDefs;
import com.asx.dlt.integration.tests.helpers.localcache.ScenarioContext;
import com.asx.dlt.integration.tests.registration.MessageRegistrationFactory;
import com.asx.dlt.integration.tests.templates.MessageGenerationFactory;

import cucumber.api.DataTable;
import cucumber.api.java.en.When;

public class InstrumentsDefs {
	private Logger logger = LogManager.getLogger(InstrumentsDefs.class.getName());
	
	@When("^I generate a message from template for \"([^\"]*)\" using datatable and publish on adapter \"([^\"]*)\" to create an \"([^\"]*)\"$")
	public void i_generate_a_message_from_template_for_using_datatable_and_publish_on_adapter_to_create_an(
			String InstrumentTypeCode, String adapterType, String instrument, DataTable dataTable)
			throws Exception, IOException {
		boolean createUnderlyingoRDuplicate = Boolean.valueOf(instrument.trim());
		ScenarioContext.getInstance().setTestProperty(BDDConstants.ISDUPLICATE, instrument.trim());
		if (instrument.equalsIgnoreCase("instrument") || createUnderlyingoRDuplicate) {
			List<Map<String, String>> dataTableAsMap = CoreUtil.convertDataTableToListOfMaps(dataTable);
			for (Map<String, String> dataTableMap : dataTableAsMap) {
				if (InstrumentTypeCode.contains("-")) {
					InstrumentTypeCode = InstrumentTypeCode.split("-")[0];
				} else {
					if (dataTableMap.get("INSTRUMENT_TYPE_CODE").contains("-")) {
						InstrumentTypeCode = dataTableMap.get("INSTRUMENT_TYPE_CODE").split("-")[0];
					} else {
						InstrumentTypeCode = dataTableMap.get("INSTRUMENT_TYPE_CODE");
					}
				}
				URL generatedURL = MessageGenerationFactory.getMessageGenerator(null, InstrumentTypeCode)
						.generateMessage(dataTableMap);
				MessageRegistrationFactory.getMessageRegistrationImpl(adapterType).publishMessage(InstrumentTypeCode,
						generatedURL);
			}

		}
	}

	@When("^I generate a message from template for \"([^\"]*)\" using datatable and publish on adapter \"([^\"]*)\" to change the (.*) of an instrument$")
	public void i_generate_a_message_from_template_for_using_datatable_and_publish_on_adapter_to_change_the_of_an_instrument(
			String template, String adapterType, String state, DataTable dataTable) throws Exception {
		if (state.equalsIgnoreCase("Not_Applicable")) {
			return;
		}
		List<Map<String, String>> dataTableAsMap = CoreUtil.convertDataTableToListOfMaps(dataTable);
		Map<String, String> copyMap = new LinkedHashMap<String, String>();
		for (Map<String, String> dataTableMap : dataTableAsMap) {
			copyMap.putAll(dataTableMap);
			String finalState = dataTableMap.get("toState");
			String[] stateToTransit = null;
			if (!state.contains("-")) {
				URL generatedURL = MessageGenerationFactory.getMessageGenerator(null, template)
						.generateMessage(dataTableMap);
				MessageRegistrationFactory.getMessageRegistrationImpl(adapterType).publishMessage(template,
						generatedURL);
			} else {
				stateToTransit = state.split("-");
				for (int eachStateindex = 1; eachStateindex < stateToTransit.length; eachStateindex++) {
					copyMap.put("toState", stateToTransit[eachStateindex]);
					URL generatedURL = MessageGenerationFactory.getMessageGenerator(null, template)
							.generateMessage(copyMap);
					MessageRegistrationFactory.getMessageRegistrationImpl(adapterType).publishMessage(template,
							generatedURL);
					// consume the Egress while doing the state transition to maintain the order of
					// message consumption in platform
					new DataTableBasedDefs().read_the_number_of_outgoing_messages_on_queue_for_message_type_and_store_in_scenario_context("1", "CDM_OUT", "inte_910_admi_007");
					List<String> listOfOutgoingMessages = ScenarioContext.getInstance().getListOfOutgoingISOMessages();
					for (String msg : listOfOutgoingMessages) {
						if (msg.contains(MessageConstants.BIZ_SVC_COMM_808)|| msg.contains(MessageConstants.BIZ_SVC_COMM_807)) {
							String log = String.format("Business Nack or Technical Nack found in List of outgoing messages .. - %s", msg);
							logger.debug(log);
							ScenarioContext.getInstance().setTestRunStatus(false);
						}
					}
				}
				copyMap.put("toState", finalState);
				URL generatedURL = MessageGenerationFactory.getMessageGenerator(null, template)
						.generateMessage(copyMap);
				MessageRegistrationFactory.getMessageRegistrationImpl(adapterType).publishMessage(template,generatedURL);
			}
		}
	}

	@When("^read the number of outgoing messages \"([^\"]*)\" on queue \"([^\"]*)\" for message type \"([^\"]*)\" and store in scenario context \"([^\"]*)\"$")
	public void read_the_number_of_outgoing_messages_on_queue_for_message_type_and_store_in_scenario_context(
			String numOfExpectedMsgs, String queueName, String messageType, String condition) throws Exception {
		boolean isStepRequired = Boolean.valueOf(condition.trim());
		if (isStepRequired || condition.equalsIgnoreCase("instrument")) {
			new DataTableBasedDefs()
					.read_the_number_of_outgoing_messages_on_queue_for_message_type_and_store_in_scenario_context(
							numOfExpectedMsgs, queueName, messageType);
		}
	}
}