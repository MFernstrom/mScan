<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/

	/**
		* I'm  the runner for function checks
		* 
	  * @method run
	  * @public
	  * @param {string} _file (required)
	  * @param {string} _filePath (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = 'Im  the runner for function checks' {
		var longFunctions = '';
		
		if( listLast(arguments._filePath, '.') == 'cfc' && listLen(arguments._file, chr(10) > 5) ) {
			// Read file
			var currentFunctionStart 	= 0;
			var inTagFunction 				= false;
			var currentFunctionLength = 0;
			var item 									= '';
			var inScriptTag 					= false;
			var inScript 							= false;
			var lBrackets 						= 0; // {
			var rBrackets 						= 0; // }
			var longFunctionLength 		= 80; // This is the max length a function can be without triggering the long-function warning

			if ( 	listGetAt(arguments._file, 1, chr(10)) contains 'component ' &&
						!listGetAt(arguments._file, 1, chr(10)) contains '<cfcomponent' ) { inScript = true; }

			for( i = 1; i < listLen(arguments._file, chr(10)); i++ ) {
				item = listGetAt(arguments._file, i, chr(10));
				if( item contains '<cffunction' ){
					inTagFunction 				= true;
					currentFunctionStart 	= i;
				}

				if( inTagFunction ){
					if( item contains '</cffunction' ){
						inTagFunction = false;
						currentFunctionLength = i - currentFunctionStart;
						if( currentFunctionLength > longFunctionLength ) {
							longFunctions = listAppend( longFunctions, currentFunctionStart );
						}
					}
				}
			}
		}

		
		if( listLen(longFunctions) > 0 ){
			return {
								_success: true,
								_errors : true,
								_message: 'Found long functions on line(s): ' & longFunctions & '<br>'
							};
		} else {
			return {
								_success: true,
								_errors : false,
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
							short				: 'Function checks',
							description	: 'I look for various function issues (Right now, only looks for large functions)',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>