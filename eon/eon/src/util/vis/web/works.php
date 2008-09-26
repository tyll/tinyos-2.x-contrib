<html>
<head>
   <title>Show the Data</title>
</head>
<body>
   
   <?PHP
     
     $dbc = mysql_connect('diesel.cs.umass.edu','turtle','hardshell');
     mysql_select_db('snapper_turtles',$dbc);

     $d = mysql_query("SELECT node FROM DEPLOYMENT WHERE depID =\"".$_POST['depID']."\" and node is not NULL;",$dbc);
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
     $temp = array();
     $d = mysql_query("SELECT baseID FROM DEPLOYMENT WHERE depID =\"".$_POST['depID']."\" and baseID is not NULL;",$dbc);
     $temp = array();
     $first = true;
     while($row = mysql_fetch_array($d)){
	foreach($row as $num){
		if(!(in_array($num,$temp))){
			$temp[] = $num;
		}
	}     
     }
     $base = implode(',',$temp);
     $temp = array();
     $GPSBOX=false;
     $CONNBOX=false;
     $RT_PATHBOX=false;
     $RT_PATHBOX=false;
     $BASESTATIONBOX=false;
     $timestBOX = "";
     $email_timeBOX = "";  
     $sequenceBOX = "";
     

     echo "<h3>Deployment: ".$_POST['depID']."</h3>";
     echo "<h4>Nodes: ".$node."</h4>";
     ${$_POST['time'].'BOX'} = "checked";
     	for($i=0;$i<5;$i++)
	{
		$count = 0;
		${$_POST['type'.$i].'BOX'} = true;//check apropriate boxes
		
		if($_POST['group']=='dataType')
     		{
			$datatype= true;
			echo "<TABLE border='1'>";
			//labels($_POST['type'.$i],1);
			if($_POST['type'.$i] == "BASESTATION")
				$sql = "SELECT * FROM ".$_POST['type'.$i]." WHERE baseID IN(".$base.") ORDER BY email_time;";
			else
				$sql = "SELECT * FROM ".$_POST['type'.$i]." WHERE datasrc IN(".$node.") ORDER BY ".$_POST['time'].";";
			//echo $sql;
			$dbq = mysql_query($sql,$dbc);
			//now spit out the table and rows for the table
			echo "<h3>".$_POST['type'.$i]."</h3>";
			while ($row = mysql_fetch_array($dbq)) 
			{		
				$out = "";
				$labels = "";
				foreach($row as $key => $num)
				{
				//skip every other reading, doubles occur otherwise
					if($count++ % 2 == 0)	
						$out .= "<TD>".$num."</TD>\n";	
					else
						$labels .= "<th>".$key."</th>\n";
					}	
					echo "<TR>\n".$labels."</TR>\n";	
					echo "<TR>\n".$out."</TR>\n";	
				}	
			echo "</TABLE>";
			
		}
		
	}
	if($_POST['group']=='seq')
	{
		$sequence = true;
		echo "<TABLE border='1'>";
		$go = true;
		$temp = array();
		$count = 0;
		$getAll[0] = "select * from GPS where datasrc in(".$node.") order by ".$_POST['time'].";";
		$G_Arr = array(array());
		$getAll[1] = "select * from CONN where datasrc in(".$node.") order by ".$_POST['time'].";";
		$getAll[2] = "select * from RT_STATE where datasrc in(".$node.") order by ".$_POST['time'].";";
		$getAll[3] = "select * from RT_PATH where datasrc in (".$node.") order by ".$_POST['time'].";";
		for($i=0;$i<5;$i++){	
			if($_POST['type'.$i] == "BASESTATION")
				$sql = "SELECT * FROM ".$_POST['type'.$i]." WHERE baseID IN(".$base.") ORDER BY email_time;";
			else
				$sql = "SELECT * FROM ".$_POST['type'.$i]." WHERE datasrc IN(".$node.") ORDER BY ".$_POST['time'].";";
			$dbq = mysql_query($sql, $dbc);
			while($row = mysql_fetch_array($dbq))
			{
				$G_Arr[$count++] = $row;
			}
		}
		$sorted = MergeSort($G_Arr);
		foreach($sorted as $num){
			$count = 0;
			$label = "";
			$out ="";
			foreach($num as $key => $each)
			{
				if($count++ % 2 == 0)
					$out .= "<td>".$each."</td>";
				else
					$label .= "<th>".$key."</th>";
			}
			echo "<TR>\n".$label."</TR>\n";	
			echo "<TR>\n".$out."</TR>\n";
		}
		
	}
	echo "</table>";

   ?>
     <form action="works.php" method="POST" > 
   <h3>Deployment:</h3>
      <?php
	$link = mysql_connect("diesel.cs.umass.edu", "turtle", "hardshell") or die("Could not connect: " . mysql_error());
	mysql_selectdb("snapper_turtles",$link) or die ("Can\'t use dbmapserver : " . mysql_error());

	$result = mysql_query("SELECT DISTINCT depID FROM DEPLOYMENT;",$link);	
	if (!$result)
	{
		echo "No deployments available.";
	}
	else
	{
		echo "<select name=depID>\n";
		echo "<option></option>\n";
		while($row = mysql_fetch_array($result))
		{
			echo "<option value=\"".$row['depID']."\">".$row['depID']."</option><br>\n";
		}	
		
	}
	mysql_close($link);
	
	function slice_array($arr,$from,$to){
        	if($from>$to) return $arr;
        	elseif($from==$to) return $arr[$from];
        	if(!is_array($arr)||count($arr)==1) {return $arr;}
        		else{	
                		$new=array();$a=$to-$from;
        	        	for($i=0;$i<$a;$i++){
       	        	        	 $new[$i]=$arr[$from++];
       	       		  }
       	 }
 
        	return $new;
	}
	
	function merge_array($x,$y){
	        $new=array();
	        for($i=0;$i<count($x);$i++){
	                $new[$i]=$x[$i];
	        }
	        for($j=0;$j<count($y);$j++){
	                $new[count($x)+$j]=$y[$j];
	        }
	        return $new;
	}
	
	function MergeSort($a){
        	if (count($a)>1){
        	        $cent=floor(count($a)/2);
        	        $b=MergeSort(slice_array($a,0,$cent));
        	        $c=MergeSort(slice_array($a,$cent,count($a)));
        	        return merge($b,$c,$a);
        	}else{return $a;}
	}
 
	function merge($b,$c,$a){
        	$i=$j=$k=0;
       	 	$p=count($b);
		$q=count($c);
       		 $a=array();
       		 while($i<$p && $j<$q){
        	        if($b[$i][0]<=$c[$j][0]){
        	                $a[$k]=$b[$i];
        	                $i++;
        	        }else{
        	                $a[$k]=$c[$j];
       	                 $j++;
	                }
	                $k++;
	        }
	        if($i==$p){
	                $x = slice_array($c,$j,$q);
	        }else{
	                $x = slice_array($b,$i,$p);
	        }
	        return merge_array($a,$x);
	}

      ?>
	</select>
	<h4> Group By: </h4>
	<input type = "radio" name = "group" value="seq" <?php echo (($sequence == true) ? "checked" : ""); ?>>Sequence</input>
	<input type = "radio" name = "group" value="dataType" <?php echo (($datatype == true) ? "checked" : ""); ?>>Data Type</input>
	<h4> Sort By: </h4>
	<?php
		if($email_timeBOX == "" && $sequenceBOX =="")
			$timestBOX = "checked";
	?>
	<input type = "radio" name="time" value="timest" <?php echo $timestBOX; ?>>Time Stamp</input>
	<input type = "radio" name="time" value="email_time" <?php echo $email_timeBOX; ?>>Time Sent</input>
	<input type = "radio" name="time" value="sequence" <?php echo $sequenceBOX; ?>>Sequence</input>
    	<br>
	<br>
	<h4>Display:</h4>
	<?php 
		if($GPSBOX == false && $CONNBOX == false && $RT_STATEBOX == false && $RT_PATHBOX == FALSE && $BASESTATIONBOX == false)
			$default = "checked";
		else
			$default = "";
	?>
	<input type = "checkbox" name= "type0" value="GPS" <?php echo (($GPSBOX == true) ? "checked" : $default); ?>>GPS</input>
	<input type = "checkbox" name= "type1" value="CONN" <?php echo (($CONNBOX== true) ? "checked" : $default); ?>>Connections</input>
	<input type = "checkbox" name= "type2" value="RT_STATE" <?php echo (($RT_STATEBOX == true) ? "checked" : $default); ?>>Runtime State</input>
	<input type = "checkbox" name= "type3" value="RT_PATH" <?php echo (($RT_PATHBOX == true) ? "checked" : $default); ?>>Runtime Path</input>
	<input type = "checkbox" name= "type4" value="BASESTATION" <?php echo (($BASESTATIONBOX == true) ? "checked" : $default); ?>>Base Station</input>
	<br>
	<br>
    <input type="submit">
  </form>
</body>
</html>
