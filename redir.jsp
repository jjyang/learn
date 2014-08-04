<html>
  <head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<style>
	#header, #footer  { background: #A9BCF5  }
	#content { /* background: #F7BE81; */ }
	#sidebar { background: #E1F5A9; }
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
#content { width: 72%; height: auto; float: right;  }
#sidebar { width: 2%; height: auto; float: left; }
#footer  { clear: both; }

/************************************************************************************
MEDIA QUERIES
*************************************************************************************/
/* for 980px or less */
@media screen and (max-width: 980px) {	
	#head { background: #AAAABB; }
	#pagewrap { width: 100%; }
	#content  { width: 98%; height: auto;}
	#sidebar  { width: 2%; height: auto;}
}

/* for 700px or less */
@media screen and (max-width: 700px) {
	#head { background: #AAFFBB; }
	#content { width: 98%; float: right; height: auto }
	#sidebar { width: 2%; height: auto; float: left; }
}

/* for 480px or less */
@media screen and (max-width: 480px) {
	#header { height: auto; }
	#head { background: #FFAABB; }
	h1 { font-size: 24px; }
	#sidebar,#content { height: auto; float: left; }
}

	</style>
  </head>
  <body>
	<div id="pagewrap">

	<div id="header">
		<table><tr><td><img src="logo.png" width=80px height=96px></img>
		<td> <h3> Uniportal x 微信 x 微網站 </h3>
		MenuID= <%= request.getParameter("item") %>	<br>
<!-- 
		[<a onClick='document.getElementById("sidebar").style.display="none"; document.getElementById("content").style.width="100%";'> MenuOff </a>] &nbsp;
		[<a onClick='document.getElementById("sidebar").style.display=""; document.getElementById("content").style.width="72%";'> MenuOn </a>]
-->		
		</td></tr></table>
			
	</div> 

   <div id="sidebar"></div>
<!--  
	<div style="display:none" id="sidebar">
		<h3>Menu</h3> 
		<ul>
		<% for (int i=1; i < 5 ; i++) { %> <li>menu item <%= i%> </li>  <% } %>
		</ul>
	</div>
-->
	
	<div id="content">
		<% 
		String item = request.getParameter("item"); 
		if ("1.0".equals( item ) ) {
			pageContext.include ("enrollApply.jsp");
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
  </body>
</html>