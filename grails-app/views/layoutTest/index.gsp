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

    .olMap {
        background-color: black;
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
            <div id="mapCenterEditor"></div>
        </div>
    </div>

    <div id="imageAdjustments">
        <h3>Image Adjustments</h3>

        <div>
            <div id="interpolationEditor"></div>
            <br/>

            <div id="brightnessContrastEditor"></div>
            <br/>

            <div id="sharpenEditor"></div>
            <br/>

            <div id="dynamicRangeAdjustmentEditor"></div>
            <br/>

            <div id="rangeEditor"></div>
            <br/>

            <div id="bandEditor"></div>
        </div>
    </div>
</div>

<script type="text/template" id="interpolationEditor-template">
    <fieldset>
        <legend>Interpolation</legend>
        <select id="interpolation" name="interpolation" onchange="chgInterpolation()">
            <option value="bilinear" selected="selected">bilinear</option>
            <option value="nearest neighbor">nearest neighbor</option>
            <option value="cubic">cubic</option>
            <option value="sinc">sinc</option>
        </select>
    </fieldset>
</script>

<script type="text/template" id="brightnessContrastEditor-template">
    <fieldset>
        <legend></legend>
        Brightness:<div id="brightness-slider"></div><br/>
        Contrast:<div id="contrast-slider"></div><br/>
    </fieldset>
</script>

<script type="text/template" id="sharpenEditor-template">
    <fieldset>
        <legend>Sharpen</legend>
        <select id="sharpen_mode" name="sharpen_mode" onchange="chgSharpenMode()">
            <option value="none" selected="selected">None</option>
            <option value="light">Light</option>
            <option value="heavy">Heavy</option>
        </select>
    </fieldset>
</script>

<script type="text/template" id="dynamicRangeAdjustmentEditor-template">
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
</script>

<script type="text/template" id="rangeEditor-template">
    <fieldset>
        <legend>Region</legend>
        <select id="stretch_mode_region" name="stretch_mode_region" onchange="chgStretchMode()">
            <option value="global">Global</option>
            <option value="viewport" selected="selected">Viewport</option>
        </select>
    </fieldset>
</script>

<script type="text/template" id="bandEditor-template">
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
</script>

<script type="text/template" id="mapCenterEditor-template">
    <fieldset>
        <label for="dd">DD:</label><input type="text" id="dd" name="dd"/><br/>
        <label for="dms">DMS:</label><input type="text" id="dms" name="dms"/><br/>
        <label for="mgrs">MGRS:</label> <input type="text" id="mgrs" name="mgrs"/><br/>
        <br/>
        <button id="applyCenterButton" type="button" onclick="">Apply</button>
        <button id="resetCenterButton" type="button" onclick="">Reset</button>
    </fieldset>
</script>

<script src="http://layout.jquery-dev.net/lib/js/jquery-latest.js"></script>
<script src="http://layout.jquery-dev.net/lib/js/jquery-ui-latest.js"></script>
<script src="http://layout.jquery-dev.net/lib/js/jquery.layout-latest.js"></script>
<script src="http://backbonejs.org/test/vendor/underscore.js"></script>
<script src="http://backbonejs.org/backbone.js"></script>
<script src="http://openlayers.org/dev/OpenLayers.js"></script>
<g:javascript src="mapView.js"/>

<script type="text/javascript">
    $( document ).ready( function ()
    {
        init();
    } );
</script>

<r:layoutResources/>
</body>
</html>