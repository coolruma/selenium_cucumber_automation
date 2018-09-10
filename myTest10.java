package com.asx.dlt.integration.tests.helpers.util;

import com.asx.dlt.automation.core.definitions.DefinitionExtractor;
import com.asx.dlt.automation.core.definitions.xml.XmlDefinitionLoader;
import com.asx.dlt.automation.core.helpers.parsers.xml.XpathXmlParser;
import com.asx.dlt.automation.core.helpers.parsers.xml.XpathXmlUpdator;
import com.asx.dlt.automation.core.helpers.util.CoreUtil;
import com.asx.dlt.automation.core.helpers.util.TestDataLoader;
import com.asx.dlt.integration.tests.constants.MessageConstants;
import com.asx.dlt.integration.tests.constants.TestDataConstants;
import org.w3c.dom.Node;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * XML message wrapper util that currently handles addition of ESB header, and removal of BAH/BMW header
 * @author neo_k
 */
public class XMLMessageWrapperUtil {

    private static XMLMessageWrapperUtil _msgUtil;
    private static String esbTemplateFileName;
    private static String bmwBahTemplateFileName;

    public static XMLMessageWrapperUtil getInstance() {
        if(_msgUtil == null) {
            _msgUtil = new XMLMessageWrapperUtil();
        }
        return _msgUtil;
    }

    private XMLMessageWrapperUtil() {
        esbTemplateFileName = XmlDefinitionLoader.getInstance().getXmlMessageType(MessageConstants.BIZ_SVC_INTE_902).getFileName();
        bmwBahTemplateFileName = XmlDefinitionLoader.getInstance().getXmlMessageType(MessageConstants.BMW_XMLType).getFileName();
    }

    public String addBMWBAHWrapperToXML(String msgDocXml) throws Exception {
        String bahXpath = DefinitionExtractor.getInstance().getXmlDefinitionMap(MessageConstants.BMW_XMLType).get(TestDataConstants.ROOT_DOC);

        XpathXmlUpdator bizMsgUpdator = new XpathXmlUpdator(TestDataLoader.getInstance().getTemplatePath(bmwBahTemplateFileName).getPath());
        bizMsgUpdator.importNodeFromXmlDoc(getXpathIgnoreNS(bahXpath), msgDocXml);
        return bizMsgUpdator.writeToString();
    }

    /**
     * This method will extract the RootDoc from the target file and therefore excludes the BAH/BMW wrapper from the resulting Node.
     * NB - This will need the "RootDoc" xpath to be defined for all CDM message xml definitions
     * @param messageType
     * @param originalFileUrl
     * @return
     * @throws Exception
     */
    public String removeBAHBMWFromMessage(String messageType,URL originalFileUrl) throws Exception {
        String rootDocXpath = DefinitionExtractor.getInstance().getXmlDefinitionMap(messageType).get(TestDataConstants.ROOT_DOC);

        if(CoreUtil.isStringNullOrEmpty(rootDocXpath))
            throw new Exception(String.format("No 'RootDoc' xpath found for messageType: %s. Please add 'RootDoc' xpath for this messageType in XMLDefinition.xml",messageType));
        XpathXmlParser xmlExtractor = new XpathXmlParser(CoreUtil.convertURLToInputSream(originalFileUrl));
        Node rootDoc = xmlExtractor.getNodeForXpath(getXpathIgnoreNS(rootDocXpath));
        return convertNodeToString(rootDoc);
    }

    /**
     * Update original xml to exclude BAH/BMW wrapper and write to a new file with original file name + "-ExcludeBMWAndBAH" suffix.
     * @param originalFileUrl
     * @return
     * @throws Exception
     */
    public URL removeBAHBMWAndWriteToFile(String messageType,URL originalFileUrl) throws Exception {
        String updatedMsg = removeBAHBMWFromMessage(messageType,originalFileUrl);
        return CoreUtil.writeMessageToFile(updatedMsg,new File(originalFileUrl.toURI().getPath().replace(".xml","-NoBMWAndBAH.xml")).toURI());
    }

