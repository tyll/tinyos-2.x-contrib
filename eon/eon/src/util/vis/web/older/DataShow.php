<html>
<head>
   <title>Data Show</title>
   <script src="fetch.js"></script> 
</head>
<!-- <form action="another.php" method="POST" > -->
<body>
   <h3>Deployment:</h3>
   <form name=choice>
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
		echo "<select name=depID onchange=\"changeDep(this.value)\">\n";
		echo "<option></option>\n";
		while($row = mysql_fetch_array($result))
		{
			echo "<option value=\"".$row['depID']."\">".$row['depID']."</option><br>\n";
		}	
		
	}
	mysql_close($link);
      ?>
	</select>
	<h4> Sort By: </h4>
	<input type = "radio" name="time" value="timest">Time Stamp</input>
	<input type = "radio" name="time" value="email_time">Time Sent</input>
	<input type = "radio" name="time" value="sequence">Sequence</input>
    	<br>
	<br>
	<h4>Display:</h4>
	<input type = "checkbox" name= "type0" value="GPS">GPS</input>
	<input type = "checkbox" name= "type1" value="CONN">Connections</input>
	<input type = "checkbox" name= "type2" value="RT_STATE">Runtime State</input>
	<input type = "checkbox" name= "type3" value="RT_PATH">Runtime Path</input>
	<br>
	<br>
    <input type="button" value="GetData" onclick="show()">
    </form>
</body>
</html>
