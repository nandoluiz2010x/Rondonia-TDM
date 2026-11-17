#include <a_samp>

#define DIALOG_TEAM 1000

#define TEAM_NONE 0
#define TEAM_AZUL 1
#define TEAM_VERMELHA 2

#define COLOR_AZUL       0x3399FFFF
#define COLOR_VERMELHA   0xFF4444FF
#define COLOR_BRANCO     0xFFFFFFFF
#define COLOR_VERDE      0x33CC66FF
#define COLOR_AMARELO    0xFFFF00FF

#define WEAPON_SNIPER 34

new gTeam[MAX_PLAYERS];

public OnGameModeInit()
{
    SetGameModeText("Rondonia TDM - Sniper HS");
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
    ShowNameTags(true);
    SetWorldTime(12);
    SetWeather(10);

    AddPlayerClass(287, 1958.3783, 1343.1572, 15.3746, 269.1425,
        WEAPON_SNIPER, 30, 0, 0, 0, 0);

    print("RONDONIA TDM - Sniper HS carregado.");
    return 1;
}

public OnGameModeExit()
{
    return 1;
}

public OnPlayerConnect(playerid)
{
    gTeam[playerid] = TEAM_NONE;
    SendClientMessage(playerid, COLOR_VERDE,
        "Bem-vindo ao RONDONIA TDM!");
    SendClientMessage(playerid, COLOR_BRANCO,
        "Escolha Azul ou Vermelha. O combate usa somente Sniper.");
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    gTeam[playerid] = TEAM_NONE;
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    ShowPlayerDialog(playerid, DIALOG_TEAM, DIALOG_STYLE_LIST,
        "RONDONIA TDM - Escolha sua equipe",
        "Equipe Azul\nEquipe Vermelha",
        "Jogar", "Sair");
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_TEAM)
    {
        if (!response) return 1;

        if (listitem == 0)
        {
            gTeam[playerid] = TEAM_AZUL;
            SetPlayerTeam(playerid, TEAM_AZUL);
            SetPlayerColor(playerid, COLOR_AZUL);
            SetSpawnInfo(playerid, TEAM_AZUL, 287,
                1958.3783, 1343.1572, 15.3746, 269.1425,
                WEAPON_SNIPER, 30, 0, 0, 0, 0);
            SendClientMessage(playerid, COLOR_AZUL,
                "Voce entrou na Equipe Azul!");
        }
        else if (listitem == 1)
        {
            gTeam[playerid] = TEAM_VERMELHA;
            SetPlayerTeam(playerid, TEAM_VERMELHA);
            SetPlayerColor(playerid, COLOR_VERMELHA);
            SetSpawnInfo(playerid, TEAM_VERMELHA, 285,
                2005.0000, 1343.1572, 15.3746, 89.1425,
                WEAPON_SNIPER, 30, 0, 0, 0, 0);
            SendClientMessage(playerid, COLOR_VERMELHA,
                "Voce entrou na Equipe Vermelha!");
        }

        SpawnPlayer(playerid);
        return 1;
    }
    return 0;
}

public OnPlayerSpawn(playerid)
{
    if (gTeam[playerid] == TEAM_NONE)
    {
        ForceClassSelection(playerid);
        return 1;
    }

    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 100.0);

    // Somente Sniper: remove armas anteriores e entrega municao.
    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid, WEAPON_SNIPER, 30);

    if (gTeam[playerid] == TEAM_AZUL)
        SetPlayerColor(playerid, COLOR_AZUL);
    else
        SetPlayerColor(playerid, COLOR_VERMELHA);

    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    // HS exclusivo de Sniper Rifle (arma 34), na cabeca (parte 9).
    if (issuerid != INVALID_PLAYER_ID &&
        issuerid != playerid &&
        weaponid == WEAPON_SNIPER &&
        bodypart == 9 &&
        gTeam[playerid] != TEAM_NONE &&
        gTeam[issuerid] != TEAM_NONE &&
        gTeam[playerid] != gTeam[issuerid])
    {
        new attackerName[MAX_PLAYER_NAME];
        new victimName[MAX_PLAYER_NAME];
        new message[144];

        GetPlayerName(issuerid, attackerName, sizeof(attackerName));
        GetPlayerName(playerid, victimName, sizeof(victimName));

        format(message, sizeof(message),
            "[RONDONIA HS] %s acertou um HEADSHOT em %s com a Sniper!",
            attackerName, victimName);
        SendClientMessageToAll(COLOR_AMARELO, message);

        GameTextForPlayer(issuerid, "~y~HEADSHOT!", 2500, 3);
        GameTextForPlayer(playerid, "~r~VOCE RECEBEU HS!", 2500, 3);

        SetPlayerHealth(playerid, 0.0);
    }
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if (killerid != INVALID_PLAYER_ID &&
        killerid != playerid &&
        gTeam[killerid] != TEAM_NONE &&
        gTeam[killerid] != gTeam[playerid])
    {
        SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
        SendClientMessage(killerid, COLOR_VERDE,
            "+1 eliminacao! Confira seu placar.");
    }

    SetTimerEx("RespawnRondonia", 3000, false, "i", playerid);
    return 1;
}

forward RespawnRondonia(playerid);
public RespawnRondonia(playerid)
{
    if (IsPlayerConnected(playerid) && gTeam[playerid] != TEAM_NONE)
        SpawnPlayer(playerid);
    return 1;
}