    /**
     * This method will extract the RootDoc from the target file and therefore excludes the BAH/BMW wrapper from the resulting Node.
     * NB - This will need the "RootDoc" xpath to be defined for all CDM message xml definitions
     * @param messageType
     * @param msgXML
     * @return
     * @throws Exception
     */
    public String removeBAHBMWFromMessage(String messageType, String msgXML) throws Exception {
        String rootDocXpath = DefinitionExtractor.getInstance().getXmlDefinitionMap(messageType).get(TestDataConstants.ROOT_DOC);
        if(CoreUtil.isStringNullOrEmpty(rootDocXpath))
            throw new Exception(String.format("No 'RootDoc' xpath found for messageType: %s. Please add 'RootDoc' xpath for this messageType in XMLDefinition.xml",messageType));

        XpathXmlParser xmlExtractor = new XpathXmlParser(CoreUtil.convertStringToInputSream(msgXML));
        Node rootDoc = xmlExtractor.getNodeForXpath(getXpathIgnoreNS(rootDocXpath));
        return convertNodeToString(rootDoc);
    }


    public String addESBWrapperToXML(String msgDocXml) throws Exception {
        return addESBWrapperToXML(msgDocXml,null);
    }


    public String addESBWrapperToXML(String msgDocXml, String overrideEsbTemplateFileName) throws Exception {
        String esbBodyXpath = DefinitionExtractor.getInstance().getXmlDefinitionMap(MessageConstants.BIZ_SVC_INTE_902).get(TestDataConstants.ESB_Body);

        String esbTemplateName = CoreUtil.isStringNullOrEmpty(overrideEsbTemplateFileName) ?
                                    TestDataLoader.getInstance().getTemplatePath(esbTemplateFileName).getPath() :
                                    TestDataLoader.getInstance().getTemplatePath(overrideEsbTemplateFileName).getPath();
        XpathXmlUpdator esbXmlUpdator = new XpathXmlUpdator(esbTemplateName);

        esbXmlUpdator.importNodeFromXmlDoc(getXpathIgnoreNS(esbBodyXpath), msgDocXml);
        return esbXmlUpdator.writeToString();
    }


    public String removeESBWrapperFromXML(String content) throws Exception {
        String esbBodyXpath = DefinitionExtractor.getInstance().getXmlDefinitionMap(MessageConstants.BIZ_SVC_INTE_902).get(TestDataConstants.ESB_Body);

        XpathXmlParser xmlExtractor = new XpathXmlParser(new ByteArrayInputStream(content.getBytes(StandardCharsets.UTF_8)));
        Node esbBodyNode = xmlExtractor.getNodeForXpath(getXpathIgnoreNS(esbBodyXpath));
        String nodeName = esbBodyNode.getNodeName();
        return convertNodeToString(esbBodyNode).replace("<" + nodeName + ">","").replace("</" + nodeName + ">","");
    }

    /**
     * Update original xml with the wrapper and write to a new file with original file name + "-ESB" suffix.
     * @param originalFileUrl
     * @return
     * @throws Exception
     */
    public URL addESBWrapperToXML(URL originalFileUrl) throws Exception {
        String updatedMsg = addESBWrapperToXML(CoreUtil.getXmlAsStringFromFile(originalFileUrl));
        return CoreUtil.writeMessageToFile(updatedMsg,new File(originalFileUrl.toURI().getPath().replace(".xml","-ESB.xml")).toURI());
    }

    /**
     * Update original xml with the wrapper and write to a new file with original file name + "-ESB" suffix.
     * @param originalFileUrl
     * @return
     * @throws Exception
     */
    public URL addESBWrapperToXML(URL originalFileUrl,String overrideEsbTemplateName) throws Exception {
        String updatedMsg = addESBWrapperToXML(CoreUtil.getXmlAsStringFromFile(originalFileUrl),overrideEsbTemplateName);
        return CoreUtil.writeMessageToFile(updatedMsg,new File(originalFileUrl.toURI().getPath().replace(".xml","-ESB.xml")).toURI());
    }


    /**
     * Re-construct xpath that will be agnostic to any namespaces
     * @param xPathXpression
     * @return updated xpath
     *
     */
    private String getXpathIgnoreNS(String xPathXpression){
        String xpathIgnoringNs = "";
        String[] pathSegments = xPathXpression.split("/");
        for(int i=0; i<pathSegments.length; i++){
            if(!CoreUtil.isStringNullOrEmpty(pathSegments[i]))
                xpathIgnoringNs += "/" + "*[local-name()='" + pathSegments[i] + "']";
        }
        xPathXpression = "/" + xpathIgnoringNs;
        return xPathXpression;
    }

    private String convertNodeToString(Node node) {
        StringWriter sw = new StringWriter();
        try {
            Transformer t = TransformerFactory.newInstance().newTransformer();
            t.setOutputProperty(OutputKeys.INDENT, "yes");
            t.transform(new DOMSource(node), new StreamResult(sw));
        } catch (TransformerException te) {
            System.out.println("Transformer Exception");
        }
        return sw.toString();
    }

}
