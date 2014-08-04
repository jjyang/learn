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

public String[] getOpenID()
{
	String[] xx = {
	   "oQ3jUjkbmZ9NHcl3h5W5Cx7vKNHc",
	   "oQ3jUjrfAruk-LZ9iDioJ02kRpGg",
	   "oQ3jUjnPZlosXKxL48D7sL4C0ny4",
	   "oQ3jUjsV1frub4IiITkXhMgkhYx4",
	   "oQ3jUjnVM3JuB8HUnM7x937d_IQ4",
	   "oQ3jUjgyqwnGVaxDbAyCMCqt82Og"
	};
	return xx;
}

public String getToken() 
    throws Exception
{
	  String result = sendGet( wxClientPath );
	
	  
	  JSONObject obj = (JSONObject) parser.parse( result );
	  String token = (String) obj.get("access_token");
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

public String sendWechatMessageTo( String openID , String message )
    throws Exception
{
	  String urlForSendMessage = wxClientHead + "/message/custom/send?access_token=" + token ;
	  String postData = "{@touser@:@" + openID + "@,@msgtype@:@text@,@text@:{ @content@: @" + message + "@}}";
	  postData = postData.replaceAll("@", "\"");
  	  String result = sendPost( urlForSendMessage, postData );
	  return result;
}
%>


<html>
  <body>
  	<form method="post" action="menu.13.jsp" > 
  		<table border=1>
  		  <tr><td>廣播訊息<td><textarea rows=10 cols=40 name="groupMessage"></textarea>
  		  <tr><td colspan=2 align=center> <input type=submit value="傳送廣播">
  		</table>
    </form>
  
<%

token = getToken();

String groupMessage = request.getParameter("groupMessage");
boolean doSend = false;
if ( null != groupMessage) { doSend = true; }

String urlForGetUser = wxClientHead + "/user/get?access_token=" + token + "&next_openid=";
String resultUserList = sendGet( urlForGetUser );
JSONObject js2 = (JSONObject) parser.parse( resultUserList );
  
int totalUser = ((Long) js2.get("total")).intValue();
String[] userList = getOpenID();
%>
	

<h3>接受廣播群組成員</h3>

<table border=1>
<tr><td>#<td>微信暱稱<td>性別<td>入群時間<td>國家<td>省份<td>城市<td>頭像<td style="width:40px">微信OpenID
	<% for (int i = 0; i < totalUser; i++)  {
		JSONObject xx = (JSONObject)js2.get("data");
		JSONArray zz = (JSONArray) xx.get("openid");
		String userOpenID = (String) zz.get( i ); //userList[ i ]; //(String) zz.get( i );
		if ( doSend ) { sendWechatMessageTo( userOpenID, groupMessage ); }
		
		if ( true ) {
		String urlForUserInfo = wxClientHead + "/user/info?access_token=" + token 
				+ "&openid=" + userOpenID + "&lang=zh_CN";
		String resultUserInfo = sendGet( urlForUserInfo );
		JSONObject js3 = (JSONObject) parser.parse( resultUserInfo );
	%>
	<tr>
	<td><%= i+1 %>
	<td><%= js3.get("nickname")  %>
	<td><%= js3.get("sex") %>
	<td><%= js3.get("subscribe_time") %>
	<td><%= js3.get("country")  %> 
	<td><%= js3.get("province")  %>
	<td><%= js3.get("city") %>
	<td><img width=80 height=80 src=<%= js3.get("headimgurl") %> > <img>
	<td style="width:40px"><%= ((String)js3.get("openid")).substring(0,8) %> ... 
	</tr>	
	
	   <% } else { %>
	   <tr>
	<td><%= i+1 %>
	<td><%= "OffLine"  %>
	<td><%= "OffLine"  %>
	<td><%= "OffLine"  %>
	<td><%= "OffLine"  %>
	<td><%= "OffLine"  %>
	<td><%= "OffLine"  %>
	<td><%= "OffLine"  %>
	<td style="width:40px"><%= userOpenID.substring(0,8) %> ... 
	</tr>
	   <% } // of if-else %>
	<% } %>	
</table>	

  </body>
</html>
