import funkin.backend.assets.ModsFolder;
import funkin.backend.utils.XMLUtil;
import funkin.backend.utils.CoolUtil;
import funkin.editors.character.CharacterAnimScreen;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UIColorwheel;
import funkin.editors.ui.UIButtonList;

import haxe.xml.Printer;

import lime.ui.FileDialog;
import lime.ui.FileDialogType;

import openfl.utils.Assets;

import sys.io.File;
import sys.FileSystem;

import CharacterAnimInfoButton; //Custom class

import Xml;
import Std;

public var spriteTextBox:UITextBox;
public var iconTextBox:UITextBox;
public var iconSprite:FlxSprite;
public var gameOverCharTextBox:UITextBox;
public var antialiasingCheckbox:UICheckbox;
public var flipXCheckbox:UICheckbox;
public var iconColorWheel:UIColorwheel;
public var positionXStepper:UINumericStepper;
public var positionYStepper:UINumericStepper;
public var cameraXStepper:UINumericStepper;
public var cameraYStepper:UINumericStepper;
public var scaleStepper:UINumericStepper;
public var singTimeStepper:UINumericStepper;
public var animationsButtonList:UIButtonList<CharacterAnimInfoButton>;
public var isPlayerCheckbox:UICheckbox;
public var isGFCheckbox:UICheckbox;

public var saveButton:UIButton;
public var closeButton:UIButton;

public var onSave:(xml:Xml) -> Void = null;

var curData = {
    anim: []
};

function create() {
    winTitle = "Creating Character";
	winWidth = 1014;
	winHeight = 600;
    /*
    curData = {
        anim: []
    };
    */
}

