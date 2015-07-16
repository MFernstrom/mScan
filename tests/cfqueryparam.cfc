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
	public function run( required string _file, required string _filePath ) hint = 'Im  the runner for the cfqueryparam check' {;
		// Read file
		var theFile = arguments._file;

		if( theFile contains 'cfquery' && !theFile contains 'cfqueryparam' ){
			return {	
								_success: true,
								_errors : true,
								_hasTag : false,
								_message: 'Do not use cfquery without cfqueryparam<br>'
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
							short				: 'Cfqueryparam',
							description	: 'I look for missing cfqueryparam in cfquery blocks',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>