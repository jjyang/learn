<%@page import="javax.servlet.*" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*,java.text.*" %>
<%@page import="javax.xml.parsers.*,org.w3c.dom.*" %>
<%@page import="javax.xml.transform.*,javax.xml.transform.dom.*,javax.xml.transform.stream.*" %>
<%@page language="java" pageEncoding="utf-8"%>
<%! 

String welcomeURL = "http://54.92.21.157/wechat/enrollApply.jsp";

public void DEBUGOUT(String s) { System.out.println(s); }
//--------------------- CLASS LOGGER --------------
private static class Logger
{
	PrintWriter pw = null;
	public Logger() { init("logs/wechatLog.txt"); }
	public Logger(String fname) { init( fname); }
	
	public void init(String fname) {
		try {
			OutputStreamWriter osw = new OutputStreamWriter( new FileOutputStream( new File(fname), true ), "UTF-8");
		    pw = new PrintWriter( osw ); // allow append using 'true' flag
		} catch (Exception e) {
			System.out.println("Logfile can not be opened to append " + fname );
		}
	}
	public void addLog(String s) { if (pw != null) pw.println(s); }
	public void close() { pw.close() ; }
}

//--------------------- CLASS ResponseBuilder --------------
private static class ResponseBuilder
{
	DocumentBuilderFactory factory = null;
	DocumentBuilder	builder = null;
	Document doc = null;
	Element root = null;
	
	public ResponseBuilder(String rootTagName) throws Exception {
		factory = DocumentBuilderFactory.newInstance();
		builder = factory.newDocumentBuilder();
		doc = builder.newDocument();
		root = doc.createElement( rootTagName );
		doc.appendChild( root );
	}
	
	private Node appendGeneralNode(String tagName, String tagValue, int nodeType) {
		Element tagElement = doc.createElement( tagName );
		switch (nodeType) {
		    case 1:
				tagElement.appendChild( doc.createCDATASection( tagValue ) ); break;
		    case 2:
		    	tagElement.appendChild( doc.createTextNode( tagValue ) ); break;
		    default:
		    	tagElement.appendChild( doc.createTextNode( tagValue ) ); break; 	
		}
		root.appendChild( tagElement );
		return tagElement;
	}
	
	// Append String node in response XML
	public Node appendStringNode(String tagName, Object tagValue) {
		return appendGeneralNode( tagName, (String) tagValue, 1 );
	}
	
	// Append Integer/Float node in response XML
	public Node appendIntegerNode(String tagName, Object tagValue) {
		return appendGeneralNode( tagName, (String) tagValue, 2 );
	}

	// Append TimeStamp node in response XML
	public String appendTimeStampNode() {
		String ts = "" + (new java.util.Date()).getTime() / 1000;
		appendGeneralNode( "CreateTime", ts , 2 );
		return ts;
	}
	
	// Build XML String
	public String getAsXMLString() throws Exception 
	{		
		TransformerFactory transformerFactory = TransformerFactory.newInstance();
		Transformer transformer = transformerFactory.newTransformer();
		DOMSource source = new DOMSource(doc);
		StringWriter sw = new StringWriter();
		transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");  // if not omit, <?xml ...> will be in output
	    transformer.setOutputProperty(OutputKeys.METHOD, "xml");
	    transformer.setOutputProperty(OutputKeys.INDENT, "yes");
	    transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
		transformer.transform( source, new StreamResult( sw ) );
		return sw.toString();
	}
	
} // end of Class Declaration


/* Short-hand to make a stream into string, a trick to use java.util.Scanner */
public String convertStreamToString(InputStream is) {
    java.util.Scanner s = new java.util.Scanner( is ).useDelimiter("\\A");  //delimiter is beginning of the input
    return s.hasNext() ? s.next() : "";
}

SimpleDateFormat timeStampFormat = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");

public String getTimeStamp()
{
	java.util.Date dt = new java.util.Date();
	timeStampFormat.setTimeZone( TimeZone.getTimeZone("GMT+8") );
	return ( timeStampFormat.format( dt ) + "(" + dt.getTime()/1000 + "." + dt.getTime() % 1000 + ")" ) ;
}

public String generatetWxTimeStamp()
{
	return "" + (new java.util.Date()).getTime() / 1000;
}

