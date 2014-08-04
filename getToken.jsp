<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" %>  
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@page import="org.json.simple.*" %>
<%@page import="org.json.simple.parser.*" %>




<%!
String appID = "wxaabc26367f22b9b9";
String appSecret = "46dc6b2828803dcc1123f0567511c9b4";
//String token = "ZFKex4xGjQ7ffYV6_EkPa2CSm2K9a0lvkEwIo-IMf6Hy9D2o-7XpbqKkcV21ApQRDmVpGyeuJzHX9ZhfBYHhCg";
String wxClientHead = "https://api.weixin.qq.com/cgi-bin";
String wxClientPath = wxClientHead + "/token?grant_type=client_credential&appid=" + appID + "&secret=" + appSecret;

public String sendPost( String url )
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

public String convert(Object x)
{
	return (String) x;
	//return new String( ((String) x).getBytes(), "UTF-8");
}


%>


<html>
<body>

<%
  String result = sendPost( wxClientPath );
  JSONParser parser = new JSONParser();
  
  Object obj = parser.parse( result );
  JSONObject jso = (JSONObject) obj;
  String token = (String) jso.get("access_token");
  Long expires_in = (Long) jso.get("expires_in");
  
  String urlForGetUser = wxClientHead + "/user/get?access_token=" + token + "&next_openid=";
  String resultUserList = sendPost( urlForGetUser );
  JSONObject js2 = (JSONObject) parser.parse( resultUserList );
  
  int totalUser = ((Long) js2.get("total")).intValue();
%>
<!--
	The result is : <%= result %>. <br>
	Token is : <%= token %> <br>
	Expire   : <%= expires_in %>
	TotalUser: <%= js2.get("total") %> <br>
	NextOpenID: <%= js2.get("next_openid") %>
-->
	

<table border=1>
<tr><td>微信暱稱<td>性別<td>入群時間<td>國家<td>省份<td>城市<td>頭像<td>微信OpenID<td>微信UnionID
	<% for (int i = 0; i < totalUser; i++) { 
		JSONObject xx = (JSONObject)js2.get("data");
		//JSONObject yy = (JSONObject)xx.get("openid");
		JSONArray zz = (JSONArray) xx.get("openid");
		String userOpenID = (String) zz.get( i );
		//out.println( "<br>Reulst[" + i + "] is " + userOpenID );
		String urlForUserInfo = wxClientHead + "/user/info?access_token=" + token 
				+ "&openid=" + userOpenID + "&lang=zh_CN";
		String resultUserInfo = sendPost( urlForUserInfo );
		JSONObject js3 = (JSONObject) parser.parse( resultUserInfo );
	%>
	<tr>
	<td><%= convert( js3.get("nickname") ) %>
	<td><%= js3.get("sex") %>
	<td><%= js3.get("subscribe_time") %>
	<td><%= convert( js3.get("country") ) %> 
	<td><%= convert( js3.get("province") ) %>
	<td><%= js3.get("city") %>
	<td><img width=128 height=128 src=<%= js3.get("headimgurl") %> > <img>
	<td><%= js3.get("openid") %>
	<td><%= js3.get("unionid") %>
	</tr>	
	<% } %>	
</table>	
		
</body>

</html>