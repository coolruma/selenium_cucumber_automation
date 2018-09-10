package com.asx.dlt.integration.tests.helpers.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Collectors;

import org.apache.commons.lang.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.asx.dlt.automation.core.config.ConfigContext;
import com.asx.dlt.automation.core.constants.CoreConstants;
import com.asx.dlt.automation.core.helpers.parsers.xml.XpathXmlParser;
import com.asx.dlt.automation.core.helpers.ssh.SSHClientWrapper;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.automation.core.jaxb.configs.AdapterType;
import com.asx.dlt.integration.tests.constants.DltConstants;
import com.asx.dlt.integration.tests.glue.TestScenarioSetup;

/**
 * This class holds all the methods to retrieve test execution details E.g. ASX
 * adapter, DA component versions, test env details, automation framework
 * version etc.
 * 
 * @author neo_k
 */
public class TestExecutionInfo {

	private static Logger logger = LogManager.getLogger(TestExecutionInfo.class.getName());

	/**
	 * This method retrieves the ASX adapter versions from the logs via grep
	 * 
	 * @return
	 * @throws Exception
	 */
	public static Map<String, String> getASXAdaptersVersionInfo() throws Exception {
		Map<String, String> adapterVersionMap = new HashMap<String, String>();

		List<String> adapterLogFiles = new ArrayList<String>();
		List<AdapterType> inboundAdapters = ConfigContext.getInstance().getEnvConfig().getInboundAdapters()
				.getAdapters();
		inboundAdapters.forEach(inAdapter -> adapterLogFiles.add(inAdapter.getService().getLogFile()));

		List<AdapterType> outboundAdapters = ConfigContext.getInstance().getEnvConfig().getOutboundAdapters()
				.getAdapters();
		outboundAdapters.forEach(outAdapter -> adapterLogFiles.add(outAdapter.getService().getLogFile()));

		List<String> commands = new ArrayList<String>();
		adapterLogFiles.forEach(logFileName -> commands.add("grep \"Artifact: com.asx.dah.integration.adapter\" "
				+ DltConstants.DLT_ASX_ADAPTERS_LOG + "/" + logFileName.replace(".log", "*.log") + " | tail -1 && "));

		String batchCmd = String.join("", commands).replaceAll("&& $", "");
		String cmdOutput = "";
		if (CoreUtil.isLocalExecution()) {
			cmdOutput = CoreUtil.executeCommandLocallyOnLinux(batchCmd);
		} else {
			SSHClientWrapper sshClient = SSHClientWrapper.getInstance();
			cmdOutput = sshClient.executeCommand(batchCmd);
		}

		if (CoreUtil.isStringNullOrEmpty(cmdOutput)) {
			logger.error("Error in extracting adapter version info. Cmd output is empty or null.");
		} else {
			adapterVersionMap = Arrays.asList(cmdOutput.split("\n")).stream().collect(
					Collectors.toMap(i -> i.split("\\.adapter\\.")[1].split("\\s+")[0], i -> StringUtils.right(i, 7)));
		}

		return adapterVersionMap;
	}

	public static File getVersionDetailsFile() {
		File versionDetails;
		if (CoreUtil.getExecutionLocation().equalsIgnoreCase(CoreConstants.EXECUTION_LOCAL)) {
			versionDetails = new File("reports/version.txt");
		} else {
			versionDetails = new File(".\\src\\test\\resources\\reports\\version.txt");
		}
		return versionDetails;
	}

	/**
	 * This method retrieves the details of the test server such as OS Host Name ,
	 * CPU processors etc)
	 *
	 * @return
	 * @throws Exception
	 */
	public static Map<String, String> getTestServerOSVersionDetails() throws Exception {
		Map<String, String> serverEnvDetails = new HashMap<String, String>();

		String cmd = "uname -a";

		String cmdOutput = "";
		if (CoreUtil.isLocalExecution()) {
			cmdOutput = CoreUtil.executeCommandLocallyOnLinux(cmd);
		} else {
			SSHClientWrapper sshClient = SSHClientWrapper.getInstance();
			cmdOutput = sshClient.executeCommand(cmd);
		}

		String[] output = cmdOutput.split(" ");
		serverEnvDetails.put("OS Name: ", output[0]);
		serverEnvDetails.put("OS Details: ", output[2]);
		serverEnvDetails.put("Hostname: ", output[1]);

		return serverEnvDetails;
	}

