import funkin.options.type.NewOption;
import funkin.options.type.TextOption;
import funkin.options.OptionsScreen;
import funkin.editors.ui.UISubstateWindow;
import funkin.editors.ui.UIState;

function create() {}

function postCreate() {
    main.replace(main.members[0], new NewOption("New Character", "New Character", function() {
        openSubState(new UISubstateWindow(true, "newCharacter/CharacterCreationScreen"));
    }));
}