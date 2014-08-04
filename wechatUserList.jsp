<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" %>  
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@page import="org.json.simple.*" %>
<%@page import="org.json.simple.parser.*" %>




<%!
String appID = "wxaabc26367f22b9b9";
String appSecret = "46dc6b2828803dcc1123f0567511c9b4";
//String token = "ZFKex4xGjQ7ffYV6_EkPa2CSm2K9a0lvkEwIo-IMf6Hy9D2o-7XpbqKkcV21ApQRDmVpGyeuJzHX9ZhfBYHhCg";

//String token = "R5-oOe0RxLRR9gEzC5HMRq4Hf7aEIRBD2w02w-46CtQVaZRkejH2CRZR9uSD2quLzXd1JW2YntCEXdfa9A_DTQ";

String token = "FaxCWFpwg4iTKPoKGzsgrpA9l5GYhxsa3SnVsNSW5IFPe1pxkORncJJ-FWfPKIZfiLJiIjdBNzA_VOMpEF6kaQ" ;


String wxClientHead = "https://api.weixin.qq.com/cgi-bin";
String wxClientPath = wxClientHead + "/token?grant_type=client_credential&appid=" + appID + "&secret=" + appSecret;

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
  JSONParser parser = new JSONParser();
  
  String result = sendPost( wxClientPath );
  Object obj = parser.parse( result );
  JSONObject jso = (JSONObject) obj;
  String token = (String) jso.get("access_token");
  Long expires_in = (Long) jso.get("expires_in");
  
  String urlForGetUser = wxClientHead + "/user/get?access_token=" + token + "&next_openid=";
  String resultUserList = sendPost( urlForGetUser );
  JSONObject js2 = (JSONObject) parser.parse( resultUserList );
  

  int totalUser = ((Long) js2.get("total")).intValue();
  //String[] userList = getOpenID();
  //int totalUser = userList.length;
%>
	
微信群組成員列表

<table border=1>
<tr><td>#<td>微信暱稱<td>性別<td>入群時間<td>國家<td>省份<td>城市<td>頭像<td style="width:40px">微信OpenID
	<% for (int i = 0; i < totalUser; i++) { 
		JSONObject xx = (JSONObject)js2.get("data");
		//JSONObject yy = (JSONObject)xx.get("openid");
		JSONArray zz = (JSONArray) xx.get("openid");
		String userOpenID = (String) zz.get( i ); //userList[ i ]; //(String) zz.get( i );
		//out.println( "<br>Reulst[" + i + "] is " + userOpenID );
		
	if ( true ) {
		String urlForUserInfo = wxClientHead + "/user/info?access_token=" + token 
				+ "&openid=" + userOpenID + "&lang=zh_CN";
		String resultUserInfo = sendPost( urlForUserInfo );
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
<!--	<td><%= js3.get("unionid") %> -->
	</tr>
	<% } else { %>
	<tr>
	<td><%= i+1 %>
	<td><%= "offline"  %>
	<td><%= "offline"  %><td><%= "offline"  %><td><%= "offline"  %><td><%= "offline"  %><td><%= "offline"  %><td><%= "offline"  %>
	<td style="width:40px"><%= userOpenID.substring(0,8) %> ... 
	</tr>	
	<% } // of if-else %>
	<% } %>	
</table>	
		
</body>

</html>