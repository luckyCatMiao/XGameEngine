package XGameEngine.GameObject.BaseComponent.Render.Filtters
{
import XGameEngine.BaseObject.BaseComponent.Render.Filtters.*;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;

	public class ShaderFilterX extends AbstractFiltter
	{
		private var shader:Shader;

		public function ShaderFilterX(shader:Shader)
		{
			this.shader=shader;
			this._fliter=new ShaderFilter(shader);
		}
		
		public function setShaderParamter(name:String, value:Object):void
		{
			
			shader.data[name]["value"]=[value];
			applyChange();
		}
	}
}