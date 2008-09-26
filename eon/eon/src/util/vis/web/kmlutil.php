<?php

function comment($comstr)
{
	$op = "<!--\n";
	$op .= $comstr;
	$op .= "\n-->\n";
	//return $op;
	echo $op;
}

function TimeStamp($stamp)
{
    $op = "\t<TimeStamp>\n";
    list($date, $time) = split(' ',$stamp);
    $op .= "\t <when>".$date."T".$time."Z"."</when>\n";
    $op .= "\t</TimeStamp>\n";
    
    return $op;
}

//Calculate points on circle 
function CirclePoints($lat_one,$long_one,$radius,$i){
    $lat1 = deg2rad ($lat_one);
    $long1 = deg2rad ($long_one);
    $d = $radius;
    $d_rad = $d / 6378137;

    $radial = deg2rad ($i);
    $lat_rad = asin (sin ($lat1) * cos ($d_rad) +
        cos ($lat1) * sin ($d_rad) * cos ($radial));
    $dlon_rad = atan2 (sin ($radial) * sin ($d_rad) * cos ($lat1),
        cos ($d_rad) - sin ($lat1) * sin ($lat_rad));
    $lon_rad = fmod (($long1 + $dlon_rad + M_PI), 2 * M_PI) - M_PI;

    return rad2deg ($lon_rad).",".rad2deg ($lat_rad);
}


//This function adds dilution circles to points and labels them
function CircleDraw ($lat_one, $long_one, $radius, $datasrc, $time)
{
    
    $hex = 0xC249255;
    $color = $datasrc * $hex;
    $out = "<name>Data Visualization</name>\n";
    $out .= "<visibility>1</visibility>\n";
    $out.= "<Placemark>\n";
    $out.= "<name>Dilution for node ".$datasrc." at ".$time."</name>\n";
    $out.= "<visibility>1</visibility>\n";
    $out.= "<Style>\n";
    $out.= "<geomColor>".dechex ($color)."</geomColor>\n";
    $out.= "<geomScale>1</geomScale></Style>\n";
    $out.= "<LineString>\n";
    $out.= "<coordinates>\n";
    // loop through the array and write path linestrings
    for ($i = 0; $i <= 360; $i++)
    {
        $out.= CirclePoints($lat_one,$long_one,$radius,$i).",0 ";
    }
    $out.= "</coordinates>\n";
    $out.= "</LineString>\n";
    $out.= "</Placemark>\n";

    return $out;
}

//draw Connections to Base Station
function drawConn ($lat, $long, $radius, $datasrc, $baseID, $time)
{
    for (i$ = 0; $i <= 9; $i++)
    {
	$out = "<Placemark>\n";
	$out .= TimeStamp($time);
	$out .= "\t<name>Connection between ".$baseID." and ".$datasrc."</name>\n";
	$out .= "\t<styleUrl>#con".$datasrc."</styleUrl>\n";
	$out .= "\t<Point>\n\t <coordinates>".CirclePoints($lat,$long,$i*40)."</coordinates>\n\t</Point>\n";
	$out .= "</Placemark>\n";
    }
    
    return $out;
}  
    
//draw trails for each node
function DrawPoly ($points, $node)
{
    $out = "<Placemark>\n";
    $out.= "<name>Path for node ".$node."</name>";
    $out.= "<visibility>1</visibility>\n";
    $out.= '<Style>\n';
    $out.= '<geomColor>000000</geomColor>\n';
    $out.= '</Style>\n';
    $out.= '<LineString>\n';
    $out.= '<coordinates>\n';
    $out.= $points;
    $out.= '</coordinates>\n';
    $out.= '</LineString>\n';
    $out.= '</Placemark>\n';

    return $out;
}

/*function icon_style($name, $color)
{
	$output .= "  <Style id= \"$name\" >\n";
	$output .= "\t<IconStyle>\n";
	$output .= "\t <Icon>\n";
	//$output .= "<href>$visfulldir/markers/baloon".$num.".png</href>\n";
	$output .= "\t </Icon>\n";
	$output .= "\t</IconStyle>\n";
	$output .= "  </Style>";
}*/

function icon_style_img($name, $url)
{
	//var op;
	$op = "  <Style id= \"$name\" >\n";
	$op .= "\t<IconStyle>\n";
	$op .= "\t <Icon>\n";
	$op .= "<href>$url</href>\n";
	$op .= "\t </Icon>\n";
	$op .= "\t</IconStyle>\n";
	$op .= "  </Style>";

	return $op;
}


function date_valid ($day, $month, $year)
{
    if ($month < 1 || $month > 12)
    return "Month out of range";
    if ($day < 1)
    return "Date out of range";
    if ($month == 09 || $month == 04 || $month == 06 || $month == 11)
    {
        if ($day > 30)
        return "Date out of range";
    }
    elseif ($month == 02)
    {
        //check for leap years
        if (($year % 4 == 0) && (($year % 100 <> 0) || ($year % 400 == 0)))
        {
            if ($day > 29)
            return "Date out of range";
        }
        elseif ($day > 28) return "Date out of range";
    }
    else
    {
        if ($day > 30)
        return "Date out of range";
        else
        return NULL;
    }

}

?>