<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/



	/**
	  * I'm the test-runner
	  *
	  * @method run
	  * @public
	  * @param {string} _file (required) 
	  * @param {string} _filePath (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = "I'm the runner for the camelCase and underscores check" {
		var errors 				= false;
		var errorList 		= '';

		try {
			// Checking cftags
			var inFunction 		= false;
			var theFileArr 		= listToArray( arguments._file, chr(10) );
			var varMatches 		= [];
			var nonVarMatches = [];

			var counter = 1;
			for( item in theFileArr ) {

				// Check for cfscript function arguments with missing underscore
				if( arraylen(rematchnocase( '.*function \w+\s?\(.*\)', item )) > 0 ) {
					var stepOne 		= rematchnocase( '\(.*\)', item );
					var theString 	= left(stepOne[1], len(stepOne[1]) - 1);
					theString 			= right(theString, len(theString) - 1);
					theString 			= trim( theString );
					var tempString 	= '';

					if( len( theString ) > 0 ){
						for( i = 1; i <= listLen(theString, ','); i++ ){
							tempString = listGetAt(theString, i);
							if( tempString contains '=' ) {
								tempString = rematchnocase( '.*=', tempString )[1];
								tempString = rereplace( tempString, '\s?\&?=', '', 'ALL');
							}
							tempString = listLast( tempString, ' ' );
							if( left(tempString, 1) != '_' && tempString != 'hint' ){
								errorList = errorList & 'Line ' & counter & ' - Missing underscore for incoming argument(s): ' & tempString & '<br>';
								errors = true;
							}
						}
					}
				}


				if( item contains 'cffunction') { inFunction = true; }
				if( item contains '/cffunction') { inFunction = false; }

				if( inFunction ) {
					// Check for cfargument with missing underscore
					if( arraylen(rematchnocase( 'cfargument.*name\s?=\s?"(\w+)"', item )) > 0 ) {
						var toCheck = rereplace(rematchnocase( 'name\s?=\s?"(\w+)"', item )[1], 'name\s?=\s?|"', '', 'ALL');
						if ( left(toCheck, 1) != '_'){
							errorList = errorList & 'Line ' & counter & ' - Missing underscore for incoming argument(s): ' & toCheck & '<br>';
							errors = true;
						}
					}


					// Check for wrong casing and characters
					tempMatch = rematchnocase( 'cfset.*=', item );
					
					if( arrayLen(tempMatch) > 0 ){
						for( hit in tempMatch ) {
							hit = listGetAt(hit, 1, '=');
							hit = rereplace( hit, 'cfset|var|=|\s|&', '', 'ALL' );
							if( left(hit,1) == '_' ){
								hit = trim(right( hit, len(hit) - 1 ));
							}
							if( arraylen(rematchnocase( '[^a-zA-Z0-9.\[\]]', hit )) > 0 && !hit contains 'arguments.' ) {
								// console( hit );
								errorList = errorList & 'Line ' & counter & ' - Not camelCased: ' & htmleditformat(hit) & '<br>';
								errors = true;
							}
						}
					}
				}
				counter++;
			}

			if( errors ) {
				return {
									_success: true,
									_errors : true,
									_hasTag : true,
									_message:'Casing/underscore errors:<br>' & errorList
								};
			} else {
				return {
									_success: true,
									_errors : false,
									_hasTag : false,
									_message: ''
								};
			}
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
							short				: 'camelCase/underscores',
							description	: 'I look for variables that are not cased right, or contain underscores in bad places.',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>