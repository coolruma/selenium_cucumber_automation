package com.asx.dlt.integration.tests.glue.datatable;

import java.util.List;
import java.util.Map;

import com.asx.dlt.automation.core.config.ConfigContext;
import com.asx.dlt.automation.core.constants.CoreConstants;
import com.asx.dlt.automation.core.drivers.AdapterDriverFactory;
import com.asx.dlt.automation.core.drivers.OutboundAdapterDriver;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.integration.tests.constants.MessageConstants;
import com.asx.dlt.integration.tests.glue.TestScenarioSetup;
import com.asx.dlt.integration.tests.helpers.localcache.ScenarioContext;
import com.asx.dlt.integration.tests.helpers.util.TestUtil;
import com.asx.dlt.integration.tests.validationengine.xml.datatablevalidation.EgressXmlValidationFactory;

import cucumber.api.DataTable;
import cucumber.api.PendingException;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;

/**
 * @author kamboj_a
 */
public class DataTableBasedDefs {

	@Then("^verify number of outgoing message \"([^\"]*)\" on queue \"([^\"]*)\" for message type \"([^\"]*)\" with the following table$")
	public void verify_outgoing_message_on_queue_for_message_type_with_the_following_table(String numOfExpectedMsgs, String queueName,
			String messageType, DataTable dataTable) throws Throwable {
		List<Map<String, String>> dataTableAsMap = CoreUtil.convertDataTableToListOfMaps(dataTable);
		List<String> listOfOutgoingMessages = null;
		if (messageType.equalsIgnoreCase(MessageConstants.BIZ_SVC_COMM_807)||messageType.equalsIgnoreCase(MessageConstants.BIZ_SVC_COMM_808)) {
			return;
		}
		int numOfExpMsg = Integer.parseInt(numOfExpectedMsgs);
		ScenarioContext.getInstance().updateEgressAdapterList(queueName);
		OutboundAdapterDriver adapterDriver = AdapterDriverFactory.getOutboundAdapterDriver(queueName);
		
		listOfOutgoingMessages = adapterDriver.readData(CoreConstants.ESB_READ_TIMEOUT_IN_SECS, TestScenarioSetup.getScenario(), numOfExpMsg);
		ScenarioContext.getInstance().setListOfOutgoingISOMessages(listOfOutgoingMessages);
		
		// Get all the messages from the list for this scenario
		listOfOutgoingMessages = ScenarioContext.getInstance().getListOfOutgoingISOMessages();
		EgressXmlValidationFactory.getEgressValidator(messageType).verify(dataTableAsMap, listOfOutgoingMessages);
		TestUtil.evaluateValidationResults();
	}
	
	@Then("^verify number of outgoing messages \"([^\"]*)\" on queue \"([^\"]*)\" for message type \"([^\"]*)\" with the following datatable and validate the schema of the outgoing message$")
	public void verify_outgoing_message_on_queue_for_message_type_with_the_following_table_and_validate_the_schema_of_the_outgoing_message(
			String numOfExpectedMsgs, String queueName, String messageType, DataTable dataTable) throws Throwable {
	    verify_outgoing_message_on_queue_for_message_type_with_the_following_table(numOfExpectedMsgs, queueName, messageType, dataTable);
	}
	
	@Then("^Verify the \"([^\"]*)\" report in ODS for the following attributes from the below table$")
	public void verify_the_report_for_the_following_attributes_from_the_below_table(String arg1, DataTable arg2) throws Exception {
	    throw new PendingException();
	}
	@Then("^Verify the \"([^\"]*)\" report doesn't exist in ODS for the following attributes from the below table$")
	public void verify_the_report_not_exist_for_the_following_attributes_from_the_below_table(String arg1, DataTable arg2) throws Exception {
		throw new PendingException();
	}

