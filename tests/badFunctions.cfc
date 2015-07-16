<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/

	/**
		* I'm the runner for this component
		* 
	  * @method run
	  * @public
	  * @param {string} _file (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = 'Im the runner for this component' {
		try {
			var theFile 		= arguments._file;
			var theFileArr 	= listToArray( arguments._file, chr(10) );
			var badList 		= [	'structnew',
													'arraynew',
													'isdefined' ];
			var matches 		= '';
			var errors 			= '';
			var count 			= 1;

			for( line in theFileArr ) {
				for( item in badList ) {
					if( line contains item ) {
						if( !listContainsNoCase(errors, count) ) {
							errors = listAppend(errors, count);
						}
					}
				}
				count++;
			}

			if( len(errors) > 0 ) {
				return {
								 	_success: true,
									_errors : true,
									_message: 'File contains deprecated functions on line(s): ' & errors & '<br>'
								};
			} else {
				return {
									_success: true,
									_errors : false,
									_message: ''
								};
			}
		} catch( any e ) {
			console( e );
		}
	}



	/**
	  * @method info
	  * @public  
	  * @return {any}
	  */
	public function info() {
		return {
						 	short				: 'Old style tags/functions',
							description	: 'I look for deprecated tags/functions',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>