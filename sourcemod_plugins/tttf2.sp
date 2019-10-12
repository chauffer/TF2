#include <sourcemod>
#include <tf2_stocks>
#include <tf2items_giveweapon>
public Plugin:myinfo =
{
	name = "TTTF2",
	author = "ChauffeR",
	version = "0.0.0-git",
	url = "https://tttf2.com",
}



#pragma semicolon 1
#define RED_TEAM 2
#define BLUE_TEAM 3
#define ROUND_TIME 600
#define TIMER_NAME "tttf2_timer"

new bool:sInnocent[MAXPLAYERS+1] = false;
new bool:sTraitor[MAXPLAYERS+1] = false;
new bool:sDetective[MAXPLAYERS+1] = false;
new Handle:CVar_roundtime = INVALID_HANDLE;
new Handle:CVar_traitor_pct = INVALID_HANDLE;
new Handle:CVar_detective_pct = INVALID_HANDLE;
//new Handle:CVar_killer_dna_range = INVALID_HANDLE;
//new Handle:CVar_killer_dna_basetime = INVALID_HANDLE;

#include <tttf2_stocks>

public OnPluginStart(){
	HookEvent("player_team", Event_PlayerTeam);
	//HookEvent("post_inventory_application", Event_PlayerRegen);
	//HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_death", Event_PlayerDeath);
	// ROUND
	//HookEvent("teamplay_round_start", Event_RoundPreStart);
	HookEvent("arena_round_start", Event_RoundStart);
	HookEvent("arena_win_panel", Event_RoundEnd);

	// CVARS
	CVar_roundtime = CreateConVar("tttf2_roundtime", "600", "TTTF2 Round Time");
	CVar_traitor_pct = CreateConVar("tttf2_traitor_pct", "0.25", "TTTF2 Traitor percentage");
	CVar_detective_pct = CreateConVar("tttf2_detective_pct", "0.13", "TTTF2 Detective percentage");
	//CVar_killer_dna_range = CreateConVar("tttf2_killer_dna_range", "5", "TTTF2 Killer DNA Range");  // TODO Copy paste math func
	//CVar_killer_dna_basetime = CreateConVar("tttf2_killer_dna_basetime", "600", "TTTF2 Killer DNA Basetime");
	
}

public OnMapStart(){
	decl String:roundtime[128];
	GetConVarString(CVar_roundtime, roundtime, sizeof(roundtime));
	new arenaLogic = FindEntityByClassname(-1, "tf_logic_arena");
	new timer = CreateEntityByName("team_round_timer");
	DispatchKeyValue(timer, "targetname", TIMER_NAME);
	DispatchKeyValue(timer, "setup_length", "10");
	//DispatchKeyValue(timer, "setup_length", "30");
	DispatchKeyValue(timer, "reset_time", "1");
	DispatchKeyValue(timer, "auto_countdown", "1");
	DispatchKeyValue(timer, "timer_length", roundtime);
	DispatchSpawn(timer);

	decl String:finishedCommand[256];
	Format(finishedCommand, sizeof(finishedCommand), "OnArenaRoundStart %s:ShowInHUD:1:0:-1", TIMER_NAME);
	SetVariantString(finishedCommand);
	AcceptEntityInput(arenaLogic, "AddOutput");
	Format(finishedCommand, sizeof(finishedCommand), "OnArenaRoundStart %s:Resume:0:0:-1", TIMER_NAME);
	SetVariantString(finishedCommand);
	AcceptEntityInput(arenaLogic, "AddOutput");
	Format(finishedCommand, sizeof(finishedCommand), "OnArenaRoundStart %s:Enable:0:0:-1", TIMER_NAME);
	SetVariantString(finishedCommand);
	AcceptEntityInput(arenaLogic, "AddOutput");
}

public Event_RoundPreStart(Handle:event, const String:name[], bool:dontBroadcast){
	SetConVarBool(FindConVar("mp_friendlyfire"), false);
}

public Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast){
	SetConVarBool(FindConVar("mp_friendlyfire"), true);
	new candidates = GetAlivePlayers();
	new n_traitors = RoundToFloor(candidates / GetConVarFloat(CVar_traitor_pct));
	new n_detectives = RoundToFloor(candidates / GetConVarFloat(CVar_detective_pct));

	if(n_traitors == 0){
		n_traitors = 1;
	} 
	
	if(n_detectives > 3){
		n_detectives = 3;
	}
	
	for(new i = 1; i <= n_detectives; i++){
		new candidate_det = GetRandomUnselect();
		if(candidate_det > 0){
			sTraitor[candidate_det] = true;
		}else{
			//PrintToConsoleAll('No candidate Dets.')
		}
	}

	for(new i = 1; i <= n_traitors; i++){
		new candidate_t = GetRandomUnselect();
		if(candidate_t > 0){
			sTraitor[candidate_t] = true;
		}else{
			//PrintToConsoleAll('No candidate Ts.')
		}
	}

}

public Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast){
	SetConVarBool(FindConVar("mp_friendlyfire"), true);
}


/// CONNECT / DISCONNECT
public OnClientConnected(client){
	sReset(client);
}

public OnClientPutInServer(client){
	sReset(client);
	if(!IsFakeClient(client))
	{

	}
}

public OnClientDisconnect(client){
	//RequestFrame(CheckDeath);
}

/// EVENTS

//// DEATH

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast) {
	SetEventBroadcast(event, true);
	return Plugin_Continue;
} 


//// TEAM
public Action:Event_PlayerTeam(Handle:event, const String:name[], bool:dontBroadcast){
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	RequestFrame(StabilizeTeam, GetClientSerial(client));
}

public StabilizeTeam(any:serial){
	new client = GetClientFromSerial(serial);
	new TFTeam:team = TF2_GetClientTeam(client);
	if(team == TFTeam_Blue && !IsDetective(client)){
		ChangeClientTeam(client, RED_TEAM);
	}
}

public Action:OnPlayerRegen(Handle:hEvent, String:strName[], bool:bHidden){
	new client = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	GiveWeapon(client);
	return Plugin_Handled;
}

