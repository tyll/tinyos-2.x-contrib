<html>
<head>
   <title>Show the Data</title>
</head>
<body>
  <center><h1>Data Visualization</h1></center>
<?php
 //This function adds dilution circles to points and labels them
function CircleDraw($lat_one, $long_one,$radius,$datasrc, $time){
 //convert from degrees to radians
 $lat1 = deg2rad($lat_one);
 $long1 = deg2rad($long_one);
 $d = $radius;
 $d_rad = $d/6378137;
 $hex = 0xC249255;
 $color = $datasrc*$hex;
 $out = "<name>Data Visualization</name>\n";
 $out .= "<visibility>1</visibility>\n";
 $out .= "<Placemark>\n";
 $out .= "<name>Dilution for node ".$datasrc." at ".$time."</name>\n";
 $out .= "<visibility>1</visibility>\n";
 $out .= "<Style>\n";
 $out .= "<geomColor>".dechex($color)."</geomColor>\n";
 $out .= "<geomScale>1</geomScale></Style>\n";
 $out .= "<LineString>\n";
 $out .= "<coordinates>\n";
 // loop through the array and write path linestrings
 for($i=0; $i<=360; $i++) {
   $radial = deg2rad($i);
   $lat_rad = asin(sin($lat1)*cos($d_rad) + cos($lat1)*sin($d_rad)*cos($radial));
   $dlon_rad = atan2(sin($radial)*sin($d_rad)*cos($lat1),
		     cos($d_rad)-sin($lat1)*sin($lat_rad));
   $lon_rad = fmod(($long1+$dlon_rad + M_PI), 2*M_PI) - M_PI;
   $out .= rad2deg($lon_rad).",".rad2deg($lat_rad).",0 ";
 }
 $out .= "</coordinates>\n";
 $out .= "</LineString>\n";
 $out .= "</Placemark>\n";

 return $out;
}

//draw trails for each node
function DrawPoly($points, $node){
  $out = "<Placemark>\n";
  $out .= "<name>Path for node ".$node."</name>";
  $out .= "<visibility>1</visibility>\n";
  $out .= "<Style>\n";
  $out .= "<geomColor>000000</geomColor>\n";
  $out .= "</Style>\n";
  $out .= "<LineString>\n";
  $out .= "<coordinates>\n";
  $out .= $points;
  $out .= "</coordinates>\n";
  $out .= "</LineString>\n";
  $out .= "</Placemark>\n";

  return $out;
}


?>
   <?PHP


     //Check for proper date
     $sl = strpos($_POST['date'],"/");
     if($sl)
	$sl = strpos($_POST["date"],"/",$sl);
     if(!($sl))
	$err_msg = "Please enter date in mm/dd/year format";

     function date_range($day, $month, $year)
     {
     	if($month < 1 || $month > 12)
		return "Month out of range";
	if($day < 1)
		return "Date out of range";
	if($month == 09 || $month == 04 || $month == 06 || $month == 11){
		if($day > 30)
			return "Date out of range";
	}
	elseif($month == 02){
		//check for leap years
		if(($year % 4 == 0) && (($year % 100 <> 0) || ($year % 400 == 0))){
			if($day > 29)
				return "Date out of range";
		}
		elseif($day >28)
			return "Date out of range";
	}
	else{
		if($day > 30)
			return "Date out of range";
		else
			return NULL;
	}

     }

     list($month, $day, $year) = split("/",$_POST["date"]);
     $err_msg = date_range($day, $month, $year);
//setup database
     $dbc = mysql_connect('diesel.cs.umass.edu','turtle','hardshell');
     mysql_select_db('snapper_turtles',$dbc);

     $query_var = "";
	 $vishost = "http://".$_SERVER['HTTP_HOST'];
	 $visdir = dirname($_SERVER['PHP_SELF']);
	 $visfulldir = $vishost.$visdir;

     if($err_msg == NULL){
     	//select max and minimum times for date range, '2008/01/01' is so garbage readings are ignored
     	$sql = "SELECT MAX(local_stamp), MIN(local_stamp) FROM GPS WHERE local_stamp > '2008/01/01';";
     	$dbq = mysql_query($sql,$dbc);
     	while ($row = mysql_fetch_assoc($dbq))
     	{
		$max = $row['MAX(local_stamp)']."\n";
		$min =  $row['MIN(local_stamp)']."\n";
     	}
     	list($date, $time) = split(" ", $max);
     	list($maxyear, $maxmonth, $maxday) = split("-",$date);
     	list($date, $time) = split(" ", $min);
     	list($minyear, $minmonth, $minday) = split("-",$date);
	if($day < $minday || $day > $maxday || $month < $minmonth || $month > $maxmonth || $year < $minyear || $year> $maxyear)
		$err_msg = "Date given is out of range for deployment";
	else
		$query_var = "WHERE local_stamp > '".$year."/".$month."/".$day."'";
     }

//open kml file for writing
     if(file_exists("data.kml"))
	$goo = fopen("data.kml","w");
     else
	echo "File does not exist.";

