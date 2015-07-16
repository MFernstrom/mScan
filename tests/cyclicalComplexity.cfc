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
			var errors 			= false;
			var complexity 	= createObject("component","utils.CFComplexityAppDriver").init();
			var rating 			= complexity.getFileComplexityReport( arguments._file ).getBasicComplexityCount();

			var cnt = complexity.getFileComplexityReport( arguments._file ).getFunctions().recordCount;
			
			if ( cnt > 0 ) {
				var aver = round( rating / cnt );
				if ( aver > 10 || rating > 25) {
					errors = true;
				}
			}


			if( errors ) {
				return {
									_success: true,
									_errors : true,
									_message: 'Cyclical complexity rating: ' &
										rating &
										', average per function: ' &
										aver &
										'. <a href="file.cfm?file=' &
										arguments._filePath &
										'" target="_blank">View complexity map</a><br>'
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
			return { 
								_success: true,
							 	_errors : true,
							 	_message: 'An error occured when testing this file.<br>'
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
							short				: 'Cyclical complexity',
							description	: 'I look for files with an average cyclical complexity per function over 10, or a total of over 25',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>