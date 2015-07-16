<!---
								mScan
  Author    :   Marcus Fernstrom
  WWW       :   http://www.MarcusFernstrom.com/
  GitHub 		:		https://github.com/MFernstrom/
  Copyright :   2015
	Version		:		0.1
  License   :   GPL V3
	Engine 		:		Built on, using, and for OpenBD ( http://openbd.org/ ), may work on other engines but not tested.

	Other
  Cyclical	:   Cyclical complexity code based on Nathan Strutz tool: https://github.com/NathanStrutz/CFML-Complexity-Metric-Tool
  License   :   GPL3

  Layout		:		http://www.free-css.com, modified version of a free design.
  License		:		Undefined OSS license
--->


<cfif structKeyExists(url, "path")>
	<!--- Awesome wizardry for opening a file using the Windows default editor --->
	<cfif fileExists( url.path )>
		<cfexecute name="c:\windows\system32\cmd.exe" arguments="/c #url.path#" />
</cfif>
	<cfabort>
</cfif>

<!--- Get start-time in tick count --->
<cfset tickBegin = GetTickCount()>
<cfset startTime = now()>
<cfset console( 'Started at ' & timeFormat(startTime, 'hh:mm:ss') )>

<!--- If there's a _path, do the stuff --->
<cfif isDefined("form._path") && listLen( form.fieldnames ) GT 3 && len( form._path ) GT 0 >
	<cfscript>
		testObj         = createObject("component","runtest");
		testInfo        = testObj.runTests( form );
		fileList        = testInfo.fileList;
		testList        = testInfo.testList;
		errorBreakdown  = "";

		for( item in session.errorBreakdown ) {
			errorBreakdown = listAppend(errorBreakdown, serializeJSON( session.errorBreakdown[item]));
		}
		errorBreakdown = Replace( errorBreakdown, '####', '##', 'ALL' );
	</cfscript>
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<title>mScan</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" >
	<link rel="stylesheet" type="text/css" href="css/styles.css">
</head>
<body>
	<div id="doc3" class="yui-t3">
		<div id="hd">
			<div id="header">
				<h1>mScan</h1>
				<h3>Open source code scanner</h3>
			</div>
		</div>
		<div id="bd">
			<div id="yui-main">
				<div class="yui-b">
					<div class="content">
						<cfif isDefined("form._path") && listLen( form.fieldnames ) GT 3 && len( form._path ) GT 0 >

							<div class="errorOutput">
								&laquo; <a href="index.cfm">Reset</a> &raquo;<br>
								<br>
								<cfoutput>
									<cfset tickEnd  = GetTickCount()>
									<cfset testTime = (tickEnd - tickBegin) / 1000>
									<cfset console('Started at ' & timeFormat(startTime, 'hh:mm:ss') )>
									<cfset console('Ended at   ' & timeFormat(now(), 'hh:mm:ss') )>
									<cfset console('Took ' & Round(testTime) & ' seconds.' )>
									<cfset console('')>

									<!--- Output results --->
									Took #Int( testTime/60 )#:<cfif testTime%60 LT 10>0</cfif>#testTime%60#<br>
									#structCount(session.results)# of #arrayLen(fileList)# files has errors<br>
									Click on a filename to open the file using your default OS editor<br>

									<br>
									<div id="theFiles" style="display:block;">
										<table style="width:99%;margin-bottom:20px;" id="filetable">
											<cfloop list="#structKeyList(session.results)#" index="key">
												<cfset errsToDisplay = []>
												<cfset session.results[key].errMessage = ''>
												<cfloop array="#session.results[key].errors#" index="errs">
													<cfset arrayAppend(errsToDisplay, errs.test)>
													<cfset session.results[key].errMessage = session.results[key].errMessage & "&raquo; " & errs.message>
												</cfloop>
												<cfset session.results[key].errMessage = '<span style="color:red">' & session.results[key].errMessage & '</span>'>
												<tr>
													<td style="width:50%;margin:5px;">
														<span onclick="openFile('#Replace(key, "\", "\\", "ALL")#');">
															<strong>#session.results[key].filename#</strong></span><br>
															#key#<br>
															<cfif structKeyExists(session.results[key], "complexity")>
																<cfif session.results[key].complexity GT 1>
																	<a href="file.cfm?file=#key#" target="_blank">Complexity: #session.results[key].complexity#</a>
																</cfif>
															</cfif>
														</td>
														<td style="padding:10px;">
															Errors: <span style="color:red"> #Replace( arrayToList(errsToDisplay), "," ," | ", "All" )# </span><br>
															<br>
															#session.results[key].errMessage#
														</td>
													</tr>
												</cfloop>
											</table>
										</div>
									</cfoutput>
								</div>
							</cfif>
						</div>
					</div>
				</div>
				<div class="yui-b">
					<div id="secondary">
						<form action="" method="post">
							Path (Absolute path to folder or file)<br>
							<input type="text" name="_path" <cfif isDefined( "form._path" )>value="<cfoutput>#form._path#</cfoutput>"</cfif>><br>
							<br>
							File extensions (Defaults to .cfc,.cfm)<br>
							<input type="text" name="_fileExt" <cfif isDefined( "form._fileExt" )>value="<cfoutput>#form._fileExt#</cfoutput>"<cfelse>value=".cfc,.cfm"</cfif>><br>
							<br>
							Exclude paths (Absolute paths, one per line):<br>
							<textarea name="_exclude" ><cfif isDefined( "form._exclude" )><cfoutput>#form._exclude#</cfoutput></cfif></textarea>
							<br>
							<cfdirectory action="list" directory="#ExpandPath('tests')#" name="tests">
								<cfscript>
								testInfo = [];

								// Grab some info about each test.
								for( item in tests ) {
									tempObj       = createObject("component", "tests.#ListFirst(item.name, '.')#");
									tempStr       = tempObj.info();
									tempStr.file  = item;
									arrayAppend(testInfo, tempStr);
								}
							</cfscript>
							<br>
							Tests:<br>
							<label onMouseover="ddrivetip('Run all tests', '##9D9393', 300)" ; onMouseout="hideddrivetip()"><input type="checkbox" onClick="toggle(this)" style="width: inherit;" /> Toggle all</label><br/>
							<br>

							<cfloop array="#testInfo#" index="item">
								<cfoutput>
									<label onMouseover="ddrivetip('#item.description#', '#item.color#', 300)" ; onMouseout="hideddrivetip()"><input type="checkbox" class="testBox" name="test_#item.file.name#" value="#ListFirst(item.file.name, '.')#"<cfif isDefined('testList')><cfif arraycontainsnocase(testList, ListFirst(item.file.name, '.'))> checked="checked"</cfif></cfif>> #item.short#</label><br>
								</cfoutput>
							</cfloop>

							<br>
							<input type="submit" value=" Do the thing! " class="button">
						</form>
						<p class="copyright">
							Copyright 2015, <a href="http://www.MarcusFernstrom.com/" target="_blanks">Marcus Fernstrom</a><br>
							Version 0.1<br>
							License GPL V3<br>
							See source code or license file for details
						</p>
					</div>
				</div>
			</div>
			<div id="ft">
				<div id="footer">

				</div>
			</div>
		</div>

		<!--- Tooltip stuff --->
		<div id="dhtmltooltip"></div>
		<script src='js/tooltip.js'></script>
		<script type="text/javascript">
			function toggle(source) {
				checkboxes = document.getElementsByClassName('testBox');
				console.log(checkboxes);
				for( var i = 0, n = checkboxes.length; i < n; i++ ) {
					checkboxes[i].checked = source.checked;
				}
			}

		  // Ajax function to open file, awesome wizardry here
		  function openFile( _path ) {
		  	var request = new XMLHttpRequest();
		  	request.open('POST', 'index.cfm?path=' + _path, true);
		  	request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
		  	request.send();
		  }
		</script>
	</body>
</html>