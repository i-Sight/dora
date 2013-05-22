package com.gregorbyte.GitFiltersForNSF;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.xml.sax.SAXException;
import org.w3c.dom.Document;

// For write operation
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;

public class Clean {

    // Global value so it can be ref'd by the tree-adapter
    static 	Document document;
     
    public static void main(String[] argv) {    	    
    
    	boolean useStdIn 	= true;
    	boolean useRes		= true;
    	
    	/*
    	 * If no arguments supplied, then use Standard Input and Bundled xsl
    	 * If 1 argument supplied then use that is the input file
    	 * IF 2 arguments supplied then use first as file and second as xsl
    	 */
    	
    	if (argv.length == 1) { 
    		useStdIn = false;
    	} else if (argv.length == 2) {
    		useStdIn 	= false;
    		useRes 		= false;
    	} else if (argv.length != 0) {
            System.err.println("Usage: java Clean xmlfile [xsl]");
            System.exit(1);
        }

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

        //factory.setNamespaceAware(true);
        //factory.setValidating(true);
        
        try {

            DocumentBuilder builder = factory.newDocumentBuilder();
            
            if (useStdIn) {
            	document = builder.parse(System.in);
            } else {
                File datafile = new File(argv[0]);
                document = builder.parse(datafile);            	
            }
            
            StreamSource stylesource = null;
            
            if (useRes) {            	
            	InputStream xslStream = Clean.class.getClass().getResourceAsStream("/com/gregorbyte/GitFiltersForNSF/xsl/nsfclean.xsl");
                stylesource = new StreamSource(xslStream);
            } else {
                File stylesheet = new File(argv[1]);
                stylesource = new StreamSource(stylesheet);            	
            }

            // Use a Transformer for output
            TransformerFactory tFactory = TransformerFactory.newInstance();
            Transformer transformer = tFactory.newTransformer(stylesource);
            
            DOMSource source = new DOMSource(document);
            StreamResult result = new StreamResult(System.out);
            transformer.transform(source, result);
            
        } catch (TransformerConfigurationException tce) {

        	// Error generated by the parser
            System.out.println("\n** Transformer Factory error");
            System.out.println("   " + tce.getMessage());

            // Use the contained exception, if any
            Throwable x = tce;

            if (tce.getException() != null) {
                x = tce.getException();
            }

            x.printStackTrace();
            
        } catch (TransformerException te) {
            // Error generated by the parser
            System.out.println("\n** Transformation error");
            System.out.println("   " + te.getMessage());

            // Use the contained exception, if any
            Throwable x = te;

            if (te.getException() != null) {
                x = te.getException();
            }

            x.printStackTrace();
        } catch (SAXException sxe) {
            // Error generated by this application
            // (or a parser-initialization error)
            Exception x = sxe;

            if (sxe.getException() != null) {
                x = sxe.getException();
            }

            x.printStackTrace();
        } catch (ParserConfigurationException pce) {
            // Parser with specified options can't be built
            pce.printStackTrace();
        } catch (IOException ioe) {
            // I/O error
            ioe.printStackTrace();
        }
    } // main
}