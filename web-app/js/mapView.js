var ImageAdjustmentsModel = Backbone.Model.extend( {
    defaults: {
        interpolation: 'bilinear',
        brightness: 0,
        contrast: 1,
        sharpen_mode: 'none',
        stretch_mode: 'linear_auto_min_max',
        stretch_mode_region: 'viewport',
        bands: 'default'
    }
} );

var InterpolationEditorView = Backbone.View.extend( {
    el: '#interpolationEditor',
    initialize: function ( params )
    {
        this.render();
    },
    render: function ()
    {
        $( this.el ).html( _.template( $( '#interpolationEditor-template' ).html() ) );
    }
} );

var BrightnessContrastEditorView = Backbone.View.extend( {
    el: '#brightnessContrastEditor',
    initialize: function ( params )
    {
        this.render();
    },
    render: function ()
    {
        $( this.el ).html( _.template( $( '#brightnessContrastEditor-template' ).html() ) );

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
    }
} );

var SharpenEditorView = Backbone.View.extend( {
    el: '#sharpenEditor',
    initialize: function ( params )
    {
        this.render();
    },
    render: function ()
    {
        $( this.el ).html( _.template( $( '#sharpenEditor-template' ).html() ) );
    }
} );

var DynamicRangeAdjustmentEditorView = Backbone.View.extend( {
    el: '#dynamicRangeAdjustmentEditor',
    initialize: function ( params )
    {
        this.render();
    },
    render: function ()
    {
        $( this.el ).html( _.template( $( '#dynamicRangeAdjustmentEditor-template' ).html() ) );
    }
} );

var RangeEditorView = Backbone.View.extend( {
    el: '#rangeEditor',
    initialize: function ( params )
    {
        this.render();
    },
    render: function ()
    {
        $( this.el ).html( _.template( $( '#rangeEditor-template' ).html() ) );
    }
} );

var BandEditorView = Backbone.View.extend( {
    el: '#bandEditor',
    initialize: function ( params )
    {
        this.render();
    },
    render: function ()
    {
        $( this.el ).html( _.template( $( '#bandEditor-template' ).html() ) );
    }
} );

var MapCenterEditorView = Backbone.View.extend( {
    el: '#mapCenterEditor',
    initialize: function ( params )
    {
        this.render();
    },
    render: function ()
    {
        $( this.el ).html( _.template( $( '#mapCenterEditor-template' ).html() ) );
    }
} );


function init()
{
    var imageAdjustmentModel = new ImageAdjustmentsModel();
    var interpolationEditorView = new InterpolationEditorView();
    var brightnessContrastEditorView = new BrightnessContrastEditorView();
    var sharpenEditorView = new SharpenEditorView();
    var dynamicRangeAdjustmentEditorView = new DynamicRangeAdjustmentEditorView();
    var rangeEditorView = new RangeEditorView();
    var bandEditorView = new BandEditorView();
    var mapCenterEditorView = new MapCenterEditorView();


    $( "#mapCenter" ).accordion( {
        heightStyle: "content",
        collapsible: true
    } );

    $( "#imageAdjustments" ).accordion( {
        heightStyle: "content",
        collapsible: true
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

    $( '#displayGunTable' ).css( 'display', 'none' );
    $( '#redRow' ).css( 'display', 'none' );
    $( '#greenRow' ).css( 'display', 'none' );
    $( '#blueRow' ).css( 'display', 'none' );

}

function chgInterpolation()
{
    var interpolation = $( "#interpolation" ).val();
    var obj = {interpolation: interpolation};

    mergeNewParams( obj );
}


function chgStretchMode()
{
    var stretch_mode = $( "#stretch_mode" ).val();
    var stretch_mode_region = $( "#stretch_mode_region" ).val();
    var obj = {stretch_mode: stretch_mode, stretch_mode_region: stretch_mode_region};

    mergeNewParams( obj );
}

function chgSharpenMode()
{
    var sharpen_mode = $( "#sharpen_mode" ).val();
    var obj = {sharpen_mode: sharpen_mode};

    mergeNewParams( obj );
}

function chgBandsOpts()
{
    var bands = $( "#bands" ).val();
    var obj = {bands: bands};

    mergeNewParams( obj );
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

    chgBandsOpts();
}

function mergeNewParams( obj )
{
    console.log( obj );
}




