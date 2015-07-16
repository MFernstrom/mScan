<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/

	/**
		* I'm  the runner for form checks
		* 
	  * @method run
	  * @public
	  * @param {string} _file (required) 
	  * @param {string} _filePath (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = "I'm  the runner for form checks" {;
		if( listLast(arguments._filePath, '.') != 'cfc' ) {
			// Read file
			var theFile = arguments._file;

			if( theFile contains '<cfform' ){
				return {
									_success: true,
									_errors : true,
									_hasTag : false,
									_message: 'Do not use cfform<br>'
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
							short: 'Form checks',
							description: 'I look for various form issues',
							color: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>