function postCreate() {
    function addLabelOn(ui, text:String)
		add(new UIText(ui.x, ui.y - 24, 0, text));

    var title:UIText;
    add(title = new UIText(windowSpr.x + 20, windowSpr.y + 30 + 16, 0, "Sprite Data", 28));

    spriteTextBox = new UITextBox(title.x, title.y + title.height + 38, 'sprite', 200);
    add(spriteTextBox);
    addLabelOn(spriteTextBox, "Sprite");

    iconTextBox = new UITextBox(spriteTextBox.x + 200 + 26, spriteTextBox.y, 'sprite-icon', 150);
    iconTextBox.onChange = (newIcon:String) -> {updateIcon(newIcon);}
    add(iconTextBox);
    addLabelOn(iconTextBox, "Icon");

    updateIcon('face');

    gameOverCharTextBox = new UITextBox(iconTextBox.x + 150 + (75 + 12), iconTextBox.y, "bf-dead", 200);
    add(gameOverCharTextBox);
    addLabelOn(gameOverCharTextBox, "Game Over Character");

    antialiasingCheckbox = new UICheckbox(spriteTextBox.x, spriteTextBox.y + 10 + 32 + 28, "Antialiasing", true);
    add(antialiasingCheckbox);
    addLabelOn(antialiasingCheckbox, "Antialiased");

    flipXCheckbox = new UICheckbox(antialiasingCheckbox.x + 172, spriteTextBox.y + 10 + 32 + 28, "FlipX", false);
    add(flipXCheckbox);
    addLabelOn(flipXCheckbox, "Flipped");

    iconColorWheel = new UIColorwheel(gameOverCharTextBox.x + 200 + 20, gameOverCharTextBox.y, 0xFFFFFFFF);
    add(iconColorWheel);
    addLabelOn(iconColorWheel, "Icon Color");

    add(title = new UIText(spriteTextBox.x, spriteTextBox.y + 10 + 46 + 84, 0, "Character Data", 28));

    positionXStepper = new UINumericStepper(title.x, title.y + title.height + 36, 0, 0.001, 2, null, null, 84);
    add(positionXStepper);
    addLabelOn(positionXStepper, "Position (X,Y)");

    add(new UIText(positionXStepper.x + 84 - 32 + 0, positionXStepper.y + 9, 0, ",", 22));

    positionYStepper = new UINumericStepper(positionXStepper.x + 84 - 32 + 26, positionXStepper.y, 0, 0.001, 2, null, null, 84);
    add(positionYStepper);

    cameraXStepper = new UINumericStepper(positionYStepper.x + 36 + 84 - 32, positionYStepper.y, 0, 0.001, 2, null, null, 84);
    add(cameraXStepper);
    addLabelOn(cameraXStepper, "Camera Position (X,Y)");

    add(new UIText(cameraXStepper.x + 84 - 32 + 0, cameraXStepper.y + 9, 0, ",", 22));

    cameraYStepper = new UINumericStepper(cameraXStepper.x + 84 - 32 + 26, cameraXStepper.y, 0, 0.001, 2, null, null, 84);
    add(cameraYStepper);

    scaleStepper = new UINumericStepper(cameraYStepper.x + 84 - 32 + 90, cameraYStepper.y, 1, 0.001, 2, null, null, 74);
    add(scaleStepper);
    addLabelOn(scaleStepper, "Scale");

    singTimeStepper = new UINumericStepper(scaleStepper.x + 74 - 32 + 36, scaleStepper.y, 4, 0.001, 2, null, null, 74);
    add(singTimeStepper);
    addLabelOn(singTimeStepper, "Sing Duration (Steps)");

    animationsButtonList = new UIButtonList/*<CharacterAnimInfoButton>*/(singTimeStepper.x + singTimeStepper.width + 200, singTimeStepper.y, 290, 200, '', FlxPoint.get(280, 35), null, 5);
    animationsButtonList.frames = Paths.getFrames('editors/ui/inputbox');
    animationsButtonList.cameraSpacing = 0;
    animationsButtonList.addButton.callback = function() {
        //customPropertiesButtonList.add(new PropertyButton("newProperty", "valueHere", customPropertiesButtonList));
        openSubState(new CharacterAnimScreen(null, (_) -> {
            if(_ != null) addAnim(_);
        }));
    }
    add(animationsButtonList);
    addLabelOn(animationsButtonList, "Animations");

    isPlayerCheckbox = new UICheckbox(positionXStepper.x, positionXStepper.y + 10 + 32 + 28, "isPlayer", false);
    add(isPlayerCheckbox);
    addLabelOn(isPlayerCheckbox, "Is Player");

    isGFCheckbox = new UICheckbox(isPlayerCheckbox.x + 128, positionXStepper.y + 10 + 32 + 28, "isGF", false);
    add(isGFCheckbox);
    addLabelOn(isGFCheckbox, "Is GF");

    for (checkbox in [isPlayerCheckbox, isGFCheckbox, antialiasingCheckbox, flipXCheckbox])
        {checkbox.y += 4; checkbox.x += 6;}

    saveButton = new UIButton(windowSpr.x + windowSpr.bWidth - 20, windowSpr.y + windowSpr.bHeight- 20, "Save & Close", function() {
        buildCharacter();
        //CharacterCreationScreen.instance = null;
        close();
    }, 125);
    saveButton.x -= saveButton.bWidth;
    saveButton.y -= saveButton.bHeight;

    closeButton = new UIButton(saveButton.x - 20, saveButton.y, "Close", function() {
        if (onSave != null) onSave(null);
        //CharacterCreationScreen.instance = null;
        close();
    }, 125);
    closeButton.x -= closeButton.bWidth;
    closeButton.color = 0xFFFF0000;
    add(closeButton);
    add(saveButton);
}

function updateIcon(icon:String) {
    if (iconSprite == null) add(iconSprite = new FlxSprite());
    /*
    if (iconSprite.animation.exists(icon)) return;
    @:privateAccess iconSprite.animation.clearAnimations();
    */
    var path:String = Paths.image('icons/$icon');
    if (!Assets.exists(path)) path = Paths.image('icons/face');

    iconSprite.loadGraphic(path, true, 150, 150);
    iconSprite.animation.add(icon, [0], 0, false);
    iconSprite.antialiasing = true;
    iconSprite.animation.play(icon);

    iconSprite.scale.set(0.5, 0.5);
    iconSprite.updateHitbox();
    iconSprite.setPosition(iconTextBox.x + 150 + 8, (iconTextBox.y + 16) - (iconSprite.height/2));
}

