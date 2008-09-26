
<html>
<head>
<title>TurtleNet Status Reports
<link rel=StyleSheet HREF="reports.css" TYPE="text/css" />
<script type="text/javascript">

  function changeText(objID, newtext)
  {
   	var el = document.getElementById(objID);

  	el.replaceChild(document.createTextNode(newtext), el.firstChild);

  }

  function showDiv(objectID, textID)
  {
  	var theElementStyle = document.getElementById(objectID);

  	if(theElementStyle.style.display == "none")
  	{
  		theElementStyle.style.display = "block";
  		changeText(textID, "Hide");
  	}
  	else
  	{
  		theElementStyle.style.display = "none";
  		changeText(textID, "Show");
  	}
  }

</script>
</head>
<body>
<h1>TurtleNet Status</h1>

<h3>Updated: <?php  echo file_get_contents("lastgen.txt"); ?></h3>

<?php

$dir = ".";
$dirs = scandir($dir);
$count = 0;

foreach ($dirs as $d)
{
	if (is_dir($d) && $d != '..' && $d != '.')
	{
		$files = scandir($d);
		echo "<h3>$d(<a id='a$d' href=\"#\" onClick=\"showDiv('div$d','a$d');return false;\">Hide</a>)</h3>";
		echo "<div id=\"div$d\" style='display: block;' >";
		echo "<table>";
		$idx = 0;
		foreach ($files as $file)
		{
			if (strcmp(strstr($file,".jpg"), ".jpg") == 0)
			{
				$count++;
				if ($idx % 2 == 0)
				{
					echo "<tr>";
				}
				echo "<td width='2px' class='justbottom'>";
				echo "<p><b>Figure $count: </b>";
				$caption = file_get_contents($d."/".$file.".txt");

				if ($caption != FALSE)
				{
					echo "<b>$caption<b><br>";
				}
				echo "<a href=\"./$d/$file\" target='_blank'>";
				echo "<img src=\"./$d/$file\" width=400px/></a><br>";
				echo "</p>";

				echo "</td>";
				if ($idx % 2 != 0)
				{
					echo "</tr>";
				}
				$idx = ($idx + 1)%2;
			}
		}
		echo "</td></tr></table>";
		echo "</div><br>";
	}
}

?>
</body>
</html>
