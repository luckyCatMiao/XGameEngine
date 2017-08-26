package XGameEngine.GameObject.GameObjectComponent.StateMachine
{


import XGameEngine.Constant.Error.AbstractMethodError;
import XGameEngine.GameObject.BaseGameObject;

import flash.utils.getQualifiedClassName;

   public class AbstractState {

	

	private var entity:BaseGameObject ;

	public function AbstractState(entity:BaseGameObject ) {
		this.entity=entity;
		
	}
	
	 public function enter():void
	 {
		 //throw new AbstractMethodError();
	 }
	
	 public function during():void
	 {
		 //throw new AbstractMethodError();
	 }
	
	 public function exit():void
	 {
		 //throw new AbstractMethodError();
	 }
	
	/**
	 * 从之前的状态返回
	 */
	 public function flip():void
	 {
		 //throw new AbstractMethodError();
	 }

	 
	

	
	/**
	 * 
	 * 名字
	 */	
	public function getName():String {
		return getQualifiedClassName(this);
	}

	
	public function getHost():BaseGameObject {
		return this.entity;
	}
	
	/**
	 *判断两个状态是否是同一个(同一个类)
	 */	
	public function equals(obj:AbstractState):Boolean {
	
		return getQualifiedClassName(obj)==getQualifiedClassName(this); 
		
	}
	
	
	
   }
	
}
