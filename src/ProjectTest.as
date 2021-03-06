package
{
	import away3d.containers.View3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	import away3d.containers.ObjectContainer3D;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	[SWF(frameRate="60", width="1024", height="576")]
	public class ProjectTest extends Sprite
	{
		private var _view : View3D;
		
		private var _light : PointLight;

		[Embed(source="../embeds/crossColor.jpg")]
		private var Albedo : Class;
		
		[Embed(source="../embeds/crossnrm.jpg")]
		private var Normals : Class;

		private var _camController : HoverDragController;
		private var _sphere : Sphere;

		private var _testSprite : Sprite;

		public function ProjectTest()
		{
			super();
			
			_view = new View3D();
			_camController = new HoverDragController(_view.camera, stage);
			_camController.radius = 500;

			addChild(_view);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);

			var material : BitmapMaterial = new BitmapMaterial(new Albedo().bitmapData);
//			material.normalMap = new Normals().bitmapData;
			material.ambientColor = 0x080820;
//			material.specularMethod = null;

			material.normalMap;
			_sphere = new Sphere(new ColorMaterial(0xff00ff), 15);
			_sphere.x = -50;
			_sphere.y = -50;
			_sphere.z = -50;
			_view.scene.addChild(_sphere);

			_light = new PointLight();
			_light.x = -1000;
			_light.y = 1000;
			_light.z = -1000;
			_light.color = 0xffeeaa;

			_testSprite = new Sprite();
			_testSprite.graphics.beginFill(0xffff00);
			_testSprite.graphics.drawCircle(0, 0, 5);
			_testSprite.graphics.endFill();
			addChild(_testSprite);

			material.lights = [_light];
			_view.scene.addChild(_light);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
        }

		private function onStageResize(event : Event) : void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
		
		
		private function handleEnterFrame(ev : Event) : void
		{
			//_ctr.rotationX = 20 * Math.sin(getTimer() * 0.002);
			_view.camera.x = Math.random()*5000;
			_view.camera.y = Math.random()*5000;
			_view.camera.z = Math.random()*5000;
			_view.camera.rotationX = Math.random()*6;
			_view.camera.rotationY = Math.random()*6;
			_view.camera.rotationZ = Math.random()*6;
			var v : Vector3D = _view.unproject(_view.mouseX, _view.mouseY);
			_sphere.x = _view.camera.x+(v.x-_view.camera.x)*20;
			_sphere.y = _view.camera.y+(v.y-_view.camera.y)*20;
			_sphere.z = _view.camera.z+(v.z-_view.camera.z)*20;
			var p : Point = _view.project(_sphere.scenePosition);
			_testSprite.x = p.x;
			_testSprite.y = p.y;
			_view.render();
		}
	}
}