function saveCharacterInfo() {
    /*
    for (stepper in [positionXStepper, positionYStepper, cameraXStepper, cameraYStepper, singTimeStepper, scaleStepper])
        @:privateAccess stepper.__onChange(stepper.label.text);
    */
    var xml = Xml.createElement("character");
    xml.set("isPlayer", isPlayerCheckbox.checked ? "true" : "false");
    xml.set("x", Std.string(positionXStepper.value));
    xml.set("y", Std.string(positionYStepper.value));
    xml.set("gameOverChar", gameOverCharTextBox.label.text);
    xml.set("camx", Std.string(cameraXStepper.value));
    xml.set("camy", Std.string(cameraYStepper.value));
    xml.set("holdTime", Std.string(singTimeStepper.value));
    xml.set("flipX", Std.string(flipXCheckbox.checked));
    xml.set("icon", iconTextBox.label.text);
    xml.set("scale", Std.string(scaleStepper.value));
    xml.set("antialiasing", antialiasingCheckbox.checked ? "true" : "false");
    xml.set("sprite", spriteTextBox.label.text);
    if (iconColorWheel.colorChanged)
        xml.set("color", iconColorWheel.curColor.toWebString());

    for (anim in curData.anim)
    {
        var animXml:Xml = Xml.createElement('anim');
        animXml.set("name", anim.name);
        animXml.set("anim", anim.anim);
        animXml.set("loop", Std.string(anim.loop));
        animXml.set("fps", Std.string(anim.fps));
        //var offset:FlxPoint = character.getAnimOffset(anim.name);
        var offset:FlxPoint = FlxPoint.get(anim.x, anim.y);
        animXml.set("x", Std.string(offset.x));
        animXml.set("y", Std.string(offset.y));
        offset.put();

        if (anim.indices.length > 0)
            animXml.set("indices", CoolUtil.formatNumberRange(anim.indices));
        xml.addChild(animXml);
    }
    // End of writing XML, time to save it
    var data:String = "<!DOCTYPE codename-engine-character>\n" + Printer.print(xml, true);
    var fileDialog = new FileDialog();
    fileDialog.onCancel.add(function() close());
    fileDialog.onSelect.add(function(str)
    {
        CoolUtil.safeSaveFile(str, data);
        close();
        FlxG.resetState();
    });
    var fullPath = FileSystem.fullPath(Paths.xml('characters/character'));
    fileDialog.browse(FileDialogType.SAVE, "*.xml", fullPath);
    if (onSave != null) onSave(xml);
}

function addAnim(animData:AnimData, animID:Int = -1) {
    var newButton = new CharacterAnimInfoButton(0, 0, animData.name, FlxPoint.get(animData.x,animData.y));
    // Edit/Delete callbacks
    newButton.editButton.callback = function() {
        editAnim(newButton.anim);
    };
    newButton.deleteButton.callback = function() {
        deleteAnim(newButton.anim);
    };

    if (animID == -1){ 
        animationsButtonList.add(newButton);
        curData.anim.push(animData);
    }
    else {
        animationsButtonList.insert(newButton, animID);
        curData.anim.insert(animID, animData);
    }
}

public function editAnim(name:String) {
    var _anim:AnimData = null;
    for(anim in curData.anim) {
        if(anim.name == name) {
            _anim = anim;
            break;
        }
    }
    openSubState(new CharacterAnimScreen(_anim, (_) -> {
        if(_ != null) _edit_anim(name, _anim, _);
    }));
}

function _edit_anim(name:String, oldAnimData:AnimData, animData:AnimData) {
    var buttoner:CharacterAnimInfoButton = null;
    for (button in animationsButtonList.buttons.members)
        if (button.anim == name) buttoner = button;
    buttoner.updateInfo(animData.name);

    //Replace the old data
    var index = curData.anim.indexOf(oldAnimData);
    curData.anim[index] = animData;
}

public function deleteAnim(name:String) {
    for(button in animationsButtonList.buttons.members)
    {
        if(button.anim == name)
            animationsButtonList.remove(button);
    }
    for (anim in curData.anim)
    {
        if (anim.name == name)
        {
            curData.anim.remove(anim);
            break;
        }
    }
}

// ???
function buildCharacter() {
    saveCharacterInfo();
}
/*
typedef CharacterCreationData = {
	var anim:Array<AnimData>;
}
*/