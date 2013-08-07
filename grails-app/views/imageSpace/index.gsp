<%--
  Created by IntelliJ IDEA.
  User: sbortman
  Date: 8/6/13
  Time: 9:05 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Image Space</title>
    <meta name="layout" content="main"/>
    <style type="text/css">
    #map {
        width: 1024px;
        height: 512px;
        border: #255b17 solid thin;
    }
    </style>
</head>

<body>
<div class="nav">
    <ul>
        <li><g:link uri="/" class="home">Home</g:link></li>
    </ul>
</div>

<div class="content">
    <h1>Image Space</h1>

    <div align='center'>
        <div id="map"></div>
    </div>
</div>
<r:external plugin='jquery' dir='js/jquery' file='jquery-1.10.2.min.js'/>
<r:external plugin='openlayers' dir='js' file='OpenLayers.js'/>
<r:script>
    $( document ).ready( function ()
    {
        var map = new OpenLayers.Map( 'map' );
        var controls = [
            new OpenLayers.Control.LayerSwitcher()
        ];
        var layers = [
            new OpenLayers.Layer.WMS(
                    "BMNG",
                    "http://localhost/tilecache/tilecache.py",
                    {layers: 'omar', format: 'image/jpeg'},
                    {buffer: 0, transitionEffect: 'resize'}
            )
        ];

        map.addControls( controls );
        map.addLayers( layers );
        map.zoomToMaxExtent();
    } );
</r:script>
</body>
</html>