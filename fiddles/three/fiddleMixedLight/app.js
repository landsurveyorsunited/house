var renderer = null,
    scene = null,
    camera = null,
    root = null,
    group = null,
    sphere = null,
    sphereEnvMapped = null,
    orbitControls = null,
    duration = 20000, // ms
    currentTime = Date.now(),
    directionalLight = null,
    spotLight = null,
    pointLight = null,
    ambientLight = null,
    mapUrl = "resources/images/checker-board.gif";

function animate() {

    var now = Date.now();
    var deltat = now - currentTime;
    currentTime = now;
    var fract = deltat / duration;
    var angle = Math.PI * 2 * fract;

    // Rotate the sphere group about its Y axis
    group.rotation.y += angle;
}
function run() {
    requestAnimationFrame(function () {
        run();
    });

    // Render the scene
    renderer.render(scene, camera);

    // Spin the cube for next frame
    animate();

    // Update the camera controller
    orbitControls.update();
}
function setLightColor(light, r, g, b) {
    r /= 255;
    g /= 255;
    b /= 255;

    light.color.setRGB(r, g, b);
}
function toggleLight(light) {
}
function toggleTexture() {
    textureOn = !textureOn;
    var names = materialName.split("-");
    if (!textureOn) {
        setMaterial(names[0]);
    }
    else {
        setMaterial(names[0] + "-textured");
    }
}
function createScene(canvas) {

    // Create the Three.js renderer and attach it to our canvas
    renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true });

    // Set the viewport size
    renderer.setSize(canvas.width, canvas.height);

    // Create a new Three.js scene
    scene = new THREE.Scene();

    // Add  a camera so we can view the scene
    camera = new THREE.PerspectiveCamera(45, canvas.width / canvas.height, 1, 4000);
    camera.position.set(-2, 6, 12);
    scene.add(camera);

    // Create a group to hold all the objects
    root = new THREE.Object3D;

    // Add a directional light to show off the object
    directionalLight = new THREE.DirectionalLight(0xffffff, 1);

    // Create and add all the lights
    directionalLight.position.set(.5, 0, 3);
    root.add(directionalLight);
    // Add a blue point light
    pointLight = new THREE.PointLight(0x0000ff, 1, 20);
    pointLight.position.set(-5, 2, -10);
    root.add(pointLight);
    // Add a green spot light
    spotLight = new THREE.SpotLight(0x00ff00);
    spotLight.position.set(2, 2, 5);
    spotLight.target.position.set(2, 0, 4);
    root.add(spotLight);

    ambientLight = new THREE.AmbientLight(0x888888);
    root.add(ambientLight);

    // Create a group to hold the spheres
    group = new THREE.Object3D;
    root.add(group);

    // Create a texture map
    var map = THREE.ImageUtils.loadTexture(mapUrl);
    map.wrapS = map.wrapT = THREE.RepeatWrapping;
    map.repeat.set(8, 8);

    var color = 0xffffff;
    // Add a gray ambient light
    var ambient = 0x888888;
    // Put in a ground plane to show off the lighting
    geometry = new THREE.PlaneGeometry(200, 200, 50, 50);
    var mesh = new THREE.Mesh(geometry, new THREE.MeshPhongMaterial({color: color,
        ambient: ambient, map: map, side: THREE.DoubleSide}));
    mesh.rotation.x = -Math.PI / 2;
    mesh.position.y = -4.02;

    // Add the mesh to our group
    group.add(mesh);

    // Create the cube geometry
    geometry = new THREE.CubeGeometry(2, 2, 2);

    // And put the geometry and material together into a mesh
    mesh = new THREE.Mesh(geometry, new THREE.MeshPhongMaterial({color: color,
        ambient: ambient}));
    mesh.position.y = 3;

    // Add the mesh to our group
    group.add(mesh);

    // Create the sphere geometry
    geometry = new THREE.SphereGeometry(Math.sqrt(2), 50, 50);

    // And put the geometry and material together into a mesh
    mesh = new THREE.Mesh(geometry, new THREE.MeshPhongMaterial({color: color,
        ambient: ambient}));
    mesh.position.y = 0;

    // Add the mesh to our group
    group.add(mesh);

    // Create the cylinder geometry
    geometry = new THREE.CylinderGeometry(1, 2, 2, 50, 10);

    // And put the geometry and material together into a mesh
    mesh = new THREE.Mesh(geometry, new THREE.MeshPhongMaterial({color: color,
        ambient: ambient}));
    mesh.position.y = -3;

    // Add the  mesh to our group
    group.add(mesh);

    // Now add the group to our scene
    scene.add(root);
}
function initControls() {
    $('#directional').ColorPicker({
        color: '#ffffff',
        onShow: function (colpkr) {
            $(colpkr).fadeIn(500);
            return false;
        },
        onHide: function (colpkr) {
            $(colpkr).fadeOut(500);
            return false;
        },
        onChange: function (hsb, hex, rgb) {
            $('#directional div').css('backgroundColor', '#' + hex);
            setLightColor(directionalLight, rgb.r, rgb.g, rgb.b);
        },
        onSubmit: function (hsb, hex, rgb, el) {
            $(el).val(hex);
            $('#directional div').css("background-color", "#" + hex);
            setLightColor(directionalLight, rgb.r, rgb.g, rgb.b);
            $(el).ColorPickerHide();
        },
    });
    var directionalHex = "#ffffff";
    $('#directional').ColorPickerSetColor(directionalHex);
    $('#directional div').css("background-color", directionalHex);

    $('#point').ColorPicker({
        color: '#ffffff',
        onShow: function (colpkr) {
            $(colpkr).fadeIn(500);
            return false;
        },
        onHide: function (colpkr) {
            $(colpkr).fadeOut(500);
            return false;
        },
        onChange: function (hsb, hex, rgb) {
            $('#point div').css('backgroundColor', '#' + hex);
            setLightColor(pointLight, rgb.r, rgb.g, rgb.b);
        },
        onSubmit: function (hsb, hex, rgb, el) {
            $(el).val(hex);
            $('#point div').css("background-color", "#" + hex);
            setLightColor(pointLight, rgb.r, rgb.g, rgb.b);
            $(el).ColorPickerHide();
        },
    });
    var pointHex = "#0000ff";
    $('#point').ColorPickerSetColor(pointHex);
    $('#point div').css("background-color", pointHex);

    $('#spot').ColorPicker({
        color: '#ffffff',
        onShow: function (colpkr) {
            $(colpkr).fadeIn(500);
            return false;
        },
        onHide: function (colpkr) {
            $(colpkr).fadeOut(500);
            return false;
        },
        onChange: function (hsb, hex, rgb) {
            $('#spot div').css('backgroundColor', '#' + hex);
            setLightColor(spotLight, rgb.r, rgb.g, rgb.b);
        },
        onSubmit: function (hsb, hex, rgb, el) {
            $(el).val(hex);
            $('#spot div').css("background-color", "#" + hex);
            setLightColor(spotLight, rgb.r, rgb.g, rgb.b);
            $(el).ColorPickerHide();
        },
    });
    var pointHex = "#00ff00";
    $('#spot').ColorPickerSetColor(pointHex);
    $('#spot div').css("background-color", pointHex);


    $('#ambient').ColorPicker({
        color: '#ffffff',
        onShow: function (colpkr) {
            $(colpkr).fadeIn(500);
            return false;
        },
        onHide: function (colpkr) {
            $(colpkr).fadeOut(500);
            return false;
        },
        onChange: function (hsb, hex, rgb) {
            $('#ambient div').css('backgroundColor', '#' + hex);
            setLightColor(ambientLight, rgb.r, rgb.g, rgb.b);
        },
        onSubmit: function (hsb, hex, rgb, el) {
            $(el).val(hex);
            $('#ambient div').css("background-color", "#" + hex);
            setLightColor(ambientLight, rgb.r, rgb.g, rgb.b);
            $(el).ColorPickerHide();
        },
    });
    var ambientHex = "#888888";
    $('#ambient').ColorPickerSetColor(ambientHex);
    $('#ambient div').css("background-color", ambientHex);

    $("#textureUrl").html(mapUrl);
    $("#texture").css("background-image", "url(" + mapUrl + ")");

    $("#textureCheckbox").click(
        function () {
            toggleTexture();
        }
    );

    orbitControls = new THREE.OrbitAndPanControls(camera, renderer.domElement);
}
$(document).ready(
    function () {

        var canvas = document.getElementById("webglcanvas");

        // create the scene
        createScene(canvas);

        // initialize the controls
        initControls();

        // Run the run loop
        run();
    }
);
