
var apiKeyBing = "ApTJzdkyN1DdFKkRAE6QIDtzihNaf6IWJsT-nQ_2eMoO4PN__0Tzhl2-WgJtXFSp";
var map = null;
var controls = new Array();

function drawmap() {
	var EPSG4326 = new OpenLayers.Projection("EPSG:4326"); // Transform from WGS 1984
	var EPSG3857 = new OpenLayers.Projection("EPSG:3857"); // to Spherical Mercator Projection

	var position = getUrlVars()["position"];
	var sceneBoundingBox = getUrlVars()["boundingbox"];
	var zoom = getUrlVars()["zoom"];

	if (position != null)
		position = OpenLayers.LonLat.fromString(position).transform(EPSG4326, EPSG3857);

	if (zoom == null)
		zoom = 10;

	OpenLayers.Lang.setCode('de');

	// navigation control
	control_navigation = new OpenLayers.Control.Navigation({
			zoomWheelEnabled: true,
			handleRightClicks: true
		});
	controls["mapModePan"] = control_navigation;

	map = new OpenLayers.Map('map', {
			//restrictedExtent: extent900913,
			projection: EPSG3857,
			displayProjection: EPSG4326,
			controls: [
				control_navigation,
				new OpenLayers.Control.PinchZoom(),
				new OpenLayers.Control.DragPan(),
				new OpenLayers.Control.KeyboardDefaults({
					defaultKeyPress: OnKeyPress
				}),
				new OpenLayers.Control.LayerSwitcher(),
				new OpenLayers.Control.PanZoomBar({
					zoomWorldIcon: true
				}),
				new OpenLayers.Control.MousePosition({
					element: mousePos,
					prefix: "Longitude: ",
					separator: ", Latitude: ",
					emptyString: ""
				}),
				new OpenLayers.Control.OverviewMap()],
			//allOverlays: true,
			//maxExtent: new OpenLayers.Bounds([-180,-90,180,90]),
			numZoomLevels: 18,
			//maxResolution: 156543,
			units: 'm'
		});

	//var panel = new OpenLayers.Control.NavToolbar();
	//map.addControl(panel);

	control_zoomBox = new OpenLayers.Control.ZoomBox({
			title: "ZoomBox",
			alwaysZoom: true
		});
	map.addControl(control_zoomBox);
	controls["mapModeZoom"] = control_zoomBox;

	//map.zoomToExtent(extent);

	var layer_osm = new OpenLayers.Layer.OSM("OpenStreetMap");
	var layer_gmap_physical = new OpenLayers.Layer.Google("Google Physical", {
			type: google.maps.MapTypeId.TERRAIN
		});
	var layer_gmap_street = new OpenLayers.Layer.Google("Google Streets", {
			numZoomLevels: 20
		});
	var layer_gmap_hybrid = new OpenLayers.Layer.Google("Google Hybrid", {
			type: google.maps.MapTypeId.HYBRID,
			numZoomLevels: 20
		});
	var layer_gmap_satellite = new OpenLayers.Layer.Google("Google Satellite", {
			type: google.maps.MapTypeId.SATELLITE,
			numZoomLevels: 22
		});
	var layer_bing_road = new OpenLayers.Layer.Bing({
			key: apiKeyBing,
			type: "Road"
		});
	var layer_bing_aerial = new OpenLayers.Layer.Bing({
			key: apiKeyBing,
			type: "Aerial"
		});
	var layer_bing_hybrid = new OpenLayers.Layer.Bing({
			key: apiKeyBing,
			type: "AerialWithLabels",
			name: "Bing Aerial With Labels"
		});

	map.addLayers([layer_osm, layer_gmap_physical, layer_gmap_street, layer_gmap_hybrid, layer_gmap_satellite, layer_bing_road, layer_bing_aerial, layer_bing_hybrid]);

	if (position == null)
		map.zoomToMaxExtent();
	else
		map.setCenter(position, zoom);

	//add a box to the overlay scene
	if (sceneBoundingBox != null) {
		var layer_scene = new OpenLayers.Layer.Vector("Scene");
		bounds = OpenLayers.Bounds.fromString(sceneBoundingBox, false);
		bounds.transform(EPSG4326, EPSG3857);
		box = new OpenLayers.Feature.Vector(bounds.toGeometry());
		layer_scene.addFeatures(box);
		map.addLayer(layer_scene);
	}

	// overview erzeugen
	layer_ov = new OpenLayers.Layer.OSM("OpenStreetMap");
	var options = {
		layers: [layer_ov]
	};
	layer_ov.projection = EPSG3857;
	map.addControl(new OpenLayers.Control.OverviewMap(options));

	// layer for map rectangle
	var layer_mapRange = new OpenLayers.Layer.Vector("Map Range");
	layer_mapRange.events.register("featureadded", layer_mapRange, OnLayer_mapRange_FeatureAdded);
	layer_mapRange.events.register("keypress", layer_mapRange, OnLayer_mapRange_KeyPress);

	map.addLayer(layer_mapRange);

	drawControl = new OpenLayers.Control.DrawFeature(layer_mapRange, OpenLayers.Handler.RegularPolygon, {
			handlerOptions: {
				sides: 4,
				irregular: true
			}
		});
	map.addControl(drawControl);
	controls["drawMapBox"] = drawControl;

	// zoom handler
	map.events.register("zoomend", map, OnMapZoomChanged);
	map.events.register("rightclick", map, OnMapRightClick);

	// create the TransformFeature control, using the renderIntent
	// from above
	transformControl = new OpenLayers.Control.TransformFeature(layer_mapRange, {
			renderIntent: "transform"
		});
	map.addControl(transformControl);
	controls["transformMapBox"] = transformControl;

	// context for appropriate scale/resize cursors
	var cursors = ["sw-resize", "s-resize", "se-resize", "e-resize", "ne-resize", "n-resize", "nw-resize", "w-resize"];
	var context = {
		getCursor: function (feature) {
			var i = OpenLayers.Util.indexOf(transformControl.handles, feature);
			var cursor = "inherit";
			if (i !== -1) {
				i = (i + 8 + Math.round(transformControl.rotation / 90) * 2) % 8;
				cursor = cursors[i];
			}
			return cursor;
		}
	};

	// a nice style for the transformation box
	var style = new OpenLayers.Style({
			cursor: "${getCursor}",
			pointRadius: 5,
			fillColor: "white",
			fillOpacity: 1,
			strokeColor: "black"
		}, {
			context: context
		});

	layer_mapRange.styleMap = new OpenLayers.StyleMap({
			"transform": style
		});
	
	OnMapZoomChanged();
	
}