	/**
	 * This method fetches the testautomation framework version. There are 3 methods
	 * supported in the following order i) Fetch from pom.xml (for running tests in
	 * local env/IDE) ii) Fetch from pom.properties in JAR file (for maven build)
	 * iii) Fetch from MANIFEST.MF file
	 *
	 * @return version of the test automation framework
	 */
	public final static String getTestAutomationVersion() {

		Class refTestClass = new TestScenarioSetup().getClass();

		// Solution referenced from
		// https://stackoverflow.com/questions/2712970/get-maven-artifact-version-at-runtime,
		// with minor tweak.
		// First, try to get version number from pom.xml (e.g. for when running tests
		// locally from IDE)
		try {
			String className = refTestClass.getName();
			String classFileName = "/" + className.replace('.', '/') + ".class";
			URL classfileResource = refTestClass.getResource(classFileName);
			if (classfileResource != null) {
				Path absolutePackagePath = Paths.get(classfileResource.toURI()).getParent();
				int packagePathSegments = className.length() - className.replace(".", "").length();
				// Remove package segments from path, plus two more levels
				// for "target/classes", which is the standard location for
				// classes in Java IDE (Eclipse/IntelliJ).
				Path path = absolutePackagePath;
				for (int i = 0, segmentsToRemove = packagePathSegments + 2; i < segmentsToRemove; i++) {
					path = path.getParent();
				}
				Path pom = path.resolve("pom.xml");
				try (InputStream is = Files.newInputStream(pom)) {
					XpathXmlParser xmlParser = new XpathXmlParser(is);
					String version = xmlParser.getValueForXpath("/project/version");
					if (version != null) {
						version = version.trim();
						if (!version.isEmpty()) {
							return version;
						}
					}
				}
			}
		} catch (Exception e) {
			logger.warn("Error when reading version info from pom.xml" + e.getMessage());
		}

		// Next - try to get version number from maven properties in jar's META-INF
		// (e.g. when running tests using MAVEN jar)
		try (InputStream is = refTestClass.getResourceAsStream(
				"/META-INF/maven/" + "com.asx.dlt.integration.tests/testautomation/pom.properties")) {
			if (is != null) {
				Properties p = new Properties();
				p.load(is);
				String version = p.getProperty("version", "").trim();
				if (!version.isEmpty()) {
					return version;
				}
			}
		} catch (Exception e) {
			logger.warn("Error when reading version info from pom.properties (maven)" + e.getMessage());
		}

		// Lastly if version still not found - Fallback to using Java API to get version
		// from MANIFEST.MF
		String version = null;
		Package pkg = refTestClass.getPackage();
		if (pkg != null) {
			version = pkg.getImplementationVersion();
			if (version == null) {
				version = pkg.getSpecificationVersion();
			}
		}
		version = version == null ? "" : version.trim();
		return version.isEmpty() ? "unknown" : version;
	}

	public static List<String> getTestExecutionDetails() throws Exception {
		logger.info("Logging test execution details..");

		List<String> execDetails = new ArrayList<>();

		Map<String, String> adapterVersionMap = getASXAdaptersVersionInfo();
		Map<String, String> testServerDetailsMap = getTestServerOSVersionDetails();

		String header = "#####################################################################";
		String prefix = "########";
		String suffix = "";
		String indent = "        ";
		execDetails.add(header);
		execDetails.add(String.format("%s%s ********* AUTOTEST EXECUTION DETAILS ******** %s%s", prefix, indent, indent,
				suffix));

		execDetails.add(String.format("%s%s ********* Test Automation Framework ******** %s%s", prefix, indent, indent,
				suffix));
		execDetails.add(String.format("%s%s Artefact: 'testautomation', Version: " + " %s%s", prefix, indent,
				getTestAutomationVersion(), indent, suffix));

		if (!adapterVersionMap.isEmpty()) {
			execDetails.add(String.format("%s%s ********* ASX Adapters ******** %s%s", prefix, indent, indent, suffix));
			adapterVersionMap.forEach(
					(adapter, version) -> execDetails.add(String.format("%s%s ASX Adapter: %s, Version: %s %s%s",
							prefix, indent, adapter, version, indent, suffix)));
		}

		if (!testServerDetailsMap.isEmpty()) {
			execDetails.add(
					String.format("%s%s ********* Test Server Details ******** %s%s", prefix, indent, indent, suffix));
			testServerDetailsMap.forEach((server, detail) -> execDetails
					.add(String.format("%s%s %s : %s %s%s", prefix, indent, server, detail, indent, suffix)));
		}
		execDetails.add(header);
		File versionDetails = getVersionDetailsFile();
		if (!versionDetails.exists()) {
			versionDetails.createNewFile();
		}
		FileWriter fw = new FileWriter(versionDetails.getAbsoluteFile());
		BufferedWriter bw = new BufferedWriter(fw);
		bw.write(String.join("\n", execDetails));
		bw.close();

		return execDetails;
	}

}
