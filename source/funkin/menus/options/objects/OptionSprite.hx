package funkin.menu.options.objects;

import core.ui.*;
import options.objects.OptionModal;

/**
    Crash course on PARAMETERS

    types int, float, percent and slider all have:
    `min:Float`
    `max:Float`
    `decimals:Float`
    All of these types besides for slider have
    `step:Float`
    
    though for ints, they can be Ints instead

    the string type has 
    `options:Array<String`
**/
class OptionSprite extends FlxSpriteGroup
{
    public var name(default, set):String = 'Option';
    public var saveName:String = '';
    public var type:String = "BOOL";
    public var value(get, set):Dynamic;
    public var parameters:Dynamic;

    public var desc:String;

    private var text:FlxText;
    private var obj:Dynamic;
    private var min:Float;
    private var max:Float;

    public function set_name(v:String):String
    {
        if (text != null)
            text.text = v;
        name = v;
        return v;
    }

    public function get_value():Dynamic
        return Reflect.getProperty(Preferences.data, saveName);

    public function set_value(v:Dynamic):Dynamic
    {
        
        Reflect.setProperty(Preferences.data, saveName, v);
        return v;
    }

    public function new(X:Float, Y:Float, name:String, saveName:String, type:String, ?desc:String, ?parameters:Dynamic)
    {
        super(X, Y);
        //this.value = Reflect.getProperty(Preferences.defaultData, saveName);

        this.name = name;
        this.saveName = saveName;
        this.type = type.toLowerCase();
        this.desc = desc;

        this.parameters = parameters;

        create();
    }

    public function create()
    {
        text = new FlxText(0, 0, 0, name);
        var objX = text.width + 3;

        switch (type)
        {
            case 'bool':
                obj = new BrainyUICheckBox(objX, 0, '', function()
                {
                    value = obj.checked;
                });

                obj.set_checked(cast(value, Bool));

            case 'int', 'float', 'percent':
                obj = new BrainyUINumericStepper(objX, 0, parameters?.step, 0, parameters?.min, parameters?.max, parameters?.decimals, 60, (type == 'percent'));
                
                if (type == 'int')
                    obj.set_value(cast(value, Int));
                else
                    obj.set_value(cast(value, Float));
            case 'slider':
                obj = new BrainyUISlider(objX, 0, function(v:Float) {
                    value = v;
                }, 0, parameters?.min, parameters?.max);

                obj.set_value(cast(value, Float));

            case 'string':
                obj = new BrainyUIDropDownMenu(objX, 0, parameters?.options, function(v:Int, string:String)
                {
                    value = string;
                });

                obj.set_text(cast(value, String));
        }

        if (obj != null) add(obj);
        add(text);
    }

    override function update(elapsed:Float)
    {
        if (type == 'int' || type == 'float' || type == 'percent')
        {
            value = obj.value;
            if (saveName == 'framerate')
                onChangeFramerate();
        }

        super.update(elapsed);
    }

    function onChangeFramerate()
	{
		if(Preferences.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = Preferences.data.framerate;
			FlxG.drawFramerate = Preferences.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = Preferences.data.framerate;
			FlxG.updateFramerate = Preferences.data.framerate;
		}
	}
}