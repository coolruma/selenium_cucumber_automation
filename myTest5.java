package com.asx.dlt.integration.tests.helpers.asxadapters;

import java.io.File;

import javax.xml.bind.JAXBException;

import com.asx.dlt.automation.core.config.ConfigContext;
import com.asx.dlt.automation.core.constants.CoreConstants;
import com.asx.dlt.automation.core.helpers.executor.CommandExecutor;
import com.asx.dlt.automation.core.helpers.executor.CommandExecutorFactory;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.automation.core.jaxb.configs.AdapterType;

/**
@author kamboj_a
*/
public class AsxAdaptersController {
	
	private String outFileName = "AsxAdaptersControllerOut";
	private CommandExecutor commandExecutor = null;
	private static AsxAdaptersController asxAdaptersController = null;
	private String IN_DIR = CoreConstants.DLT_REMOTE_ACTIVE_CONTRACTS_CMD_DIR;
	private String OUT_DIR = null;
	private String redirectionFileName =  null;
	private String redirection = ">"; 
	private String START = "start -m primary -r yes";
	private String STATUS = "status";
	private String STOP = "stop";
	private String SPACE = " ";
	private String redirectTo = null; 
	private String downloadedFilePath = IN_DIR + File.separator + outFileName; 
	
	
	
	private AsxAdaptersController() {
		try {
			commandExecutor = CommandExecutorFactory.getCommandExecutorInstance();
		} catch (Exception e) {
			throw new RuntimeException("Unable to launch command executor. " + e.getMessage(), e);
		}
	}
	
	public static AsxAdaptersController getInstance() {
		if (asxAdaptersController == null) {
			asxAdaptersController = new AsxAdaptersController();
		}
		return asxAdaptersController;
	}
	
	public String startAdapter(AsxAdaptersInfo adapterInfo) throws Exception {
		commandExecutor.executeCommand(getAdapterCommandToRun(adapterInfo, START));
		commandExecutor.downloadFileToRemoteMachine(redirectionFileName, IN_DIR);
		return CoreUtil.readFile(downloadedFilePath);
	}
	
	public String stopAdapter(AsxAdaptersInfo adapterInfo) throws Exception {
		commandExecutor.executeCommand(getAdapterCommandToRun(adapterInfo, STOP));
		commandExecutor.downloadFileToRemoteMachine(redirectionFileName, IN_DIR);
		return CoreUtil.readFile(downloadedFilePath);
	}
	
	public String getAdapterStatus(AsxAdaptersInfo adapterInfo) throws Exception {
		commandExecutor.executeCommand(getAdapterCommandToRun(adapterInfo, STATUS));
		commandExecutor.downloadFileToRemoteMachine(redirectionFileName, IN_DIR);
		return CoreUtil.readFile(downloadedFilePath);
	}
	
	private AdapterType getAdapterType(String name) throws JAXBException {
		AdapterType adapterType = ConfigContext.getInstance().getInboundAdapterType(name);
		if (adapterType == null) {
			throw new RuntimeException("Adapter Name not found in config - " + name);
		}
		OUT_DIR = adapterType.getService().getAdapterHomeDir();
		redirectionFileName =  OUT_DIR + CoreConstants.LINUX_FILE_SEPARATOR + outFileName;
		redirectTo = SPACE + redirection + SPACE + redirectionFileName;
		return adapterType;
	}
	
	private String getAdapterHomeDirPath(String name) throws JAXBException {
		return getAdapterType(name).getService().getAdapterHomeDir();
	}
	
	private String getAdapterCommandToRun(AsxAdaptersInfo adapterInfo, String execute) throws Exception {
		String homeDirPath = getAdapterHomeDirPath(adapterInfo.name());
		return homeDirPath + CoreConstants.LINUX_FILE_SEPARATOR + adapterInfo.startStopCommand + SPACE + execute + redirectTo;
	}
	
	public enum AsxAdaptersInfo {
		ASXML("asxml.sh"),
		CDM("cdm.sh"),
		ISO("iso.sh");
		
		private String startStopCommand;
		private AsxAdaptersInfo(String command) {
			this.startStopCommand = command;
		}
		public String getStartStopCommand() {
			return this.startStopCommand;
		}
	}
}
