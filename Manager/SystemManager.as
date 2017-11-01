/**
 * Created by Administrator on 11/1/2017.
 */
package XGameEngine.Manager {
import XGameEngine.Structure.List;

import flash.system.ApplicationDomain;
import flash.utils.getDefinitionByName;

public class SystemManager extends  BaseManager{


    static private var _instance:SystemManager;
    static public function getInstance():SystemManager
    {
        if (_instance == null)
        {
            _instance = new SystemManager();
        }
        return _instance;
    }



    /**
     * get the class with target name
     * @param name
     * @return
     */
    public function getClassByName(name:String):Class
    {
        //优先从本swf里取 这样方便测试 可以先把要多次测试的剪辑先放在主swf里面调整 调整差不多后再放到资源swf里
        var classDefinition:Class
        try
        {
            classDefinition=getDefinitionByName(name) as Class;
            return classDefinition;
        }
        catch(error:Error){}

        var list:List=getEngine().domains;
        for each(var domain:ApplicationDomain in list.Raw)
        {
            try
            {
                if ((classDefinition=domain.getDefinition(name) as Class)!=null)
                {
                    return classDefinition;
                }
            }
            catch(error:Error){}

        }


        throw new Error(name+" class do not exist!");
    }

}
}
