<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/


	/**
		* I'm the runner for file length check
		* 
	  * @method run
	  * @public
	  * @param {string} _file (required)   
	  * @return {any}
	  */
	public function run( required string _file, required string _filePath ) hint = 'Im the runner for file length check' {
		if( !listLen( arguments._filePath, chr(10) ) > 400 ) {
			return { 
								_success: true,
								_errors : false,
								_hasTag : true,
								_message: ''
							};
		} else {
			return {
								_success: true,
								_errors	: true,
								_hasTag : false,
								_message: 'This file is over 400 lines long<br>'
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
							short				: 'File length',
							description	: 'I look for long files',
							color				: '##C8E8F6'
						};
	}
</cfscript></cfcomponent>