<cfif thistag.executionMode IS "start">

	<cfparam name="attributes.title" default="CFML Complexity Metric Tool" />
	<cfparam name="attributes.directory" default="" />
	<cfparam name="attributes.file" default="" />
	<cfparam name="attributes.function" default="" />

<cfcontent reset="true" /><!doctype html>

<html lang="en">
<head>
	<link rel="stylesheet/less" type="text/css" href="css/complexity.less">
	<script src="js/less.min.js" type="text/javascript"></script>
	<title><cfoutput>#attributes.title#</cfoutput></title>
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/jquery.colorfade.js"></script>
	<meta charset="utf-8" />
</head>
<body>

<section>
<cfelseif thistag.executionMode EQ "end">
</section>



<cfif isDebugMode()>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
</cfif>

</body>
</html></cfif>