function getBoundingBox() {
	var bounds = null;

	var layers = map.getLayersByName("Map Range");

	if (layers.length > 0 && layers[0].features.length > 0) {
		bounds = layers[0].getDataExtent();
	} else {
		bounds = map.calculateBounds();
	}

	bounds.transform(map.getProjectionObject(), new OpenLayers.Projection("EPSG:4326"));

	var boundingBox = bounds.left.toFixed(6) + ", " + bounds.bottom.toFixed(6) + ", " + bounds.right.toFixed(6) + ", " + bounds.top.toFixed(6);

	return boundingBox;
}

function getZoom() {
	return map.getZoom();
}


function OnMapZoomChanged() {
	zl = document.getElementById("zoomLevel").innerHTML = "Zoom Level: " + map.getZoom();
}


function OnLayer_mapRange_FeatureAdded(event) {
	if (event.feature.state == "Insert") {
		var drawControl = controls["drawMapBox"];
		var transformControl = controls["transformMapBox"];

		transformControl.setFeature(event.feature);

		drawControl.deactivate();
		transformControl.activate();
	}
}

function OnLayer_mapRange_KeyPress(event) {
	console.log("keypress");
}

function toggleControl(element) {
	for (key in controls) {
		var control = controls[key];
		if (element.value == key && element.checked) {
			control.activate();
		} else {
			control.deactivate();
		}
	}

	if (element.value == "drawMapBox") {
		var layers = map.getLayersByName("Map Range");

		if (layers.length > 0 && layers[0].features.length > 0) {
			var drawControl = controls["drawMapBox"];
			var transformControl = controls["transformMapBox"];
			drawControl.deactivate();
			transformControl.activate();
		}
	}
}

function OnMapRightClick(event) {
	console.log("rightclick");
}

function OnKeyPress(event) {
	var keyCode = getKeyCode(event);

	if (keyCode == 8 || keyCode == 46) {
		var drawControl = controls["drawMapBox"];
		var transformControl = controls["transformMapBox"];
		drawControl.activate();
		transformControl.deactivate();

		var layers = map.getLayersByName("Map Range");

		if (layers.length > 0 && layers[0].features.length > 0) {
			layers[0].removeAllFeatures();
		}
	}
}

function getKeyCode(event) {
	if (event.which == null) {
		return event.keyCode; // IE
	} else if (event.which != null && event.charCode != null) {
		return event.which; // the rest
	} else {
		return null;
	}
}

function getUrlVars() {
	var vars = [],
	hash;
	var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
	for (var i = 0; i < hashes.length; i++) {
		hash = hashes[i].split('=');
		vars.push(hash[0]);
		vars[hash[0]] = hash[1];
	}

	return vars;
}