/**
 (1) Parse the XML message sent from WECHAT. 
 (2) Put the information into hashmap for easier processing later
Sample Text to Parse sent from WeChat:
<xml>
  <ToUserName><![CDATA[gh_4edf1b2e39af]]></ToUserName>
  <FromUserName><![CDATA[oQ3jUjkbmZ9NHcl3h5W5Cx7vKNHc]]></FromUserName>
  <CreateTime>1406797365</CreateTime>
  <MsgType><![CDATA[event]]></MsgType>
  <Event><![CDATA[VIEW]]></Event>
  <EventKey><![CDATA[http://54.92.21.157/wechat/redir.jsp?item=2.3]]></EventKey>
</xml>
*/
public HashMap parseXMLInput( String xml )
	throws Exception
{
	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	DocumentBuilder	builder = factory.newDocumentBuilder();
	Document doc = builder.parse( new ByteArrayInputStream( xml.getBytes() ) );
	//System.out.println("Document is " + doc );
	//System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
	Node root = doc.getDocumentElement();
	NodeList childList = root.getChildNodes();
	
	HashMap hm = new HashMap();
	hm.put("MsgType", "NONE"); // to avoid no proper MsgType in input XML
	for (int i = 0; i < childList.getLength(); i++) {
		Node aItem = childList.item( i );
		if ( aItem instanceof Element ) {
		   hm.put( aItem.getNodeName(), aItem.getTextContent() );
		//System.out.println("Child " + i + " : " + aItem.getNodeName() + " Data is " + aItem.getTextContent() );
		}
	}	
	return hm;
}

/**
Command(1) Text Message
<xml>
<ToUserName><![CDATA[gh_4edf1b2e39af]]></ToUserName>
<FromUserName><![CDATA[oQ3jUjkbmZ9NHcl3h5W5Cx7vKNHc]]></FromUserName>
<CreateTime>1406804869</CreateTime>
<MsgType><![CDATA[text]]></MsgType>
<Content><![CDATA[Abcdgvd]]></Content>
<MsgId>6042180904409287104</MsgId>
</xml>
*/
public String processTextRequest(HashMap hm)
{
	String retMsg = "";
	try {
		ResponseBuilder rb = new ResponseBuilder( "xml" );
		rb.appendStringNode("ToUserName", hm.get("FromUserName") );
		rb.appendStringNode("FromUserName", hm.get("ToUserName") );
		rb.appendTimeStampNode(); //rb.appendIntegerNode("CreateTime", "abcd12345");
		rb.appendStringNode("MsgType", "text");
		String message = "歡迎註冊，請開啟鏈結填寫註冊資料 " + welcomeURL + "?openid=" + hm.get("FromUserName");
		message = simpleChat( message, (String) hm.get("Content") ); 
		rb.appendStringNode("Content", message);
		retMsg = rb.getAsXMLString();
	} catch (Exception e) {
		retMsg = "<xml><cmdType>TextMessage</cmdType><exception><![CDATA[" + e.toString() + "]]></exception></xml>";
	}
	return retMsg;
}

public String simpleChat(String defaultMsg, String input)
{
	if ( "介紹".equals( input ) ) {
		return "我是公眾號小助理，有問題請撥 0800-092-000";
	} else if ( input.indexOf("天氣") >= 0 || input.indexOf("下雨嗎") >= 0 ) {  //天氣
		return "今天天氣不錯啊，是晴天。";
	} else if ( "註冊".equals( input ) ) {
		return defaultMsg;
	} else if ( "購物".equals( input ) ) {
		return "要購物可以到 http://shopping.pchome.com.tw 或 http://www.taobao.com/";
	} else if ( "天下事".equals(input) || "新聞".equals( input ) || "News".equals( input ) ) {
		return "要看新聞可以到 http://udn.com/ 或 http://news.baidu.com/";
	} else if ( "HELP".equals( input ) ) {
		return "你可以問：\n天氣,下雨嗎\n註冊\n介紹\n購物\n新聞,天下事";
	} else {
		return "你可以問：\n天氣,下雨嗎\n註冊\n介紹\n購物\n新聞,天下事" + input;
	}
}


/**
Command(2) GPS location update
<xml><ToUserName><![CDATA[gh_4edf1b2e39af]]></ToUserName>
<FromUserName><![CDATA[oQ3jUjkbmZ9NHcl3h5W5Cx7vKNHc]]></FromUserName>
<CreateTime>1406830966</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[LOCATION]]></Event>
<Latitude>24.986235</Latitude>
<Longitude>121.280510</Longitude>
<Precision>40.000000</Precision>
</xml>
*/
public String processLocationRequest(HashMap hm)
{
	String retMsg = "";
	try {
		ResponseBuilder rb = new ResponseBuilder( "xml" );
		rb.appendStringNode("ToUserName", hm.get("FromUserName") );
		rb.appendStringNode("FromUserName", hm.get("ToUserName") );
		rb.appendTimeStampNode(); //rb.appendIntegerNode("CreateTime", "abcd12345");
		rb.appendStringNode("MsgType", "text");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		sdf.setTimeZone(TimeZone.getTimeZone("GMT+8"));

		String gpsNote = sdf.format( System.currentTimeMillis() ) + "已收到您的微信打卡，按鏈結可顯示所在地 " 
			+ "https://www.google.com.tw/maps/@" + hm.get("Latitude") + "," + hm.get("Longitude") + ",17z" ;
					
		rb.appendStringNode("Content", gpsNote);
		retMsg = rb.getAsXMLString();
	} catch (Exception e) {
		retMsg = "<xml><cmdType>LocationNotification</cmdType><exception><![CDATA[" + e.toString() + "]]></exception></xml>";
	}
	return retMsg;	
}

