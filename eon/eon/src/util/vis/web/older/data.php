<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>Google Maps</title>

    <style type="text/css">

	v\:* { behavior:url(#default#VML); }

	body { font-family: Verdana, Sans-serif; }

	h3 { margin-left: 8px; }
	
	#map { height: 600px;
		width: 1000px;
		border: 1px solid gray;
		margin-top: 8px;
		margin-left: 8px;
		overflow: hidden;
	}
	.button { display: block;
		width: 180px;
		border: 1px Solid #565;
		background-color:#F5F5F5; 
		margin: 10px;
		padding: 3px;
		text-decoration: none;
		text-align:center;
		font-size:smaller;
	}
	.button:hover {
		background-color: white;
	}
	
	#descr { position:absolute;
		top:45px;
		left: 580px;
		width: 250px;
	}

	.infowindow { font-size: smaller;
		text-align: left;
	}

    </style>

    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA0FPGFTHmYrGpfPD0c89zhRQ_Wg-z1Xt2E7cbCW66fNNBGSvQCBTa-oliwVrMDg5ddB42JnQmvig7Pw" type="text/javascript"></script>
  </head>

  <body onload="buildMap()" onunload="GUnload()">

  <h3>Show Deployments:</h3>
  <!-- Get unique deployments from database, associate nodes with appropriate deployment -->
    <?php
	$link = mysql_connect("diesel.cs.umass.edu", "turtle", "hardshell") or die("Could not connect: " . mysql_error());
	mysql_selectdb("snapper_turtles",$link) or die ("Can\'t use dbmapserver : " . mysql_error());

	$result = mysql_query("SELECT DISTINCT depID FROM DEPLOYMENT;",$link);
	if (!$result)
	{
		echo "no results ";
	}

        $count=0;
	$taken=array();
	
	while($row = mysql_fetch_array($result)) 
	{
		
		if(!(in_array($row['depID'],$taken)))
		{
			echo "<input type=\"checkbox\" name=\"".$row['depID']."\" checked>".$row['depID']."\n";
			$taken[$count++] = $row['depID'];
		}
			
	}
	echo "<h3>Animated Deployment:</h3>";
	foreach($taken as $num)
	{
		echo "<input type=\"radio\" name=\"mover\" value=\"".$num."\">".$num;
	}
	echo "<script type = \"text/javascript\">";
	echo "var markerGroups = {";
	$count = 0;
	foreach($taken as $num)
	{
		if($count == 0){
			echo "";
			$count++;
		}
		else
			echo ",";
		echo "\"".$num."\"";
	}
	echo "};";
	echo "</script>";
    ?>   
    <div id="map"></div>
    <script type="text/javascript">
    //<![CDATA[
    
    if (GBrowserIsCompatible())
    { 
      function createMarker(point,Icon,html) {
        var marker = new GMarker(point,Icon);
        GEvent.addListener(marker, "click", function() {
          marker.openInfoWindowHtml(html);
        });
        return marker;
      }
      
      function addIcon(icon) { 
 	icon.shadow = "http://www.google.com/mapfiles/shadow50.png";
 	icon.iconSize = new GSize(32, 32);
 	icon.shadowSize = new GSize(37, 34);
 	icon.iconAnchor = new GPoint(15, 34);
 	icon.infoWindowAnchor = new GPoint(19, 2);
 	icon.infoShadowAnchor = new GPoint(18, 25);
      }

      var marker = [];8675309


      var points = [];
      var count = 0;

      var map = new GMap2(document.getElementById("map"));
      map.addControl(new GLargeMapControl());
      map.addControl(new GMapTypeControl());
      map.setCenter(new GLatLng(42.3949,-72.5312),10, G_HYBRID_MAP);
      
      var icon = new GIcon();
      icon.image = "http://www.google.com/mapfiles/dd-start.png";
      addIcon(icon);

      // Set up markers
      <?php
	$link = mysql_connect("diesel.cs.umass.edu", "turtle", "hardshell") or die("Could not connect: " . mysql_error());
	mysql_selectdb("snapper_turtles",$link) or die ("Can\'t use dbmapserver : " . mysql_error());

	$result = mysql_query("SELECT * FROM GPS;",$link);
	if (!$result)
	{
		echo "no results ";
	}
	$count = 0;
	while($row = mysql_fetch_array($result))
	{
		if(($row['lat_dec'] != 0 && $row['lat_dec'] < 180) && ($row['lon_dec'] != 0 && $row['lon_dec'] < 180))
		{
			echo "\n\tvar lat =" . $row['lat_dec'] . ";\n\t";
			echo "var lon =" . -($row['lon_dec']) . ";\n\t";
			echo "points[".$count."] = new GLatLng(lat, lon);\n\t";
			echo "marker[".$count."] = createMarker(points[".$count."],icon, 'Node: ". $row['datasrc'] ."\\nAt: ".$row['time_sent']."')\n\t";
			echo "map.addOverlay(marker[".$count."]);\n\t";
			$count++;
		}
		
	}

       mysql_close($link);
	?>

	//add polyline
	var poly= new GPolyline(points, "#003355", 3, .5);
  	map.addOverlay(poly);
	//start the fun stuff
	path =setTimeout("mover()", 3600);

	//move through the route
	function mover() 
	{
		count++;
 		if(count < points.length) 
		{
  			map.panTo(points[count]);
  			var delay = 3400;
  			if((count+1) != points.length)
   				var dist = points[count].distanceFrom(points[count+1]);

  			// Adjust delay
  			if( dist < 10000 ) 
			{
   				delay = 2000;
  			}
  			if( dist > 80000 ) 
			{
   				delay = 4200;
  			}
  		path = setTimeout("mover()", delay);
 		}
  		else {
  			clearTimeout(route);
  			count = 0;
  			route = null;
 		}
	}

	//toggle deployments on and off
	function toggleGroup(type) {
      		for (var i = 0; i < markerGroups[type].length; i++) {
        		var marker = markerGroups[type][i];
        		if (marker.isHidden()) 
			{
		
          			marker.show();
        		} 
			else 
			{
          		marker.hide();
        		}
      		}			 
    	}
    }
    
    else {
      alert("Sorry, Google Maps is not compatible with this browser");
    }

    
    //]]>
    </script>
    
  </body>

</html>