	@Given("^read the number of outgoing messages \"([^\"]*)\" on queue \"([^\"]*)\" for message type \"([^\"]*)\" and store in scenario context$")
	public void read_the_number_of_outgoing_messages_on_queue_for_message_type_and_store_in_scenario_context(String numOfExpectedMsgs, String queueName, String messageType) throws Exception {
		int numOfExpMsg = Integer.parseInt(numOfExpectedMsgs);
		OutboundAdapterDriver adapterDriver = AdapterDriverFactory.getOutboundAdapterDriver(queueName);
		List<String> listOfOutgoingMessages=adapterDriver.readData(CoreConstants.ESB_READ_TIMEOUT_IN_SECS,TestScenarioSetup.getScenario(), numOfExpMsg);
		ScenarioContext.getInstance().setListOfOutgoingISOMessages(listOfOutgoingMessages);
	}
	
	@Then("^verify NACK with number of messages \"([^\"]*)\" on outbound queue of \"([^\"]*)\" and on poison queue of inbound adapter \"([^\"]*)\" with message type \"([^\"]*)\"$")
	public void verify_nack_with_number_of_messages_something_on_outbound_queue_of_something_and_on_poison_queue_of_inbound_adapter_something_with_message_type_something(
			String numOfMessages, String outboundAdapter, String inboundAdapter, String messageType, DataTable dataTable) throws Throwable {		
		if (!(messageType.equalsIgnoreCase(MessageConstants.BIZ_SVC_COMM_807)||messageType.equalsIgnoreCase(MessageConstants.BIZ_SVC_COMM_808))) {
			return;
		}
		List<Map<String, String>> dataTableAsMap = CoreUtil.convertDataTableToListOfMaps(dataTable);
		List<String> listOfOutgoingMessages = ScenarioContext.getInstance().getListOfOutgoingISOMessages();
		if (!(ConfigContext.getInstance().getTestMode().equalsIgnoreCase(CoreConstants.TEST_MODES.DA.name()) 
				&& messageType.equalsIgnoreCase(MessageConstants.BIZ_SVC_COMM_807))) {
			int numOfExpMsg = Integer.parseInt(numOfMessages);
			ScenarioContext.getInstance().updateEgressAdapterList(outboundAdapter);
			OutboundAdapterDriver adapterDriver = AdapterDriverFactory.getOutboundAdapterDriver(outboundAdapter);
			if (listOfOutgoingMessages == null) {
				listOfOutgoingMessages = adapterDriver.readData(CoreConstants.ESB_READ_TIMEOUT_IN_SECS,
						TestScenarioSetup.getScenario(), numOfExpMsg);
				ScenarioContext.getInstance().setListOfOutgoingISOMessages(listOfOutgoingMessages);
			} else {
				listOfOutgoingMessages.addAll(adapterDriver.readData(CoreConstants.ESB_READ_TIMEOUT_IN_SECS,
						TestScenarioSetup.getScenario(), numOfExpMsg));
				ScenarioContext.getInstance().setListOfOutgoingISOMessages(listOfOutgoingMessages);
			}
			listOfOutgoingMessages = ScenarioContext.getInstance().getListOfOutgoingISOMessages();
		}
		ScenarioContext.getInstance().updateIngressAdapterList(inboundAdapter);
		EgressXmlValidationFactory.getNACKValidator(messageType, inboundAdapter).verify(dataTableAsMap, listOfOutgoingMessages);
		TestUtil.evaluateValidationResults();
	}
	
	@Given("^I generate a message from template for \"([^\"]*)\" using datatable and publish FIXAEMessage on \"([^\"]*)\"  adapter$")
	public void i_generate_a_message_from_template_for_using_datatable_and_publish_FIXAEMessage_on_adapter(String arg1, String arg2, DataTable arg3) {
	    throw new PendingException();
	}

	@Then("^Verify the trade AR acknowledgement message recieved \"([^\"]*)\" on adapter type \"([^\"]*)\" for given \"([^\"]*)\" with error message \"([^\"]*)\"$")
	public void verify_the_trade_AR_acknowledgement_message_recieved_on_adapter_type_for_given_with_error_message(String arg1, String arg2, String arg3, String arg4) {
	    throw new PendingException();
	}
	
}