/**
Command(3) WeChat Client Menu-click
Input:<xml><ToUserName><![CDATA[gh_4edf1b2e39af]]></ToUserName>
<FromUserName><![CDATA[oQ3jUjkbmZ9NHcl3h5W5Cx7vKNHc]]></FromUserName>
<CreateTime>1406832921</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[VIEW]]></Event>
<EventKey><![CDATA[http://54.92.21.157/wechat/redir.jsp?item=2.1]]></EventKey>
</xml>
*/
public String processClickMenuRequest(HashMap hm)
{
	String retMsg = "";
	try {
		ResponseBuilder rb = new ResponseBuilder( "xml" );
		rb.appendStringNode("ToUserName", hm.get("FromUserName") );
		rb.appendStringNode("FromUserName", hm.get("ToUserName") );
		rb.appendTimeStampNode(); //rb.appendIntegerNode("CreateTime", "abcd12345");
		rb.appendStringNode("MsgType", "text");
		
		String eventKey = (String) hm.get("EventKey");
		String clickType = "其他項目";
		if ( eventKey.indexOf("?item=1.0") > 0 ) {
			clickType = "實名註冊";
		} else if (  eventKey.indexOf("?item=2.") > 0 ) {
			clickType = "商城產品瀏覽";
		} else if (  eventKey.indexOf("?item=3.") > 0) {
			clickType = "微辦公任務";
		} else if (  eventKey.indexOf("KY01") >= 0) {   //<---- only this item and below works.
			clickType = "協會簡介";
		} else if (  eventKey.indexOf("KY02") >= 0) {
			clickType = "協會新聞";
		} else if (  eventKey.indexOf("KY03") >= 0) {
			clickType = "協會問答";
		} else if (  eventKey.indexOf("KY04") >= 0) {
			clickType = "協會服務";
		} else if (  eventKey.indexOf("KY21") >= 0) {
			clickType = "微辦公簡介";
		}
		String menuNote = "感謝您點選下方選單的「" + clickType + "」,加值功能持續增加中。請持續關注";
		rb.appendStringNode("Content", menuNote);
		retMsg = rb.getAsXMLString();
	} catch (Exception e) {
		retMsg = "<xml><cmdType>ClickMenu</cmdType><exception><![CDATA[" + e.toString() + "]]></exception></xml>";
	}
	return retMsg;	
}

/**
<xml><ToUserName><![CDATA[gh_4edf1b2e39af]]></ToUserName>
<FromUserName><![CDATA[oQ3jUjkbmZ9NHcl3h5W5Cx7vKNHc]]></FromUserName>
<CreateTime>1406849724</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[subscribe]]></Event>
<EventKey><![CDATA[]]></EventKey>
</xml>
*/
public String processSubscribeRequest(HashMap hm)
{
	String retMsg = "<xml><message>User un-registered " + hm.get("FromUserName") + "</message></xml>";
	try {
		// can do some operation for un-register.
		ResponseBuilder rb = new ResponseBuilder( "xml" );
		rb.appendStringNode("ToUserName", hm.get("FromUserName") );
		rb.appendStringNode("FromUserName", hm.get("ToUserName") );
		rb.appendTimeStampNode(); //rb.appendIntegerNode("CreateTime", "abcd12345");
		rb.appendStringNode("MsgType", "text");
		String welcomeNote = "歡迎關注本公眾號，請開啟鏈結填寫註冊資料 " + welcomeURL + "?openid=" + hm.get("FromUserName");
		rb.appendStringNode("Content", welcomeNote);
		retMsg = rb.getAsXMLString();
	} catch (Exception e) {
		retMsg = "<xml><cmdType>Register</cmdType><exception><![CDATA[" + e.toString() + "]]></exception></xml>";
	}
	return retMsg;	
}


