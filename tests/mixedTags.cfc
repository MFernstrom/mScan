<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/


	/**
		* I'm the runner for the mixed tags check
		* 
	  * @method run
	  * @public
	  * @param {string} _filePath (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = 'Im the runner for the mixed tag check' {
		var theFile		= arguments._file;
		var checkFile	= false;
		var errors 		= false;

		if( theFile contains '<cfscript>' ) { checkFile = true; }

		if( checkFile ) {
			theFile = rereplaceNoCase( theFile, '<cfcomponent [\w =\"\.>]+>', '', 'All' );
			theFile = replaceNoCase( theFile, '</cfcomponent>', '', 'All' );
			theFile = replaceNoCase( theFile, '<cfscript>', '', 'All' );
			theFile = replaceNoCase( theFile, '</cfscript>', '', 'All' );

			if( theFile contains '<cf' && theFile contains ';' ) {
				errors = true;
			}
		}

		if( errors ) {
			return {
								_success: true,
								_errors : true,
								_message: 'Mixed cftags and cfscript<br>' };
		} else {
			return {
								_success: true,
								_errors : false,
								_message: '' };
		}
	}



	/**
	  * @method info
	  * @public  
	  * @return {any}
	  */
	public function info() {
		return {
							short				: 'Mixed tags/script',
							description	: 'I look for mixed cfscript and cftags',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>