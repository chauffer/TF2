stock bool:IsValidClient(client)
{
    if(client <= 0 || client > MaxClients || !IsClientInGame(client))
    return false;
    return true;
}

stock bool:IsInnocent(client)
{
    if(!IsValidClient(client)){ return false; }
    return sInnocent[client];
}

stock bool:IsDetective(client)
{
    if(!IsValidClient(client)){ return false; }
    return sDetective[client];
}

stock bool:IsTraitor(client)
{
    if(!IsValidClient(client)){ return false; }
    return sTraitor[client];
}

stock sReset(client){
    sTraitor[client] = false;
    sInnocent[client] = false;
    sDetective[client] = false;
}


stock GetAlivePlayers()
{
    new count;
    for(new client = 1; client <= MaxClients; client++) if(IsValidClient(client) && IsPlayerAlive(client)) count++;
    return count;
}

stock GetRandomUnselect() {
    new clients[MaxClients+1], clientCount;

    for (new i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && IsPlayerAlive(i) && !IsTraitor(i) && !IsDetective(i))
        {
                clients[clientCount++] = i;
        }
    }
    return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount-1)];
} 

stock GiveWeapon(client)
{
    new index = GetEntProp(GetPlayerWeaponSlot(client, TFWeaponSlot_Melee), Prop_Send, "m_iItemDefinitionIndex");
    new TFClassType:class = TF2_GetPlayerClass(client);
    if (!IsValidClient(client) || !IsPlayerAlive(client)){
        return;
    }

    if (TF2_GetPlayerClass(client) == TFClass_Spy){
        TF2_RemoveWeaponSlot(client, 3);
        TF2_RemoveWeaponSlot(client, 4);
    }

    switch(index){
        case 225, 574: TF2Items_GiveWeapon(client, 4);
    }

    switch(class){
        case TFClass_Pyro: TF2_RemoveWeaponSlot(client, 0);
    }
}