/**
<xml><ToUserName><![CDATA[gh_4edf1b2e39af]]></ToUserName>
<FromUserName><![CDATA[oQ3jUjkbmZ9NHcl3h5W5Cx7vKNHc]]></FromUserName>
<CreateTime>1406849043</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[unsubscribe]]></Event>
<EventKey><![CDATA[]]></EventKey>
</xml>
*/
public String processUnsubscribeRequest(HashMap hm)
{
	String retMsg = "<xml><message>User un-registered " + hm.get("FromUserName") + "</message></xml>";
	try {
		// can do some operation for un-register.
	} catch (Exception e) {
		retMsg = "<xml><cmdType>ClickMenu</cmdType><exception><![CDATA[" + e.toString() + "]]></exception></xml>";
	}
	return retMsg;	
}


/**
  Command-line processor
*/
public String processWeChatCommand(HashMap hm)
{
	String responseMsg = "<xml><result><![CDATA[EMPTY RESPONSE]]></result></xml>";
	String msgType = (String) hm.get("MsgType");   // event or text
	
	if ( "event".equals( msgType ) ) {
		String eventName = (String) hm.get("Event"); 
		if ( "LOCATION".equals(eventName) ) {
			DEBUGOUT("IS Location");
			responseMsg = processLocationRequest( hm );
		}  else if ( "VIEW".equals(eventName) ) {
			// EvnetKey..... http://...../?item=1.0, means to send a message to user
			DEBUGOUT("IS VIEW");
			responseMsg = processClickMenuRequest( hm );
			// Actually, if it is 'VIEW' type, wechat won't send our XML content reply backto the client,
			// only 'CLICK' type will get the direct reply on WeChat Client
		}  else if ( "CLICK".equals(eventName) ) {
			// EvnetKey..... http://...../?item=1.0, means to send a message to user
			DEBUGOUT("IS CLICK");
			responseMsg = processClickMenuRequest( hm );
		} else if ( "subscribe".equals( eventName ) ) {
			responseMsg = processSubscribeRequest( hm );
		} else if ( "unsubscribe".equals( eventName ) ) {
			processUnsubscribeRequest( hm );
		}
	} else if ("text".equals( msgType) ) {
		DEBUGOUT("IS TEXT, Received Content is " + hm.get("Content") + ", MsgID=" + hm.get("MsgId") );
		responseMsg = processTextRequest( hm );
		DEBUGOUT("Response text is composed to:" + responseMsg );  
		
	} else {
		DEBUGOUT("Unknown Message Type: " + msgType );
	}
	
	return responseMsg ;
}
%>
<% 
	InputStream istream = request.getInputStream();
	PrintWriter pw = response.getWriter(); //new PrintWriter( new OutputStreamWriter( response.getOutputStream(), "UTF-8" ) );
	Logger log = new Logger();
	
	String xmlInput = convertStreamToString ( istream );
	if ( "".equals( xmlInput ) ) xmlInput = "<xml><MsgType><![CDATA[NONE]]></MsgType></xml>";
	String echoString = request.getParameter("echoString");
	String cmdString = request.getParameter("cmd");

	String ts = getTimeStamp();
	//DEBUGOUT("Echo Str is : " + echoString );
	DEBUGOUT( ts + ": Result Str is : " + xmlInput );
	log.addLog( ts + " Input:" + xmlInput );
	
	if ( null == cmdString ) {   // Normal WECHAT Request
		HashMap commandMap = parseXMLInput( xmlInput );
		//pw.print( "The reulst is : " + x );
		DEBUGOUT("HashMap is " + commandMap );
		String retMsg = processWeChatCommand( commandMap );
		response.setHeader("Content-Type", "application/xml; charset=utf-8");
		pw.print( retMsg );
		log.addLog( ts + " Output:" + retMsg );
	} else if ( cmdString.equals( "diag" ) ) {
		response.setHeader("Content-Type", "text/html; charset=utf-8");
		pw.print("<html><body>Hello world(2)." + cmdString + "</body></html>");				
	} else if ( cmdString.equals( "diagXML" ) ) {
		response.setHeader("Content-Type", "application/xml; charset=utf-8");
		ResponseBuilder rb = new ResponseBuilder( "xml" );
		rb.appendStringNode("ToUserName", "TOabcd12345");
		rb.appendStringNode("FromUserName", "FROMabcd12345");
		rb.appendTimeStampNode(); //rb.appendIntegerNode("CreateTime", "abcd12345");
		rb.appendStringNode("MsgType", "text");
		rb.appendStringNode("Content", "Hello, this is response 中文 ");
		String retMsg = rb.getAsXMLString();
		DEBUGOUT( retMsg );
		pw.print( retMsg );				
	} else {
		response.setHeader("Content-Type", "text/html; charset=utf-8");
		pw.print("<html><body>Hello world(3)." + cmdString + "</body></html>");				
	}
	log.close();
%>