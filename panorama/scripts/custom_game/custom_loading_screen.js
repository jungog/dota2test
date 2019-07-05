function add_bot_click() {
    Game.AutoAssignPlayersToTeams();
    GameEvents.SendCustomGameEventToServer("ADD_BOT", {});
}