//begin writing to kml file using data.kml
     $output = "<?xml version=\"1.0\" encoding= \"UTF-8\" ?>\n";
     $output .= "<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n";
     $output .= " <Document>\n";
     $sql = "SELECT node FROM DEPLOYMENT WHERE node IS NOT NULL;";
     $dbq = mysql_query($sql,$dbc);
     while($row = mysql_fetch_assoc($dbq))
     {
	$num = $row['node'];
	$output .= "  <Style id= \"node".$num."\" >\n";
	$output .= "\t<IconStyle>\n";
	$output .= "\t <Icon>\n";
	$output .= "<href>$visfulldir/markers/baloon".$num.".png</href>\n";
	$output .= "\t </Icon>\n";
	$output .= "\t</IconStyle>\n";
	$output .= "  </Style>";

     }
     $sql = "SELECT * FROM GPS ".$query_var." ORDER BY local_stamp;";

     //echo $sql;
     $dbq = mysql_query($sql,$dbc);
     $datasrcs = array();

     while ($row = mysql_fetch_assoc($dbq))
     {
	if($_POST['node'.$row['datasrc']]==$row['datasrc'])
	{
		//check for zeros, ignore them.
		//Also try to ensure the coordinates are within U.S.
		if($row['lat_dec'] !=0 && $row['lat_dec'] > 25 && $row['lat_dec'] < 50 && $row['lon_dec'] != 0 && $row['lon_dec'] > 60 && $row['lon_dec'] < 125)
		{
			$point = "-".$row['lon_dec'].",".$row['lat_dec'];
			$output .= "  <Placemark>\n";
			$output .= "\t<TimeStamp>\n";
			list($date, $time) = split(' ',$row['local_stamp']);
			$output .= "\t <when>".$date."T".$time."Z"."</when>\n";
			$output .= "\t</TimeStamp>\n";
			$output .= "\t<name>".$row['datasrc']."</name>\n";
			$output .= "\t<description>".$row['local_stamp']."</description>\n";
			$output .= "\t<StyleUrl>#node".$row['datasrc']."</StyleUrl>\n";
			$output .= "\t<Point>\n";
			$output .= "\t  <coordinates>".$point."</coordinates>\n";
			$output .= "\t</Point>\n";
			$output .= "  </Placemark>\n";
			if($_POST['hdil']=="hdil")
				$output .= CircleDraw((float)$row['lat_dec'],-1*(float)$row['lon_dec'],(float)$row['hdil'],(float)$row['datasrc'],$row['local_stamp']);

			//Add Points to respective arrays for polyline drawing
			if(!(isset(${"src".$row['datasrc']})))
			{
			  ${"src".$row['datasrc']} = $point.",0 ";
			  $datasrcs[] = $row['datasrc'];

			}
			else
			   ${"src".$row['datasrc']} .= $point.",0 ";
		}
	}

     }

     //Check to see if path should be drawn, if it is loop through and add paths.
     if($_POST['path']=="path")
     {
     	foreach($datasrcs as $num)
     	{
     	  $output .= DrawPoly(${"src".$num},$num);
     	}
     }
     $output .= " </Document>\n";
     $output .= "</kml>\n";
     fwrite($goo,$output);
    ?>


   <br><br>
   <h2>
   <ul>
   <li><? echo $visfulldir ?></li>
   <li><a href="getkml.php?dep=Miss" target="blank">GetKML</a></li>
   <li><a href="works.php">Show Raw Data</a></li>
   <li><a href="data.kml">KML file for Google Earth</a></li>
   <li><a href="http://maps.google.com/maps?q=<? echo $visfulldir."/data.kml" ?>">
   See the same file in Google Maps</a></li>
   <form name="input" action="index.php" method="POST">
   </h2>
   <li>Regenerate KML file with readings taken since: </li>
   <input type="text" name="date"><h2>
   <h6><?PHP echo $err_msg ?></h6>

   <li>Include:</li>
   <!--- Generate the node list and the options for paths and hdilution being shown ---!>
   <?php
     $sql = "SELECT node FROM DEPLOYMENT WHERE node IS NOT NULL ORDER BY node;";
     //echo $sql;
     $dbq = mysql_query($sql,$dbc);
     $count = 0;
     while ($row = mysql_fetch_assoc($dbq))
     {
	if($count++ % 2 != 0){
		echo "<input type=\"checkbox\" name=\"node".$row['node']."\" value=\"".$row['node']."\"";
		if(isset($_POST['node'.$row['node']]))
			echo "checked>"."Node:".$row['node']."</input>";
		else
			echo ">"."Node:".$row['node']."</input>";
		if($row['node']<10)
			echo "&nbsp;&nbsp;";
		if($count % 5 == 0)
			echo "<br>";
	}
      }
   ?>
   <br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <input type="checkbox" name="hdil" value="hdil"
   <?php
	if(isset($_POST['hdil']))
		echo "checked";
	echo ">Dilution</input>";
   ?>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   <input type="checkbox" name="path" value="path"
   <?php
	if(isset($_POST['path']))
		echo "checked";
	echo ">Paths</input>";
   ?>

   </ul>
   <br>
   <input type="submit" value="Submit" />
   <div>
   <? echo $output; ?>
   </div>
   </form>




</body>
</html>
