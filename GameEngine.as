package XGameEngine {
import XGameEngine.BaseObject.BaseDisplayObject;
import XGameEngine.Manager.*;

import flash.display.Stage;
import flash.events.Event;

/**
 * a class that control the overall gameengine
 */
public class GameEngine {

    //game enengine only have one instance
    static private var _instance:GameEngine;


    static public function getInstance():GameEngine {
        if (_instance == null) {
            _instance = new GameEngine();
        }
        return _instance;
    }


    /**
     * stage
     */
    private var _stage:Stage;
    private var _debug:Boolean = false;

    /**
     * 游戏运行中能否改变debug状态 发行版游戏中一般设置为false
     */
    public var canChangeDebug:Boolean = false;
    /**
     *游戏面板
     */
    private var _gamePlane:BaseDisplayObject;
    /**
     *摄像机面板
     */
    private var _cameraPlane:BaseDisplayObject;
    /**
     *ui面板 层级高于游戏面板
     */
    private var _UIPlane:BaseDisplayObject;
    /**
     *ui面板2  备用
     */
    private var _UIPlane2:BaseDisplayObject;
    /**
     *debug面板 层级高于UI面板
     */
    private var _debugPlane:BaseDisplayObject;


    /**
     * has inited?
     */
    private var isInit:Boolean=false;


    /**
     * this should be called when game inited,generally from the entry class
     * 初始化游戏引擎
     * @param stage 舞台
     * @param dataPath 资源文件路径
     * @param loadCompleteFun 加载资源完成的监听
     * @param loadProgressFun 加载资源中的监听
     * @return
     *
     */
    public function Init(stage:Stage, dataPath:String = null, loadCompleteFun:Function = null, loadProgressFun:Function = null) {

        this._stage = stage;
        stage.addEventListener(Event.ENTER_FRAME, mainLoop);

        //init pane
        initShowPlane();

        //init sub manager
        InitManager();


        isInit=true;

        //如果有资源文件则开始加载资源
        if (dataPath != null) {
            loadResource(dataPath, loadCompleteFun, loadProgressFun);
        }


    }


    /**
     *初始化显示面板
     *
     */
    private function initShowPlane():void {
        _gamePlane = new BaseDisplayObject();
        _stage.addChild(_gamePlane);

        _cameraPlane = new BaseDisplayObject();
        _stage.addChild(_cameraPlane);

        _UIPlane = new BaseDisplayObject();
        _stage.addChild(_UIPlane);

        _UIPlane2 = new BaseDisplayObject();
        _stage.addChild(_UIPlane2);

        _debugPlane = new BaseDisplayObject();
        _stage.addChild(_debugPlane);


    }


    /**
     * load  swf resource
     * @param dataPath
     * @param loadCompleteFun
     * @param loadProgressFun
     */
    public function loadResource(dataPath:String, loadCompleteFun:Function, loadProgressFun:Function):void {
        getResourceManager().loadResource(dataPath,loadCompleteFun,loadProgressFun);
    }



    /**
     * 初始化管理器
     */
    private function InitManager() {

        //init input manager
        Input.Init(_stage);

    }

    public function getTimeManager():TimeManager {
        return TimeManager.getInstance();
    }

    public function getTagManager():TagManager {
        return TagManager.getInstance();
    }

    public function getGameObjectManager():GameObjectManager {
        return GameObjectManager.getInstance();
    }

    public function getLayerManager():LayerManager {
        return LayerManager.getInstance();
    }

    public function getHitManager():HitManager {
        return HitManager.getInstance();
    }

    public function getSoundManager():SoundManager {
        return SoundManager.getInstance();
    }

    public function getResourceManager():ResourceManager {
        return ResourceManager.getInstance();
    }

    public function getTweenManager():TweenManager {
        return TweenManager.getInstance();
    }

    public function getSystemManager():SystemManager {
        return SystemManager.getInstance();
    }

    private function mainLoop(e:Event) {
        TweenManager.getInstance().loop();
    }

    public function get stage():Stage {
        if (isInit==false){
            throw new Error("do not init engine");
        }
        return _stage;
    }

    public function get debug():Boolean {
        return _debug;
    }

    public function set debug(value:Boolean):void {
        if (canChangeDebug) {
            _debug = value;
        }

    }

    /**
     * add event to stage
     * @param type
     * @param listener
     * @param useCapture
     * @param priority
     * @param useWeakReference
     */
    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        stage.addEventListener(type,listener,useCapture,priority,useWeakReference);
    }

    /**
     * remove event from stage
     * @param type
     * @param listener
     * @param useCapture
     */
    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
        stage.removeEventListener(type,listener,useCapture);
    }

    public function get gamePlane():BaseDisplayObject {
        return _gamePlane;
    }

    public function get cameraPlane():BaseDisplayObject {
        return _cameraPlane;
    }

    public function get UIPlane():BaseDisplayObject {
        return _UIPlane;
    }

    public function get UIPlane2():BaseDisplayObject {
        return _UIPlane2;
    }

    public function get debugPlane():BaseDisplayObject {
        return _debugPlane;
    }
}

}