<%--
  Created by IntelliJ IDEA.
  User: sbortman
  Date: 8/6/13
  Time: 10:28 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Layout Test</title>
    <link rel="stylesheet" type="text/css" href="http://layout.jquery-dev.net/lib/css/layout-default-latest.css"/>
    <link rel="stylesheet" type="text/css" href="http://layout.jquery-dev.net/lib/css/themes/base/jquery.ui.all.css"/>

    <r:layoutResources/>
    <style type="text/css">
    body {
        display: none;
    }
    </style>
</head>

<body>

<div class="ui-layout-center">
    <div id="map"></div>
</div>

<div class="ui-layout-north"></div>

<div class="ui-layout-south">
    <div id="coords" style="height: 1.5em;"></div>
</div>

<div class="ui-layout-east"></div>

<div class="ui-layout-west">
    <div id="mapCenter">
        <h3>Map Center</h3>

        <div>
            <fieldset>
                <label for="dd">DD:</label><input type="text" id="dd" name="dd"/><br/>
                <label for="dms">DMS:</label><input type="text" id="dms" name="dms"/><br/>
                <label for="mgrs">MGRS:</label> <input type="text" id="mgrs" name="mgrs"/><br/>
                <br/>
                <button id="applyCenterButton" type="button" onclick="">Apply</button>
                <button id="resetCenterButton" type="button" onclick="">Reset</button>
            </fieldset>
        </div>
    </div>

    <div id="imageAdjustments">
        <h3>Image Adjustments</h3>

        <div>
            <fieldset>
                <legend>Interpolation</legend>
                <select id="interpolation" name="interpolation" onchange="chgInterpolation()">
                    <option value="bilinear" selected="selected">bilinear</option>
                    <option value="nearest neighbor">nearest neighbor</option>
                    <option value="cubic">cubic</option>
                    <option value="sinc">sinc</option>
                </select>
            </fieldset>
            <br/>
            <fieldset>
                <legend></legend>
                Brightness:<div id="brightness-slider"></div><br/>
                Contrast:<div id="contrast-slider"></div><br/>
            </fieldset>
            <br/>
            <fieldset>
                <legend>Sharpen</legend>
                <select id="sharpen_mode" name="sharpen_mode" onchange="chgSharpenMode()">
                    <option value="none" selected="selected">None</option>
                    <option value="light">Light</option>
                    <option value="heavy">Heavy</option>
                </select>
            </fieldset>
            <br/>
            <fieldset>
                <legend>Dynamic Range Adjustment</legend>
                <select id="stretch_mode" name="stretch_mode" onchange="chgStretchMode()">
                    <option value="linear_auto_min_max" selected="selected">Automatic</option>
                    <option value="linear_1std_from_mean">1st Std</option>
                    <option value="linear_2std_from_mean">2nd Std</option>
                    <option value="linear_3std_from_mean">3rd Std</option>
                    <option value="none">No Adjustment</option>
                </select>
            </fieldset>
            <br/>
            <fieldset>
                <legend>Region</legend>
                <select id="stretch_mode_region" name="stretch_mode_region" onchange="chgStretchMode()">
                    <option value="global">Global</option>
                    <option value="viewport" selected="selected">Viewport</option>
                </select>
            </fieldset>
            <br/>
            <fieldset>
                <legend>Bands</legend>
                <input type="hidden" id="bands" name="bands" value="default"/>
                <select name="colorModel" id="colorModel" onchange="bandsChanged()">
                    <option value="Default">Default</option>
                    <option value="Color">Color</option>
                    <option value="Gray">Gray</option>
                </select>
                <table id="displayGunTable">
                    <tr id="redRow">
                        <td style="text-align:right;"><label id='band0'>Red</label></td>
                        <td style="text-align:left;">
                            <select name="redBand" onchange="bandsChanged()" id="redBand">
                                <option value="0" selected="selected">0</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                            </select>
                        </td>
                    </tr>
                    <tr id="greenRow">
                        <td style="text-align:right;">Green</td>
                        <td style="text-align:left;">
                            <select name="greenBand" onchange="bandsChanged()" id="greenBand">
                                <option value="0">0</option>
                                <option value="1" selected="selected">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                            </select>
                        </td>
                    </tr>
                    <tr id="blueRow">
                        <td style="text-align:right;">Blue</td>
                        <td style="text-align:left;">
                            <select name="blueBand" onchange="bandsChanged()" id="blueBand">
                                <option value="0">0</option>
                                <option value="1">1</option>
                                <option value="2" selected="selected">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                            </select>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
    </div>
</div>

<script src="http://layout.jquery-dev.net/lib/js/jquery-latest.js"></script>
<script src="http://layout.jquery-dev.net/lib/js/jquery-ui-latest.js"></script>
<script src="http://layout.jquery-dev.net/lib/js/jquery.layout-latest.js"></script>
<script src="http://openlayers.org/dev/OpenLayers.js"></script>

