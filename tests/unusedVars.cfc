<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/

	/**
	  * @method run
	  * @public
	  * @param {string} _file (required) 
	  * @param {string} _filePath (required)
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = 'Im  the runner for hasInit check' {;
		var varMatches 	= [];
		var unused 			= [];

		var counter 		= 1;
		var theFileArr 	= listToArray( arguments._file, chr(10) );

		for( item in theFileArr ) {
			tempMatch = refindnocase( 'cfset( var)? (\w+)\s?=', item, 1, true );
			// console( serializeJSON(tempMatch) );
			if( tempMatch.len[1] != 0 ){
				tempHit = mid( item, tempMatch.pos[1], tempMatch.len[1] );
				tempHit = reReplace (tempHit, 'cfset|>|var|\s|=.*', '', 'All' );
				arrayAppend( varMatches, {
																		line: counter,
																		variable: tempHit
																	}
										);
			}
			counter = counter + 1;
		}


		if( arrayLen(varMatches) > 0 ) {
			try {
				for( item in varMatches ) {
					foundMatch = false;
					for( i = 1; i < arrayLen(theFileArr); i++ ){
						if( theFileArr[i] contains item.variable && i != item.line ){
							foundMatch = true;
							break;
						}
					}
					if( !foundMatch ) {
						arrayAppend( unused, {
																		line: item.line,
																		variable: item.variable
																	}
												);
					}
				}
			} catch ( any e ){
				console(e);
			}


			if( arrayLen(unused) > 0 ) {
				errToDisp = '';
				for( item in unused ){
					errToDisp = errToDisp & '&nbsp;&nbsp;&nbsp;- Line ' & item.line & ' - ' & item.variable & '<br>';
				}
			}
		}


		if( arrayLen(unused) > 0 ) {
			return {
								_success: true,
								_errors : true,
								_hasTag : false,
								_message: 'Potentially unused variables: <br>' & errToDisp
							};
		} else {
			return {
								_success: true,
								_errors : false,
								_hasTag : true,
								_message: ''
							};
		}
	}



	/**
	  * @method info
	  * @public  
	  * @return {any}
	  */
	public function info() {
		return {
							short				: 'Unused vars',
							description	: 'I look for potentially unused variables',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>