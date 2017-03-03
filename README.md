# TestOpenVR
Testing OpenVR extensions to Godot

This is a test Godot project for testing the OpenVR enhancements I've made to Godot. 

Compiling
=========
Note that you must build Godot from source using the enhancements in the OpenVR Branch in my Godot github fork.
You also need to make sure you obtain the contents of the bin and lib folder of the OpenVR project from here:
https://github.com/ValveSoftware/openvr
As Godots ignore rules filter out some of the required files. OpenVR does not give access to the source unfortunately. For now just copy bin and lib to thirdparty/openvr/.

Currently compilation only works on Windows for 64bit and requires renaming openvr_api.lib to openvr_api.lib.windows.tools.64.lib.
You also need to copy openvr.dll into the folder that contains your godot exe for it to all work.
In theory it should be easy to adjust the code to compile on Mac or Linux as support for both is included in OpenVR however I haven't had a chance to look into this.

The sample project
==================
The VR solution is implemented through a new spatial node called SpatialTracker 
Each node can be linked to one of the tracked devices, the HMD, the VIVE controllers, even the base stations.
As a result it is the OpenVR library that updates the rotation and translation properties of the node.
You'll see they are even updated in the Godot editor if you've got your VIVE hardware attached. 

At this point in time there is no rendering to the HMD yet and we've just got some testcubes to make the tracking visible.

Also note that the order in which you've turned on devices may effect what ID OpenVR has assigned to each controller.
You may need to change these IDs. I will be adding code later on that does some detection for this.

There are a few important limitations to the (current) solution:
- your VIVE must be attached before starting Godot or OpenVR will fail to initialize. I'm planning to add a restart/retry function in due time.
- the HMD should be the first tracked node in your scene as it currently handles some of the processing. This will be moved to something more global.

Finally in VR units are much more important then in a non-stereoscopic environment. 
In normal 3D Godot projects it doesn't matter if you units are in centimeters, meters, fantasieworldunits, etc. 
In VR (or stereoscopic rendering in general) all of a sudden this is very important. If the distance between the two cameras, the distance between your two eyes, doesn't match up with the scale of the scene you are looking at, you'll be in for a very uncomfortable experience.
For OpenVR the units are set to meters. So by default out 1.0 x 1.0 x 1.0 test cube is a 1 meter x 1 meter x 1 meter cube. You'll see that the cubes in the test project are scaled by 0.1 meaning they are 10cm x 10cm x 10cm in size.
Keep this in mind as you design and import assets.

Abstraction
===========
The implementation of SpatialTracker has been setup to have an abstraction class that is subclassed to communicate with the OpenVR SDK. In theory additional subclasses can be created for other SDKs like the Oculus SDK or the OSVR SDK. OpenVR being the first I'm implementing may result in the implementation being adjusted.

One of the things i haven't solved here is that different platforms may make different SDKs available. OpenVR should only be compiled in if you're compiling for Windows, Mac or Linux, while we may introduce say daydream or a more generic mobile VR option when targeting mobile. 

The class that communicates with the OpenVR SDK is a singleton that is shared with all of the trackers. This singleton is only instantiated if you actually have trackers in your scene.

Roadmap
=======

This is still very much up in the air but I'm planning to tackle the following enhancements over the coming few weeks:
- implement a resource class that gives access to the render models interface in OpenVR. This allows you to render out controllers and base stations in your interface. 
- add button and joypad properties to the SpatialTracker class to give feedback on which buttons are pressed. While you could get to (or I could add) this information through Godots existing joystick input class I feel the SpatialTracker is a more natural implementation for VR
- add signals for button presses on the controllers, detecting enabling/disabling controllers, etc.
- create viewports for output to the HMD, unlike the early headsets we're not directly outputting to a 'monitor' (its possible with the Vive but not recommended) but we're outputting buffers to the SDK. The SDK does things like barrel adjustments.
- enhance the existing camera or implement a new camera class that uses the projection matrices provided in OpenVR. Because the Vive allows you to adjust IPD on the device it is the SDK that provides us with projection matrices and positioning information that match with the person who's wearing the device.
- look into parallel stereo rendering by allowing viewports to have separate left/right buffers, be linked to two instead of 1 cameras, culling based on a combined view frustum and duplicating draw class to render both eyes simultaniously.
- look into both optimizing showing (or disabling) the output of one of the eyes to the monitor for spectators or allow for an alternative 3rd camera to render this. The main goal is to support tracked 3rd camera rendering for green screen composition but also for multiplayer games where one is using the HMD and another player is using the monitor to play.