<script type="text/javascript">
    $( document ).ready( function ()
    {

        $( "#mapCenter" ).accordion( {
            heightStyle: "content",
            collapsible: true
        } );

        $( "#imageAdjustments" ).accordion( {
            heightStyle: "content",
            collapsible: true
        } );

        $( "#brightness-slider" ).slider( {
            range: "max",
            min: -1,
            max: 1,
            step: 0.1,
            value: 0//,
//            slide: function( event, ui ) {
//                $( "#amount" ).val( ui.value );
//            }
        } );

        $( "#contrast-slider" ).slider( {
            range: "max",
            min: 0,
            max: 2,
            step: 0.1,
            value: 1//,
//            slide: function( event, ui ) {
//                $( "#amount" ).val( ui.value );
//            }
        } );
        $( 'body' ).fadeIn( 0 );
        $( 'body' ).layout( {
            center: {
                onresize: function ()
                {
                    map.updateSize();
                }
            },
            west: {
                size: 350
            },
            triggerEventsOnLoad: true
        } );

        var map = new OpenLayers.Map( 'map' );

        var layers = [
            /*
             new OpenLayers.Layer.WMS(
             'BMNG',
             'http://omar.ngaiost.org/cgi-bin/mapserv.sh',
             {map: '/data/omar/bmng.map', layers: 'Reference', format: 'image/jpeg'},
             {buffer: 0, transitionEffect: 'resize'}
             ),
             */
            new OpenLayers.Layer.WMS(
                    'Image',
                    'http://omar.ngaiost.org/omar/ogc/wms',
                    {layers: '621', format: 'image/jpeg'},
                    {isBaseLayer: true, singleTile: true, ratio: 1,
                        maxExtent: new OpenLayers.Bounds(
                                68.7481752399252, 33.6250780571465, 68.9557287627736, 33.7832061212506
                        )
                    }
            )
        ];
        map.addLayers( layers );
        var controls = [
            new OpenLayers.Control.LayerSwitcher(),
            new OpenLayers.Control.MousePosition( {

                prefix: '<a target="_blank" ' +
                        'href="http://spatialreference.org/ref/epsg/4326/">' +
                        'EPSG:4326</a> coordinates: ',
//                separator: ' | ',
//                numDigits: 2,

                div: OpenLayers.Util.getElement( "coords" ),
                emptyString: 'Mouse is not over map.'
            } )
        ];
        map.addControls( controls );

        if ( !map.getCenter() )
        {
            map.zoomToMaxExtent();
        }

        /*
         map.events.register( "mousemove", map, function ( e )
         {
         var position = this.events.getMousePosition( e );
         OpenLayers.Util.getElement( "coords" ).innerHTML = position;
         } );
         */
    } );

    function chgInterpolation()
    {
        var interpolation = $( "#interpolation" ).val();
        var obj = {interpolation: interpolation};

        //alert(obj.interpolation);

        console.log( obj );

        //wcsParams.setProperties(obj);

//        for ( var layer in rasterLayers )
//        {
//            rasterLayers[layer].mergeNewParams( obj );
//        }
    }


    function chgStretchMode()
    {
        var stretch_mode = $( "#stretch_mode" ).val();
        var stretch_mode_region = $( "#stretch_mode_region" ).val();
        var obj = {stretch_mode: stretch_mode, stretch_mode_region: stretch_mode_region};

        console.log( obj );

//        wcsParams.setProperties(obj);
//        for(var layer in rasterLayers)
//        {
//            rasterLayers[layer].mergeNewParams(obj);
//        }
    }

    function chgSharpenMode()
    {
        var sharpen_mode = $( "#sharpen_mode" ).val();
        var obj = {sharpen_mode: sharpen_mode};

        console.log( obj );

//        wcsParams.setProperties(obj);
//
//        for(var layer in rasterLayers)
//        {
//            rasterLayers[layer].mergeNewParams(obj);
//        }
    }

    function bandsChanged()
    {
        var colorModel = $( '#colorModel' ).val();

        if ( colorModel === 'Default' )
        {
            $( '#displayGunTable' ).css( 'display', 'none' );

            $( '#redRow' ).css( 'display', 'none' );
            $( '#greenRow' ).css( 'display', 'none' );
            $( '#blueRow' ).css( 'display', 'none' );

            $( '#bands' ).val( 'default' );
        }
        else if ( colorModel === 'Gray' )
        {
            $( '#displayGunTable' ).css( 'display', 'block' );

            $( '#redRow' ).css( 'display', 'block' );
            $( '#greenRow' ).css( 'display', 'none' );
            $( '#blueRow' ).css( 'display', 'none' );

            $( '#band0' ).html( "Band" );

            $( '#bands' ).val( $( '#redBand' ).val() );
        }
        else if ( colorModel === 'Color' )
        {
            $( '#displayGunTable' ).css( 'display', 'block' );

            $( '#redRow' ).css( 'display', 'block' );
            $( '#greenRow' ).css( 'display', 'block' );
            $( '#blueRow' ).css( 'display', 'block' );

            $( '#band0' ).html( "Red" );

            $( '#bands' ).val( [
                $( '#redBand' ).val(),
                $( '#greenBand' ).val(),
                $( '#blueBand' ).val()
            ].join( ',' ) );
        }

        var obj = {bands: $( '#bands' ).val()};

        console.log( obj );

        //changeBandsOpts();
    }

    $( '#displayGunTable' ).css( 'display', 'none' );
    $( '#redRow' ).css( 'display', 'none' );
    $( '#greenRow' ).css( 'display', 'none' );
    $( '#blueRow' ).css( 'display', 'none' );


</script>

<r:layoutResources/>
</body>
</html>