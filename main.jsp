<html>
  <head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	 <link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
     <script src="//code.jquery.com/jquery-1.10.2.js"></script>
     <script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
 
	<!-- script src="../js/jquery/jquery-1.8.3.min.js" / -->
	<!-- script src="../js/jquery/ui/jquery-ui.min.js" / -->
	<!--link rel="stylesheet" href="../js/jquery/ui/css/jquery-ui.css" /-->

	
		
	<style>
	.ui-menu { width: 240px; }
	
	#header, #footer  { background: #A9BCF5  }
	#content { /* background: #F7BE81; */ }
	#sidebar { background: #E1F5A9; width:240px }
	#header, #content, #sidebar {
		margin-bottom: 1px;
	}
	#pagewrap, #header, #content, #sidebar, #footer {
		border: solid 1px #BCA9F5;
	}

	#headerImg { background: "logo.png" }
/************************************************************************************
 * STRUCTURE
 *************************************************************************************/
#pagewrap {
	padding: 2px;
	width: 960px;
	margin: 6px auto;
}
#header  { height: 100px; }
#content { width: 72%; height: 600px; float: right;  }
#sidebar { width: 25%; height: 600px; float: left; }
#footer  { clear: both; }

/************************************************************************************
MEDIA QUERIES
*************************************************************************************/
/* for 980px or less */
@media screen and (max-width: 980px) {	
	#head { background: #AAAABB; }
	#pagewrap { width: 100%; }
	#content  { width: 73%; height: 800px; float: right}
	#sidebar  { width: 25%; height: 800px; float: left}
	.ui-menu  { width: 200px; font-size: 12pt }
	
}

/* for 700px or less */
@media screen and (max-width: 700px) {
	#head { background: #AAFFBB; }
	#content { width: 73%; float: right; height: 800px; }
	#sidebar { width: 25%; height: 800px; float: left; }
	.ui-menu { width: 150px; font-size: 11pt }
}

/* for 480px or less */
@media screen and (max-width: 480px) {
	#header { height: auto; }
	#head { background: #FFAABB; }
	h1 { font-size: 24px; }
	#sidebar,#content { height: auto; float: left; }
	.ui-menu { width: 100px; font-size: 10pt }
}

	</style>
  </head>
  <body>
	<div id="pagewrap">

	<div id="header">
		<table><tr><td><img src="wechat.jpg" height=90px width=160px></img>
		<td> <h3> Uniportal x 微信後台管理 </h3>
		</td></tr></table>
			
	</div> 


	<div id="sidebar">
		<h3>WeChat後台管理</h3> 
		<ul id="menu">
			<li>總管管理菜單</li>
			<li>---</li>   
				<li> &nbsp;&nbsp;<a onClick="doMenu(11);">群友列表</a> </li>
				<li> &nbsp;&nbsp;<a onClick="doMenu(12);">群組列表</a> </li>
				<li> &nbsp;&nbsp;<a onClick="doMenu(13);">群組廣播</a> </li>
			<li>---</li>   
			<li> 群長管理菜單
			<li>---</li>  	
				<li> &nbsp;&nbsp;<a onClick="doMenu(21);">子群組群友列表</a> </li>
				<li> &nbsp;&nbsp;<a onClick="doMenu(22);">加入群友</a></li>
				<li> &nbsp;&nbsp;<a onClick="doMenu(23);">退出群友</a></li>
				<li> &nbsp;&nbsp;<a onClick="doMenu(24);">子群組廣播</a></li>
			
			<li>---</li>   
				<li> 群友基本功能 
			<li>---</li>  	
				  <li> &nbsp;&nbsp;<a onClick="doMenu(31);">查詢個人資料</a> </li>	
				  <li> &nbsp;&nbsp;<a onClick="doMenu(32);">傳送群內訊息</a> </li>
			</li>
		</ul>
	
	</div>
	

	<div id="content">
		<% 
		String item = request.getParameter("item"); 
		if ("1.0".equals( item ) ) {
			pageContext.include ("enrollApply.jsp");
		} else if ( null == item ) {
			out.println("Hello....");
		} else {
			pageContext.include ("menu." + item + ".jsp");
		}
		%>
	</div>

	
	<div id="footer">
		<h4>Copyright (c)2014, Flowring Technology</h4>
		<p> 2014/07 即將公開 It is under construction. We'll see you soon on early July 2014 </p>
	</div>

</div>


	<script>
		function doMenu(mi)
		{
			//alert("selected item is " + mi );
			if ("11"==mi) {
			  $("#content").html( '<iframe width=680 height=600 src="wechatUserList.jsp"></iframe>' );
			} else {
			  $("#content").html( "<h3>MenuItem:" + mi + "</H3><BR><iframe width=680 height=500 src=menu." + mi + ".jsp></iframe>" );
			}
		}
		$(function() { $("#menu").menu(); } );
		$("#content").html( "<iframe width=680 height=600 src=wechatUserList.jsp></iframe>" );
		
	</script>
  </body>
</html>