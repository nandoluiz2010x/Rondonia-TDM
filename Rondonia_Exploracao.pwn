
#include <a_samp>

main()
{
    print("RONDONIA EXPLORACAO iniciado!");
}

public OnGameModeInit()
{
    SetGameModeText("Exploracao Los Santos");

    AddPlayerClass(
        0,
        1958.3783, 1343.1572, 15.3746,
        269.1425,
        0, 0, 0, 0, 0, 0
    );

    ShowPlayerMarkers(1);
    ShowNameTags(1);
    SetWorldTime(12);
    SetWeather(10);

    return 1;
}

public OnPlayerConnect(playerid)
{
    SendClientMessage(
        playerid,
        0x00FF00FF,
        "Bem-vindo ao RONDONIA EXPLORACAO!"
    );

    return 1;
}
