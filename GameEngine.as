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
    private var s:Stage;
    private var _debug:Boolean = false;

    /**
     * 游戏运行中能否改变debug状态 发行版游戏中一般设置为false
     */
    public var canChangeDebug:Boolean = false;
    /**
     *游戏面板
     */
    public var gamePlane:BaseDisplayObject;
    /**
     *摄像机面板
     */
    public var cameraPlane:BaseDisplayObject;
    /**
     *ui面板 层级高于游戏面板
     */
    public var UIPlane:BaseDisplayObject;
    /**
     *ui面板2  备用
     */
    public var UIPlane2:BaseDisplayObject;
    /**
     *debug面板 层级高于UI面板
     */
    public var debugPlane:BaseDisplayObject;


    /**
     * this should be called when game inited,generally from the entry class
     * 初始化游戏引擎
     * @param s 舞台
     * @param dataPath 资源文件路径
     * @param loadCompleteFun 加载资源完成的监听
     * @param loadProgressFun 加载资源中的监听
     * @return
     *
     */
    public function Init(s:Stage, dataPath:String = null, loadCompleteFun:Function = null, loadProgressFun:Function = null) {

        this.s = s;
        s.addEventListener(Event.ENTER_FRAME, mainLoop);

        //init pane
        initShowPlane();

        //init sub manager
        InitManager();


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
        gamePlane = new BaseDisplayObject();
        s.addChild(gamePlane);

        cameraPlane = new BaseDisplayObject();
        s.addChild(cameraPlane);

        UIPlane = new BaseDisplayObject();
        s.addChild(UIPlane);

        UIPlane2 = new BaseDisplayObject();
        s.addChild(UIPlane2);

        debugPlane = new BaseDisplayObject();
        s.addChild(debugPlane);


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
        Input.Init(s);

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
        return s;
    }

    public function get debug():Boolean {
        return _debug;
    }

    public function set debug(value:Boolean):void {
        if (canChangeDebug) {
            _debug = value;
        }

    }


}

}