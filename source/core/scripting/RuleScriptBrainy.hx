package core.scripting;

import rulescript.Context;
import rulescript.RuleScript;
import rulescript.parsers.HxParser;
import rulescript.types.ScriptedTypeUtil;

typedef RuleScriptInit = 
{
    @:optional var modulePath:String;
    @:optional var scriptPath:String;
}

class RuleScriptBrainy
{
    public static var scripts:Map<String, RuleScript> = new Map();

    public static function set(variable:String, v:Dynamic, ?id:String)
    {
        if (id == null)
        {
            for (script in scripts)
            {
                script.getInterp().setVar(variable, v);
            }
        }
        else
            scripts.get(id).getInterp().setVar(variable, v);
    }

    public static function init(id:String, scriptName:String)
    {
        var script = new RuleScript(new HxParser(), new Context());
        script.scriptName = scriptName;
        script.getParser(HxParser).allowAll();

        scripts.set(id, script);
    }

    public inline static function execute(id:String)
    {
        var script = scripts.get(id);
        return script.execute(script.parser.parse(code));
    }
}