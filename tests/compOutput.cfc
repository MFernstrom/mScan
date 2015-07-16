<cfcomponent><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/


	/**
		* I'm the runner for component output check
		* 
	  * @method run
	  * @public
	  * @param {string} _file (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = 'Im  the runner for component output check' {
		// Check if the file is a cfc
		if( listLast(arguments._filePath, '.') == 'cfc' ) {
			var theFileArr = listToArray( arguments._file, chr(10) );

			for( line in theFileArr ){
				if( line contains "component" && line contains "output" ){
						return { 	
									_success: true,
									_errors : false,
									_hasTag : true,
									_message: ''
								};
				}
			}
			// Reaching this point means no output defines
			return { 
								_success: true,
								_errors : true,
								_hasTag : false,
								_message: 'Component does not have output defined<br>'
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
							short: 'Component output tags',
							description: 'I check to see if components have output set',
							color: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>