<html>
<head>
   <title>Show the Data</title>
</head>
<body>
   <?PHP
     $dbc = mysql_pconnect('diesel.cs.umass.edu','turtle','hardshell');
     mysql_select_db('snapper_turtles',$dbc);

     $d = mysql_query("SELECT node FROM DEPLOYMENT WHERE depID =\"".$_POST['depID']."\";",$dbc);
     $temp = array();
     $first = true;
     while($row = mysql_fetch_array($d)){
	foreach($row as $num){
		if(!(in_array($num,$temp))){
			$temp[] = $num;
		}
	}     
     }
     $node = implode(',',$temp);	
     echo "<h3>Deployment: ".$_GET['depID']."</h3>";
     echo "<h4>Nodes: ".$node."</h4>";
     $GPS=array('datasrc','sequence','timeinvalid','email_time','timest','gpsvalid','ns','ew','alt','toofewsats',
		'sats','hdil','lat_d','lat_m','lat_dec','lon_d','lon_m','lon_dec');
     $CONN=array('datarc', 'sequence', 'address', 'duration', 'quality', 'timest', 'timeinvalid', 'email_time'); 
     $RT_PATH=array('datasrc', 'sequence', 'path_id', 'count', 'energy', 'probability', 'source_probability', 'timest', 		'timeinvalid', 'email_time'); 
     $RT_STATE=array('datasrc', 'sequence', 'energy_in', 'energy_out', 'batt_volts', 'batt_energy_est', 'temperature', 			'current_state', 'current_grade', 'timest', 'timeinvalid', 'email_time');
     $pkt = array('datasrc','sequence','timest','timeinvalid','email_time');

     $holder = array(array('datasrc','sequence','timest','timeinvalid','email_time',array()));
     

     for($i=0;$i<4;$i++){
		echo "<TABLE border='1'>";
		$track = 0;
		echo "<h3>".$_POST['type'.$i]."</h3>";
		if($_GET['type'.$i] == 'GPS'){
			echo "<tr>";
			foreach($GPS as $num){
				echo "<th>".$num."</th>";
			}
			echo "</tr>";
		}
		if($_GET['type'.$i] == 'CONN'){
			echo "<tr>";
			foreach($CONN as $num){
				echo "<th>".$num."</th>";
			}
			echo "</tr>";
		}
		if($_GET['type'.$i] == "RT_STATE"){
			echo "<tr>";
			foreach($RT_STATE as $num){
				echo "<th>".$num."</th>";
			}
			echo "</tr>";
		}
		if($_GET['type'.$i]== "RT_PATH"){
			echo "<tr>";
			foreach($RT_PATH as $num){
				echo "<th>".$num."</th>";
			}
			echo "</tr>";
		}
		$sql = "SELECT * FROM ".$_GET['type'.$i]." WHERE datasrc IN(".$node.") ORDER BY ".$_GET['time'].";";
		$dbq = mysql_query($sql,$dbc);
		//now spit out the table and rows for the table
		
		$count = 0;
		while ($row = mysql_fetch_array($dbq)) {	
				echo "<TR>";	
				foreach($row as $num){
					//skip every other reading, doubles occur otherwise
					if($count++ % 2 == 0)	
						echo "<TD>".$num.$blank[$track++]."</TD>";	
				}	
				echo "</TR>\n";	
			
		}
		echo "</TABLE>";
	}
	
   ?>
</body>
</html>
