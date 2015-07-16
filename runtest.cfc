<cfcomponent output="false"><cfscript>
	/**
		* @Author Marcus Fernstrom
		* @Copyright 2015
		* @About Part of mScan
		*/

	
	/**
	  * @method runTests
	  * @public
	  * @param {any} form
	  * @return {any}
	  */
	public function runTests( form ) {
		// If we have a path, we run tests
		
		if( len( form._path ) > 0 ) {
			// form.fieldnames contains the selected tests.
			testList 	= '';
			arrList 	= listToArray( form.fieldnames );

			// Loop and create list of tests with proper names
			for( item in arrList ){
				if( item contains 'test_' ) {
					testList = listAppend( testList, listFirst(listLast(item, '_'), '.') );
				}
			}

			// If no file extension is specified, we default to .cfc and .cfm
			if( len(form._fileExt) == 0 ){
				console( 'No file extension specified, using default of .cfc, .cfm' );
				form._fileExt = '.cfc,.cfm';
			}

			// If any tests have been selected, we do the thing.
			console( 'Building list of files' );
			
			if( listLen(testList) != 0 ){
				// Instantiate variables
				var fileOrDir 					= getFileInfo( form._path );
				if ( fileOrDir.type == 'directory' ) {
					console( 'Path is a directory' );
					tempFileList = directoryList( form._path, true );
				} else {
					console( 'Path is a file' );
					tempFileList = [ form._path ];
				}

				fileList 								= [];
				checks 									= [];
				session.results 				= {};
				session.errorBreakdown 	= {};
				threadList 							= '';

				// Maketh thee into an array.
				testList = listToArray( testList );

				// Grab some info about each test.
				for( item in testList ) {
					tempObj 			= createObject( "component", "tests.#item#" );
					tempStr 			= tempObj.info();
					tempStr.file 	= item;
					arrayAppend( checks, tempStr );
				}

				// Ensure only wanted files are on the list
				console( 'Cleaning up list' );
				if ( len(form._exclude) > 0 ){
					theExcludes = listToArray(form._exclude, chr(10));
					for ( item in tempFileList ) {
						if ( form._fileExt contains listLast(item, '.') ) {
							arrayAppend( fileList, item );
						}
						for ( item in theExcludes ) {
							counter = 1;
							for ( check in fileList ) {
								if ( check contains trim(item) ) {
									arrayDeleteAt( fileList, counter );
								}
								counter++;
							}
						}
					}
				} else {
					for ( item in tempFileList ) {
						if ( form._fileExt contains listLast(item, '.') ) {
							arrayAppend( fileList, item );
						}
					}
				}

				arraySort( fileList, "textnocase" );

				// Set up reference to the result helper component, needed due to threads
				resultObj = createObject( "component", "utils.result" );

				if( arrayLen( fileList ) > 0 ) {

					// Loop each item in the filelist
					for ( item in fileList ) {

						// Threads are per file tested, not per test
						threadList = listAppend( threadList, item );
						console( 'Starting test for: ' & item );

						// Run checks
						try {
							// Set up threads
							thread name="#item#" checks = checks item = item resultObj = resultObj {
								for ( check in checks ) {
									////
										//// Try dealing with memory usage issues.
										//// The idea is simple, if memory usage is above the threshold then pause for 1 second, check again, rinse and repeat.
										//// You can still run out of memory, but I found it to happen much more seldom with this check.
										mf 				= CreateObject("java", "java.lang.management.ManagementFactory");
										memBean 	= mf.getMemoryMXBean();
										heapMem 	= memBean.getHeapMemoryUsage();
										
										// Compare current memory with max allowed, if it's above the threshold then pause for a second.
										while ( Round(heapMem.getUsed()/1024/1024) > (Round(heapMem.getMax()/1024/1024) * 0.7) ){
											pause(1);
										}
										//// Seems to work. For the most part.
									////

									checkObj 			= createObject( "component", "tests.#check.file#" );
									theFile 			= fileRead( item );
									currentCheck 	= checkObj.run( theFile, item );
									
									if( currentCheck._errors ) {										
										resultObj.joinTheData(	
																						_itemName = listLast(item, '\'),
																						_short 		= check.short,
																						_fullPath = item,
																						_color 		= check.color,
																						_message 	= currentCheck._message
																					);
									}
								}
							} // End of thread

						} catch( any e ) {
							console( 'Error in threads' );
							console( e );
						}
					}

					// Join the threads
					console( 'Waiting for threads to finish..' );
					thread action = "join" name = "#threadList#";
					console( 'Threads have finished' );
				}
			}
		}
		return  {
							fileList: fileList,
							testList: testList
						};
	}
</cfscript></cfcomponent>