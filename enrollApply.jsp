﻿<%@page pageEncoding="utf-8" %>

<%
String openID = request.getParameter("openid");
if ( null == openID ) openID = "";
%>

<h2>鹵粉匯實名制入會申請表</h2>

<form name="appForm" action="http://lufen.flowring.com/WebAgenda/createProcess.jsp" method="post">
<input type="submit" value="送出實名申請"/>
<table border="1">
	<tr><td>微信暱稱
		</td><td><input name="wechatName" type="text" size="20"/>
	</td></tr><tr><td>微信內部代號
		</td><td><input name="wechatOID" type="text" size="40" value="<%=openID%>"></input>	
	</td></tr><tr><td>所屬地區
		</td><td><select name="area">
			<option value="P00">請選擇..</option> 
			<option value="P01">台灣</option> 
			<option value="P02">北京</option> 
			<option value="P03">上海</option> 
			<option value="P04">廣州</option> 
			<option value="P05">深圳</option> 
			<option value="P06">河北</option> 
			<option value="P07">山東</option> 
			<option value="P08">江蘇</option> 
			<option value="P09">浙江</option> 
			<option value="P10">福建</option> 
			<option value="P11">廣東</option> 
			<option value="P12">湖南</option>
			<option value="P99">其他</option>
			</select>
	</td></tr><tr><td>希望加入群組
		</td><td><select name="expectedGroup">
			<option value="G00">請選擇..</option> 
			<option value="G01">鹵粉台灣群</option> 
			<option value="G02">鹵粉北京</option> 
			<option value="G03">鹵粉上海</option> 
			<option value="G04">鹵粉廣州</option> 
			<option value="G05">鹵粉深圳</option> 
			<option value="G06">鹵粉河北</option> 
			<option value="G07">鹵粉山東</option> 
			<option value="G08">鹵粉江蘇</option> 
			<option value="G09">鹵粉浙江</option> 
			<option value="G10">鹵粉福建</option> 
			<option value="G11">鹵粉廣東</option> 
			<option value="G12">鹵粉湖南</option>
			<option value="G99">請幫我指定</option>
			</select>
	</td></tr><tr><td colspan="2">實名資訊
	</td></tr><tr><td>姓名
		</td><td><input type="text" name="userName"/>
	</td></tr><tr/>

	<tr><td>性別</td>
		<td><select name="userGender">
		<option value="none">請選擇...</option>
		<option value="men">男</option>
		<option value="women">女</option>
		</select>
	</td></tr>	

	<tr><td>Email
		</td><td><input type="text" name="userEmail"/>	
	
	<tr><td>Birthday
		</td><td><input type="text" name="userBirthday"/>	
	
	
	<tr><td>服務公司
		</td><td><input type="text" name="userCompany"/>	
	</td></tr><tr><td>職稱
			</td><td><input type="text" name="userTitle"/>
	</td></tr><tr><td>地址
			</td><td>
			(省市)<input type="text" size="20" name="userAddress0"/> <br/>
			(路街)<input type="text" size="20" name="userAddress1"/>
	</td></tr><tr><td>電話
			</td><td><input type="text" name="userMobile"/> (1)<br/>
				<input type="text" name="userMobile2"/> (2)
	</td></tr><tr><td>個人簡介</td>
			<td><textarea rows="10" cols="30" name="userIntro"></textarea>
			</td>
	</tr>	
</table>
<input type="submit" value="送出實名申請"/>
</form>
