import funkin.editors.ui.UIButton;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class CharacterAnimInfoButton extends UIButton {

    public var anim:String = "";

	public var editButton:UIButton;
	public var editIcon:FlxSprite;

	public var deleteButton:UIButton;
	public var deleteIcon:FlxSprite;

    public function new(x:Float, y:Float, anim:String, ?offset:FlxPoint) {
        this.anim = anim;
        super(x,y, '$anim', function () {}, 200);
        //this.bWidth = 200;
        this.resize(200, 32);
        autoAlpha = false;
		editButton = new UIButton(x + 200 + 5, y, "", function () {}, 32);
		editButton.frames = Paths.getFrames("editors/ui/grayscale-button");
		editButton.color = FlxColor.YELLOW;
		editButton.autoAlpha = false;
		members.push(editButton);

		editIcon = new FlxSprite(editButton.x + 8, editButton.y + 8).loadGraphic(Paths.image('editors/character/edit-button'));
		editIcon.antialiasing = false;
		members.push(editIcon);

		deleteButton = new UIButton(editButton.x+32+5, y, "", function () {}, 32);
		deleteButton.color = FlxColor.RED;
		deleteButton.autoAlpha = false;
		members.push(deleteButton);

		deleteIcon = new FlxSprite(deleteButton.x + (15/2), deleteButton.y + 8).loadGraphic(Paths.image('editors/delete-button'));
		deleteIcon.antialiasing = false;
		members.push(deleteIcon);
    }

    public override function update(elapsed:Float) {
        editButton.selectable = deleteButton.selectable = selectable;
		editButton.shouldPress = deleteButton.shouldPress = shouldPress;

		hovered = !deleteButton.hovered;
		updatePos();
        super.update(elapsed);
    }

    public function updateInfo(anim:String, ?offset:FlxPoint, ?ghost:Bool) {
		this.anim = anim;
		field.text = anim;
	}

    public function updatePos() {
		// buttons
		deleteButton.x = (editButton.x = (x+200+5))+32+5;
		deleteButton.y = editButton.y = y;
		// icons
		editIcon.x = editButton.x + 8; editIcon.y = editButton.y + 8;
		deleteIcon.x = deleteButton.x + (15/2); deleteIcon.y = deleteButton.y + 8;
	}
}