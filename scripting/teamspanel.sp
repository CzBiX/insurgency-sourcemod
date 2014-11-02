//(C) 2014 Jared Ballou <sourcemod@jballou.com>
//Released under GPLv3

#include <sourcemod>
#include <sdktools>


//Define CVARS
#define TEAM_SPECTATORS 1
#define TEAM_SECURITY 2
#define TEAM_INSURGENTS 3
#define PLUGIN_VERSION "0.0.1"

//Plugin Info Block
public Plugin:myinfo =
{
	name = "Insurgency Bot Counter",
	author = "jballou",
	description = "Shows Bots Left Alive",
	version = PLUGIN_VERSION,
	url = "http://jballou.com"
};





new Handle:PanelTimers[MAXPLAYERS+1];
 
public OnClientPutInServer(client)
{
	PanelTimers[client] = CreateTimer(60.0, RefreshPanel, client, TIMER_REPEAT);
}
 
public OnClientDisconnect(client)
{
	if (PanelTimers[client] != INVALID_HANDLE)
	{
		KillTimer(PanelTimers[client]);
		PanelTimers[client] = INVALID_HANDLE;
	}
}
 
public Action:RefreshPanel(Handle:timer, any:client)
{
	if (IsValidPlayer(client))
	{
		new myteam = GetClientTeam(client);
		new otherteam = (myteam == TEAM_SECURITY) ? TEAM_INSURGENTS : TEAM_SECURITY;
		decl String:hint[40];
		new num_ins = 0, total_ins;
		new maxplayers = GetMaxClients();

		for (new i = 1; i <= maxplayers; i++)
		{
			if (IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
			{
				if (GetClientTeam(i) == otherteam)
				{
					num_ins++;
				}
			}
		}
		total_ins = GetTeamClientCount(otherteam);
		Format(hint, 255,"Enemies Remaining: %i of %i", num_ins, total_ins);

		PrintHintText(client, "%s", hint);
	}
	return Plugin_Continue;
}

//Is Valid Player
public IsValidPlayer(client)
{
	if (client == 0)
		return false;
	
	if (!IsClientConnected(client))
		return false;
	
	if (IsFakeClient(client))
		return false;
	
	if (!IsClientInGame(client))
		return false;
	
	return true;
}


