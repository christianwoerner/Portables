20190308
 -----------------------
	- use generic ply reader/writer (taken from Easy3D)
	
20190124
 -----------------------
	- detect/remove duplicated faces (for triangle meshes)
	- detect/remesh self intersections (for triangle meshes)

20181215
 -----------------------
	- shadowing works with AMD graphcs cards

20181206
 -----------------------
	- enable zoom on pivot point(if defined); avoid getting too close to pivot (or deadlock may occur)

20181116
 -----------------------
	- the PLY read/writer can handle scalar fields defined on edges (of course Mapple can visualize them)

20181116
 -----------------------
	- fixed a bug in rendering vector fields (where empty names caused a warning)
	- fixed a bug in preparing data for GPU (where mesh vertex normal attribute was always added)
	- point clouds will not join transparency rendering
	- updated laslib
	- vg/bvg do not have to handle normals and colors

20181106
 -----------------------
	- bug fixed
	- improved RANSAC dialog

20181026
 -----------------------
	- able to read/write arbitrary types of properties for both point clouds and meshes

20180607
 -----------------------
	- fixed a bug in MeshPicker (introduced in last change) where the hitting point was not updated

20180505
 -----------------------
	- now MeshPicker is robust in handeling faces/edges with duplicated vertices

20180505
 -----------------------
	- able to render models with non-convex faces
	- able to convert models with non-convex faces into triangle models

20180502
 -----------------------
	- updated to SuperLU-5.2.1

20180417
 -----------------------
	- more compact user interface

20180401
 -----------------------
	- updated to SuiteSparse-5.1.2 and metis-5.1.0	
	- updated to SuperLU-5.2.1

20180214
 -----------------------
	- now most features are back on machines with AMD GPU(s), except shadowing. The problem was that the depth test was disabled after call to drawText(). I guess that was a bug in Qt's QOpenGLWidget module (now I switched back to the deprecated QGLWidget).

20180206
 -----------------------
	- now both las and laz formats are supported (NOTE: saving discards point normals).

20180201
 -----------------------
	- glew updated to v2.1.

20170822
 -----------------------
	- select vertex groups.

20171016
 -----------------------
	- 2D Delaunay triangulation using Shewchuk's "triangle" implementation (only X and Y coordinates are used).
	- handle comments at the beginning of OFF mesh format.
	- progress logger for ASCII file format.

20170822
 -----------------------
	- point cloud down sampling by specifying expected point number.

20170816
 -----------------------
	- bug fixed in MeshScalarRenderer (always computes scalar field range that harms frame rate). 

20170726
 -----------------------
	- added axis constraint to clipping plane. 

20170726
 -----------------------
	- SSAO now works. 
	
20170706
-----------------------
	- bug fixed in Gaussian noise generation (normal vector not normalized).

20170704
-----------------------
	- shadow now works (using shadow maps and PCSS).

20170608
-----------------------
	- line as cylinder imposer now works in orthographic mode (in EdgeAsCylinder).

20170529
-----------------------
	- DualDepthPeeling now works.
	- AverageColors now works.

20170512
-----------------------
	- eye dome lighting now works.

20170510
-----------------------
	- extended FramebufferObject to support multiple color attachments.

20170508
-----------------------
	- fixed incorrect VertexGroupType for sphere and cylinder in RansacDetector.

20170502
-----------------------
	- added HAS_QOPENGLWIDGET preferring QOpenGLWidget if Qt supports (since Qt5.4); 
	- snapshot using my own FramebufferObject class;
	- model/face/vertex picking using my own FramebufferObject class;
