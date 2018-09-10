package com.asx.dlt.integration.tests.helpers.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.apache.commons.lang.StringUtils;

import com.asx.dlt.automation.core.cache.FrameworkCache;
import com.asx.dlt.automation.core.config.ConfigContext;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.integration.tests.constants.DltConstants;
import com.asx.dlt.integration.tests.constants.TestDataConstants;

/**
@author kamboj_a
*/
public class FrameworkUtil {
	
	/**
	 * This method generates ISIN based on given assetSymbol. Two ways to generate ISIN based on whether 'Pre-Condition' mechanism is used.
	 * 	   1. Where the 'Pre-Condition' is NOT used, AssetSymbol is required to be reversible from ISIN for further verification. AssetSymbol will become part of ISIN.
	 * 	   2. Where the 'Pre-Condition' is in used, the length of AssetSymbol is much longer than normal, different mechanism of ISIN generation is in place to (attempt to) guarantee uniqueness of ISIN.
	 * @param assetSymbol : asset symbol
	 * @return ISIN string in a valid ISIN format i.e.  [CountryCode(2)] + [Alpha Numeric string(9)] + [checksum(1)]
	 */
	public static String getISIN(String assetSymbol) {
		String tempISIN;

		String executionUID = System.getProperty(TestDataConstants.EXEC_UID);

		//1. where 'Pre-Condition' is NOT used, ISIN will be in format of [CountryCode(2)] + [0's] + [AssetSymbol(upto 9)] + [checksum(1)] e.g. AU00000NABR0
		if (CoreUtil.isStringNullOrEmpty(executionUID) || !assetSymbol.contains(executionUID)) {
			if (assetSymbol.length() <= 9) {
				// 1.1. add two letter country code and leading zeroes to asset symbol to make it nine character long
				tempISIN = "AU" + StringUtils.leftPad(assetSymbol.toUpperCase(), 9, "0");

				// 1.2. suffix with check sum
				tempISIN += getISINCheckSum(tempISIN);

				FrameworkCache.getInstance().addSecurityPair(assetSymbol, tempISIN);

			} else {
				throw new RuntimeException(String.format("ISIN generation: AssetSymbol '%s' is too long. Supported length is up to 9 characters.",assetSymbol));
			}
		}
		else{
			//2. where 'Pre-Condition' is used, ISIN will be in format of [CountryCode(2)] + [dHHmmssSS(9)] + [checksum(1)]
			try {

				//2.1 check if the value has existed
				tempISIN = FrameworkCache.getInstance().getISIN(assetSymbol);

				//2.2 generate if it is not existing
				if (CoreUtil.isStringNullOrEmpty(tempISIN)) {
					CoreUtil.sleep(10);
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("ddHHmmssSS");
					tempISIN = "AU" + LocalDateTime.now().format(formatter).substring(1, 10);  //dHHmmssSS
					tempISIN += getISINCheckSum(tempISIN);

					FrameworkCache.getInstance().addSecurityPair(assetSymbol, tempISIN);
				}

			} catch (Exception e) {
				throw new RuntimeException(String.format("getISIN: ISIN cannot be generated / retrieved from AssetSymbol '%s'.",assetSymbol));

			}
		}
		return tempISIN;
	}

	/**
	 * This method returns ISIN checksum value given the first 11 characters of ISIN.
	 * The calculation is based on ISIN standard checksum calculation - https://en.wikipedia.org/wiki/International_Securities_Identification_Number
	 * @param isin11charString first 11 characters of ISIN
	 * @return ISIN checksum value
	 */
	private static String getISINCheckSum(String isin11charString) {

		// 1. validate input ISIN string
		if (isin11charString.length()!=11){
			throw new RuntimeException("Number of input characters must be equal to 11");
		}
		// 2. convert all the characters into numbers. Eg :  U = 30, S = 28. US037833100 -> 30 28 037833100
		int i=0;
		String checkSumDigits = "";
		while(i<11){
			char ch = isin11charString.charAt(i);
			if (ch >= '0' && ch <= '9'){
				checkSumDigits = checkSumDigits + ch;
			}

			else if(ch >= 'A' && ch <= 'Z') {
				checkSumDigits = checkSumDigits + (10 + (int)ch - (int) 'A');
			}
			else {
				throw new RuntimeException("Special character and symbols are not allowed in ISIN");
			}
			i++;
		}

		// 3. calculating sum from odd char and even char counting from RHS.
		int sum = 0;
		for(int j=0; j != checkSumDigits.length(); j++) {

			if (j % 2 == 0) { // Odd  (index start from 0)
				sum += Integer.parseInt(checkSumDigits.charAt(j)+"");

			} else { // Even
				int individual = Integer.parseInt(checkSumDigits.charAt(j)+"") * 2;
				sum += (individual > 9) ? (1 + individual - 10) : individual;
			}
		}

		// 4. calculate 'CheckSum' digit
		int checksum = ((sum % 10) == 0) ? 0 : 10 - (sum % 10);

		return checksum + "";
	}

	/**
	 * This method return AssetSymbol from given ISIN. AssetSymbol / ISIN pairs are cached under SecuritiesData class if they are created within the same execution.
	 * @param ISIN e.g. AU0153325990
	 * @return AssetSymbol e.g. NABR
	 */
	public static String getSymbolFromISIN(String ISIN){
		String symbol = "";
		if(!CoreUtil.isStringNullOrEmpty(ISIN)){

			symbol = FrameworkCache.getInstance().getAssetSymbol(ISIN);

			//If the instrument was created from prior round of testing and not via pre-condition mechanism e.g. AU00000NABR0
			if (CoreUtil.isStringNullOrEmpty(symbol)) {
				//1. Remove CountryCode (first 2 chars) and following leading 0s
				//2. Remove last digit checksum
				symbol = ISIN.replaceAll("^..0*","").replaceAll(".$", "");
			}
		}

		return symbol;
	}
	
	public static String getDynamicDateProperty(String runtimeDateKey, String runtimeDateValue){
		return runtimeDateKey + runtimeDateValue.replaceAll("\\+","plus").replaceAll("\\-","minus");
	}
	
	public static void cleanupExecId() {
		System.setProperty(TestDataConstants.EXEC_UID, "");
	}
	
	/**
	 * Method to perform a short wait. The wait time is fetched from
	 * EnvironmentConfig.xml file, and if not configured will default to
	 * DLTConstants
	 * 
	 * @author neo_k
	 * @throws InterruptedException
	 */
	public static void shortWait() throws InterruptedException {

		int sleepTime = DltConstants.SHORT_WAIT; // default sleepTime
		try {
			sleepTime = Integer.parseInt(ConfigContext.getInstance().getEnvTestConfigParam("ShortWait"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		CoreUtil.sleep(sleepTime);
	}

}
