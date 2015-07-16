<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/
	
	/**
	  * @method joinTheData
	  * @public
	  * @param {any} _itemName
	  * @param {any} _short
	  * @param {any} _fullpath
	  * @param {any} _color
	  * @param {any} [_message = '' ]  
	  */
	public function joinTheData( _itemName, _short, _fullpath, _color, _message = '' ){
		// Go-between between the test-threads and the final result variable.
		try {
			if( !structKeyExists(session.results, arguments._fullpath) ) {
				session.results[arguments._fullpath] 					= {};
				session.results[arguments._fullpath].errors 	= [];
				session.results[arguments._fullpath].filename	= arguments._itemName;
			}

			var err 			= {};
			err.test 			= arguments._short;
			err.message 	= arguments._message;

			arrayAppend( session.results[arguments._fullpath].errors, err );
		} catch ( any e ) {
			console( e );
		}
	}
</cfscript></cfcomponent>