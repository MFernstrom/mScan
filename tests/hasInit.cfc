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
		if( listLast(arguments._filePath, '.') == 'cfc' ) {
			var theFile = arguments._file;

			if( !theFile contains 'init(' && !theFile contains '"init"'){
				return {
									_success: true,
									_errors : true,
									_hasTag : false,
									_message: 'Component does not have an init function<br>'
								};
			} else {
				return {
									_success: true,
									_errors : false,
									_hasTag : true, 
									_message:''
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
							short				: 'Component init',
							description	: 'I look for components missing init functions',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>