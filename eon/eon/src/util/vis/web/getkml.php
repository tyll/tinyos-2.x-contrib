<?PHP
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
	echo "<kml xmlns=\"http://www.opengis.net/kml/2.2\">";
	echo "<Document>";
?>

<?PHP

	include 'kmlutil.php';
	
	$client = $_REQUEST['client'];
	if ($client == "ge")
	{
		header("Content-type: application/vnd.google-earth.kml+xml");
	} else {
		header("Content-type: application/xml");
	}

	
//connect to database
     $dbc = mysql_connect('diesel.cs.umass.edu','turtle','hardshell');
     mysql_select_db('snapper_turtles',$dbc);

//figure out the current URL for building KML references
	 $vishost = "http://".$_SERVER['HTTP_HOST'];
	 $visdir = dirname($_SERVER['PHP_SELF']);
	 $visfulldir = $vishost.$visdir;

//get query variables
	 $depid = $_REQUEST['dep'];
	 comment("DEPID=$depid");
	 $drawpaths = $_REQUEST['path'];
	 $drawhdil = $_REQUEST['hdil'];

//load deployments
	$deps = array();
	if ($depid == 'ALL')
	{
		$sql = "SELECT distinct depID FROM DEPLOYMENT;";

	} else {
		$sql = "SELECT distinct depID FROM DEPLOYMENT WHERE depID = \"$depid\";";
	}

	$dbq = mysql_query($sql,$dbc);
    while ($row = mysql_fetch_assoc($dbq))
    {
		$deps[] = $row['depID'];
    }
	if (count($deps) < 1)
	{
		$errmsg  = "ERROR!!!! NO DEPLOYMENT FOUND!!!! \n";
	}
	//print_r($deps);
	$depstr = "";
	 foreach ($deps as $dep)
	 {
	 	$depstr .= "\"$dep\",";
	 }
	 $depstr = rtrim($depstr, ",");
	 

	 
	 
	 //Get number of distinct styles needed - rename these to support multiple deployments at once
     $sql = "SELECT distinct depID,node FROM DEPLOYMENT WHERE node IS NOT NULL AND depID IN ($depstr);";
     $dbq = mysql_query($sql,$dbc);
     while($row = mysql_fetch_assoc($dbq))
     {
		$num = $row['node'];
		$stylename=$row['depID'].$num;
		echo icon_style_img($stylename, "$visfulldir/markers/balloon".$num.".png");
     }
	 
     //get burrows
     $sql = "SELECT * FROM BURROW;";
     comment($sql."\n");
     $dbq = mysql_query($sql,$dbc);
     while ($row = mysql_fetch_assoc($dbq))
     {
	comment("a burrow...");
	echo "   <Placemark>\n";
	echo "\t<styleUrl>#burrow</styleUrl>\n";
	echo "\t<name>Burrow ".$row['BURROW_ID']."</name>\n";
	echo "\t<Point>\n\t  <coordinates>".$row['POINT_X'].",".$row['POINT_Y']."</coordinates>\n\t</Point>\n";
	echo "   </Placemark>\n";
     }

     
     //get involved base stations
     $sql = "SELECT * FROM DEPLOYMENT where baseID IS NOT NULL and depID IN ($depstr);";
     comment($sql."\n");
     $dbq = mysql_query($sql,$dbc);
     $datasrcs = array();

     while ($row = mysql_fetch_assoc($dbq))
     { 
	//put the basestation on the map
	comment("a basestation...");
	echo "  <Placemark>\n";
	ehco "\t<name>".$row['baseID'].</name>\n";
	echo "\t<description>From ".$row['start_date']." to ".$row['end_date']."</description>\n";
	echo "\t<Point>\n";
	echo "\t  <coordinates>".$row['EW'].",".$row['NS']."</coordinates>\n";
	echo "\t</Point>\n";
	echo "  </Placemark>\n";

	comment("a row...");
	$gpssql = "select * from GPS where baseID=\"".$row['baseID']."\" and email_time >= \"".$row['start_date']."\" AND email_time <= \"".$row['end_date']."\"";
	comment($gpssql);
	$gpsdbq = mysql_query($gpssql, $dbc);
	
	while ($gpsrow = mysql_fetch_assoc($gpsdbq))
	{
		comment("a gpsrow...");
		if($gpsrow['lat_dec'] !=0 && $gpsrow['lon_dec'] != 0 && $gpsrow['gpsvalid'] == 1 && $gpsrow['timeinvalid'] == 0)
		{
			//adjust +/- for readings
			if( $gpsrow['ew'] == 0 )
				$lon = -1 * (float)$gpsrow['lon_dec'];
			else
				$lon = $gpsrow['lon_dec'];
			if( $gps['ns'] == 1 )
				$lat = -1 * (float)$gpsrow['lat_dec'];
			else
				$lat = $gpsrow['lat_dec'];

			$point = $lon.",".$lat;
			echo "  <Placemark>\n";
			echo TimeStamp($gpsrow['local_stamp']);
			echo "\t<name>".$gpsrow['datasrc']."</name>\n";
			echo "\t<description>".$gpsrow['local_stamp']."</description>\n";
			echo "\t<styleUrl>#node".$gpsrow['datasrc']."</styleUrl>\n";
			echo "\t<Point>\n";
			echo "\t  <coordinates>".$point."</coordinates>\n";
			echo "\t</Point>\n";
			echo "  </Placemark>\n";
			if($drawhdil=="y")
				echo CircleDraw((float)$lat,$lon,(float)$gpsrow['hdil'],(float)$gpsrow['datasrc'],$gpsrow['local_stamp']);

			//Add Points to respective arrays for polyline drawing
			if(!(isset(${"src".$gpsrow['datasrc']})))
			{
		       	${"src".$gpsrow['datasrc']} = $point.",0 ";
				$datasrcs[] = $gpsrow['datasrc'];
			}
			else
				${"src".$gpsrow['datasrc']} .= $point.",0 ";
		}
	}
	
	// Draw possible connection spots between node and base stations
	comment("a row...");
	$consql = "SELECT * FROM CONN WHERE baseID=\"".$row['baseID']."\ AND email_time >= \"".$row['start_date']."\" AND email_time <= \"".$row['end_date']."\"";
	comment($consql);
	$condbq = mysql_query($consql, $dbc);

	while($conrow = mysql_fetch_assoc($condbq))
	{
		comment("a connection...");
		if($conrow['timeinvalid'] == 0)
		{
			echo drawConn($row['NS'], $row['EW'], 200, $conrow['datasrc'], $row['baseID'], $conrow['local_stamp']);
		}
	}
     }
	 
	 
     

     //Check to see if path should be drawn, if it is loop through and add paths.
     if($drawpaths == "y")
     {
     	foreach($datasrcs as $num)
     	{
     	  echo DrawPoly(${"src".$num},$num);
     	}
     }
?>
	
<?PHP echo "</Document>\n</kml>";?>