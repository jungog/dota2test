function add_bot_click() {
    $.Msg("click addbot");
    Game.AutoAssignPlayersToTeams();
    GameEvents.SendCustomGameEventToServer("ADD_BOT", {});
}

function OnUpdateBotCount(data) {
    $("#lblBotCount").text = data.count;
}

function InitSettingPanel() {
    var localPlayer = Game.GetLocalPlayerInfo();
    $.Msg("InitSettingPanel", localPlayer);
    if (!localPlayer) {
        $.Schedule(1, InitSettingPanel);
    } else {
        if (localPlayer.player_has_host_privileges) {
            $("#setting_box").style.visibility = "visible";
        } else {
            $("#setting_box").style.visibility = "collapse";
        }
    }
}

(function () {
    GameEvents.Subscribe("UPDATE_BOT_COUNT", OnUpdateBotCount);
    InitSettingPanel();
})();