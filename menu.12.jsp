<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" %>  
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@page import="org.json.simple.*" %>
<%@page import="org.json.simple.parser.*" %>


<%!
String appID = "wxaabc26367f22b9b9";
String appSecret = "46dc6b2828803dcc1123f0567511c9b4";
String wxClientHead = "https://api.weixin.qq.com/cgi-bin";
String wxClientPath = wxClientHead + "/token?grant_type=client_credential&appid=" + appID + "&secret=" + appSecret;
//String token = "R5-oOe0RxLRR9gEzC5HMRq4Hf7aEIRBD2w02w-46CtQVaZRkejH2CRZR9uSD2quLzXd1JW2YntCEXdfa9A_DTQ";

String token = "FaxCWFpwg4iTKPoKGzsgrpA9l5GYhxsa3SnVsNSW5IFPe1pxkORncJJ-FWfPKIZfiLJiIjdBNzA_VOMpEF6kaQ";

JSONParser parser = new JSONParser();

public String getToken() 
    throws Exception
{
	  String result = sendGet( wxClientPath );
	
	  
	  Object obj = parser.parse( result );
	  JSONObject jso = (JSONObject) obj;
	  String token = (String) jso.get("access_token");
	  return token;
}

public String sendPost( String url, String postData ) 
    throws Exception {
	 
	URL obj = new URL(url);
	HttpURLConnection con = (HttpURLConnection) obj.openConnection();

	//add reuqest header
	con.setRequestMethod("POST");
	//con.setRequestProperty("User-Agent", USER_AGENT);
	con.setRequestProperty("Accept-Language", "UTF-8");

	// Send post request
	con.setDoOutput(true);
	DataOutputStream wr = new DataOutputStream(con.getOutputStream());
	wr.writeBytes( postData );
	wr.flush();
	wr.close();

	int responseCode = con.getResponseCode();
	System.out.println("\nSending 'POST' request to URL : " + url);
	System.out.println("Post parameters : " + postData);
	System.out.println("Response Code : " + responseCode);

	BufferedReader in = new BufferedReader(
	        new InputStreamReader(con.getInputStream(), "UTF-8"));
	String inputLine;
	StringBuffer response = new StringBuffer();

	while ((inputLine = in.readLine()) != null) {
		response.append(inputLine);
	}
	in.close();

	//print result
	System.out.println(response.toString());
	return response.toString();
}


public String sendGet( String url )
	throws Exception
{
   	    //String url = wxClientPath;
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
 
		// optional default is GET
		con.setRequestMethod("GET");
		//add request header
		//con.setRequestProperty("User-Agent", USER_AGENT);
 
		int responseCode = con.getResponseCode();
		System.out.println("\nSending 'GET' request to URL : " + url);
		System.out.println("Response Code : " + responseCode);
 		
		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream(), "UTF-8"));
		String inputLine;
		StringBuffer response = new StringBuffer();
 
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();
 
		//print result
		System.out.println(response.toString());
		return response.toString();
}

%>


<html>
  <body>
  	<form method="post" action="menu.12.jsp" > 
  		<table border=1>
  		  <tr><td>群組名稱<td><input type=text name=groupName>
  		  <tr><td colspan=2 align=center> <input type=submit value="新增群組">
  		</table>
    </form>
  
<%

token = getToken();

String newGroup = request.getParameter("groupName");
if ( null != newGroup) {
	String urlForCreatingGroup = wxClientHead + "/groups/create?access_token=" + token;
	String groupData = "{ \"group\": { \"name\": \"" +  newGroup + "\"}}";
	sendPost( urlForCreatingGroup, groupData ) ;
}

String urlForGetGroupList = wxClientHead + "/groups/get?access_token=" + token;
String resultGroupList = sendGet( urlForGetGroupList );
JSONObject js = (JSONObject) parser.parse( resultGroupList );
JSONArray js2 = (JSONArray) js.get("groups");
%>  

  <h2>微信群組列表 </h2> 
 <table border=1>
  <tr><td>順序<td>群組編號<td>群組名稱<td>群組人數
  <% for (int i = 0 ; i < js2.size(); i++ ) {
	  JSONObject jsitem = (JSONObject) js2.get( i ); %>
	  
	<tr><td> <%= i+1 %> 
		<td> <%= jsitem.get("id")   %>
	    <td> <%= jsitem.get("name") %>
	    <td> <%= jsitem.get("count") %>
  <% } %>
  
  </table>  
   
  </body>
</html>