<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/


	/**
		* I'm the runner for the CFDoc tags check
		* 
	  * @method run
	  * @public
	  * @param {string} _file (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = 'Im the runner for the CFDoc tags check' {
		if( listLast(arguments._filePath, '.') == 'cfc' ) {
			if( !arguments._file contains '@method' && arguments._file contains 'function ') {
				return { 
									_success: true,
									_errors : true,
									_hasTag : false,
									_message: 'File does not contain CFDoc comment blocks<br>'
								};
			} else {
				return {
									_success: true,
									_errors : false,
									_hasTag : true,
									_message: ''
								};
			}
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
							short				: 'CFDoc Tag',
							description	: 'I look for missing CFDoc tags',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>