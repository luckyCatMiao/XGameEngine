package XGameEngine.GameObject.GameObjectComponent.StateMachine
{


import XGameEngine.Constant.Error.AbstractMethodError;
import XGameEngine.GameObject.BaseGameObject;
import XGameEngine.Structure.List;

import flash.events.Event;
import flash.utils.getQualifiedClassName;

   public class AbstractState {

	

	private var entity:BaseGameObject ;
	private var listeners:List=new List();
	

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
	
	
	/**
	 *接受从host那里接受到的事件 (host要放上侦听器才能接受到时间) 
	 * @param e
	 * @return 
	 * 
	 */	
	public function receiveEvent(e:Event)
	{
		//根据监听设置 进行传递
		for each(var l:Listener in listeners.Raw)
		{
			if(l.type==e.type)
			{
				l.fun(e);
			}
		}
		
	}
	
	public function addEventListener(type:String,fun:Function)
	{
		
		var l:Listener=new Listener();
		l.fun=fun;
		l.type=type;
		
		listeners.add(l);
	}
	
	
   }
	
}
import flash.events.Event;

class Listener 
{
	public var type:String;
	public var fun:Function
	
}
