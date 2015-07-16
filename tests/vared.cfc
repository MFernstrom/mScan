<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/



	/**
	  * I'm the runner for the var check
	  *
	  * @method run
	  * @public
	  * @param {string} _file (required) 
	  * @param {string} _filePath (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = "I'm the runner for the var check" {
		var errors 				= false;
		var errorList 		= '';

		try {
			// if (arguments._filePath == "C:\svn\Royall2.0\webapps\theruntime\mxunit\framework\CSVUtility.cfc") {
			// Checking cftags
			var inFunction 		= false;
			var theFileArr 		= listToArray( arguments._file, chr(10) );
			var varMatches 		= [];
			var nonVarMatches = [];

			var counter = 1;
			for( item in theFileArr ) {
				if( item contains 'cffunction') { inFunction = true; }
				if( item contains '/cffunction') { inFunction = false; }

				if( inFunction ) {
					tempMatch = refindnocase( 'cfset var (\w+)', item, 1, true );
					// tempMatch = refindnocase( '<cfargument name="(\w+)"', item, 1, true );
					if( tempMatch.len[1] != 0 ){
						// console( serializeJSON(tempMatch) );
						tempHit = mid(item, tempMatch.pos[1] + 5, tempMatch.len[1]);
						tempHit = reReplace(tempHit, '>|var|\s|=.*','','All');
						arrayAppend( varMatches, trim( tempHit ) );
					}

					tempMatch = refindnocase( 'cfset (\w*)\s?=', item, 1, true );
					if( tempMatch.len[1] != 0 ){
						tempHit = mid(item, tempMatch.pos[1] + 5, tempMatch.len[1]);
						tempHit = reReplace(tempHit, 'cfset |\s?=.*','','All');
						arrayAppend( nonVarMatches, { theVar : trim( tempHit ), linenr : counter } );
					}

				}
				counter++;
			}

			for( item in nonVarMatches ) {
				if( !arrayContains(varMatches, item.theVar) ) {
					if( !listContainsNoCase( errorList, item.theVar ) ) {
						errorList = errorList & 'Line ' & item.linenr & ' - ' & item.theVar & '<br>';
						errors = true;
					}
				}
			}

			// cfscript checks here

			if( errors ) {
				return {
									_success: true,
									_errors : true,
									_hasTag : true,
									_message:'Unvared variables:<br>' & errorList
								};
			} else {
				return {
									_success: true,
									_errors : false,
									_hasTag : false,
									_message: ''
								};
			}
		// }
		} catch( any e ) {
			console(e);
		}
	}



	/**
	  * @method info
	  * @public  
	  * @return {any}
	  */
	public function info() {
		return {
							short				: 'Unvared variables',
							description	: 'I look for unvared variables in cffunctions (Tags only at the moment)',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>