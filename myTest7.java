package com.asx.dlt.integration.tests.helpers.util;

import java.io.File;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.asx.dlt.automation.core.config.ConfigContext;
import com.asx.dlt.automation.core.constants.CoreConstants;
import com.asx.dlt.automation.core.drivers.AdapterDriverFactory;
import com.asx.dlt.automation.core.drivers.InboundAdapterDriver;
import com.asx.dlt.automation.core.drivers.OutboundAdapterDriver;
import com.asx.dlt.automation.core.drivers.esb.AdapterLogMessageHandler;
import com.asx.dlt.automation.core.jaxb.configs.AdapterType;

/**
 * @author kamboj_a
 */
public class PrepareSystem {

	private static Logger logger = LogManager.getLogger(PrepareSystem.class.getName());

	public static void performCleanupAndSetup() throws Exception {
		// Clean all the output queues before tests starts
		String testMode = ConfigContext.getInstance().getTestMode();
		if (testMode.equals(CoreConstants.TEST_MODES.DA.name())) {
			cleanIA();
		} else {
			cleanOutputQueues();
		}

	}

	private static void cleanOutputQueues() throws Exception {
		OutboundAdapterDriver adapterDriver = null;
		List<AdapterType> adapterList = ConfigContext.getInstance().getEnvConfig().getOutboundAdapters().getAdapters();
		for (AdapterType eachAdapterType : adapterList) {
			logger.debug("Cleaning output queue for adapter -- " + eachAdapterType.getName());
			if (eachAdapterType.getOutputQueue() != null) {
				adapterDriver = AdapterDriverFactory.getOutboundAdapterDriver(eachAdapterType.getName());
				adapterDriver.cleanQueue();
				((AdapterLogMessageHandler)adapterDriver).cleanLoggingQueue();
			}
		}
		List<AdapterType> inadapterList = ConfigContext.getInstance().getEnvConfig().getInboundAdapters().getAdapters();
		InboundAdapterDriver inAdaptor = null;
		for (AdapterType eachAdapterType : inadapterList) {
			logger.debug("Cleaning poison queue for adapter -- " + eachAdapterType.getName());
			if (eachAdapterType.getError() != null) {
				inAdaptor = AdapterDriverFactory.getInboundAdapterDriver(eachAdapterType.getName());
				inAdaptor.cleanPoisonQueue();
				((AdapterLogMessageHandler)inAdaptor).cleanLoggingQueue();
			}
		}
	}

	private static void cleanIA() throws Exception {
		AdapterDriverFactory.getInboundAdapterDriver(CoreConstants.CDM).cleanPoisonQueue();
		OutboundAdapterDriver adapterDriver = AdapterDriverFactory.getOutboundAdapterDriver(CoreConstants.CDM_OUT);
		adapterDriver.cleanQueue();
	}
}