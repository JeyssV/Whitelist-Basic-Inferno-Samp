//variablenya
new DCC_Channel:AccUcp;
new Ucp_Checking[MAX_PLAYERS];

//pasang di enum pInfo
pUcp, 

//pasang di ongamemodeinit
AccUcp = DCC_FindChannelById("id channel anda"); //id channel for whitelist

//cmdnya
DCMD:cbl(user, channel, params[])
{
	new InfoUcp[128];
    if(channel != AccUcp) return 1;
    if(sscanf(params, "s[128]",params[0])) return DCC_SendChannelMessage(AccUcp, "!cbl [nama]");

   	mysql_format(mMysql, format_string, 144, "SELECT `pID`, `pUcp` FROM `accounts` WHERE `pName` = '%e' LIMIT 1", params[0]);
	new Cache: result = mysql_query(mMysql, format_string);

	if(cache_num_rows() == 0) return DCC_SendChannelMessage(AccUcp, "Tidak Ada Pemain Itu/Pemain Belom Pernah Spawn.");

    new Ucp, sql_id;

    cache_get_value_name_int(0, "pID", sql_id);
	cache_get_value_name_int(0, "pUcp", Ucp);

	cache_delete(result);

	if(Ucp == 0) return DCC_SendChannelMessage(AccUcp, "Pemain Ini Belom Ada Di Whitelist");
	if(Ucp < 2) return DCC_SendChannelMessage(AccUcp, "Pemain Ini Tidak Di Blacklist");

	format(format_string, 144, "UPDATE `accounts` SET `pUcp` = 1 WHERE `pName` = '%s'", params[0]);
	mysql_tquery(mMysql, format_string);

	format(InfoUcp, sizeof(InfoUcp), ":unlock:**%s** ```Has Been Remove From Blacklist```", params[0]);
	DCC_SendChannelMessage(AccUcp, InfoUcp);
	return 1;
}

DCMD:blw(user, channel, params[])
{
	new InfoUcp[128];
    if(channel != AccUcp) return 1;
    if(sscanf(params, "s[128]",params[0])) return DCC_SendChannelMessage(AccUcp, "!blw [nama]");

   	mysql_format(mMysql, format_string, 144, "SELECT `pID`, `pUcp` FROM `accounts` WHERE `pName` = '%e' LIMIT 1", params[0]);
	new Cache: result = mysql_query(mMysql, format_string);

	if(cache_num_rows() == 0) return DCC_SendChannelMessage(AccUcp, "Tidak Ada Pemain Itu/Pemain Belom Pernah Spawn.");

    new Ucp, sql_id;

    cache_get_value_name_int(0, "pID", sql_id);
	cache_get_value_name_int(0, "pUcp", Ucp);

	cache_delete(result);

	if(Ucp == 0) return DCC_SendChannelMessage(AccUcp, "Pemain Belom Ada Di Whitelist");
	if(Ucp == 2) return DCC_SendChannelMessage(AccUcp, "Pemain Sudah Di Blacklist");

	format(format_string, 144, "UPDATE `accounts` SET `pUcp` = 2 WHERE `pName` = '%s'", params[0]);
	mysql_tquery(mMysql, format_string);

	format(InfoUcp, sizeof(InfoUcp), ":lock:**%s** ```Has Been Blacklist```", params[0]);
	DCC_SendChannelMessage(AccUcp, InfoUcp);
	return 1;
}

DCMD:addw(user, channel, params[])
{
	new InfoUcp[128];
    if(channel != AccUcp) return 1;
    if(sscanf(params, "s[128]",params[0])) return DCC_SendChannelMessage(AccUcp, "!addw [nama]");

   	mysql_format(mMysql, format_string, 144, "SELECT `pID`, `pUcp` FROM `accounts` WHERE `pName` = '%e' LIMIT 1", params[0]);
	new Cache: result = mysql_query(mMysql, format_string);

	if(cache_num_rows() == 0) return DCC_SendChannelMessage(AccUcp, "Tidak Ada Pemain Itu/Pemain Belom Pernah Spawn.");

    new Ucp, sql_id;

    cache_get_value_name_int(0, "pID", sql_id);
	cache_get_value_name_int(0, "pUcp", Ucp);

	cache_delete(result);

	if(Ucp) return DCC_SendChannelMessage(AccUcp, "Pemain Sudah Ada Di Whitelist");

	format(format_string, 144, "UPDATE `accounts` SET `pUcp` = 1 WHERE `pName` = '%s'", params[0]);
	mysql_tquery(mMysql, format_string);

	format(InfoUcp, sizeof(InfoUcp), ":pencil:**%s** ```Has Added To Whitelist```", params[0]);
	DCC_SendChannelMessage(AccUcp, InfoUcp);
	return 1;
}

//pasang di onplayerspawn
if(PlayerInfo[playerid][pUcp] == 2)
	{
	    SCM(playerid, COLOR_RED, "{deb545}SERVER: {ffffff}Checking Your Account...");
   		SCM(playerid, COLOR_RED, "{deb545}SERVER: {ffffff}Please Wait...");
	    SetPlayerPos(playerid, 1754.1814,-1901.9937,13.6206);
	    TogglePlayerControllableEx(playerid, 0);
	    if(PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pFrSkin])
		{
			SetPlayerSkinEx(playerid,PlayerInfo[playerid][pFrSkin]);
			form_fraction[playerid] = PlayerInfo[playerid][pMember];
		}
		else
		{
		    SetPlayerSkinEx(playerid, PlayerInfo[playerid][pSkin]);
		    form_fraction[playerid] = 0;
		}
	    Ucp_Checking[playerid] = SetTimerEx("UcpBlacklist", 6000, false, "d", playerid);
		return 1;
	}
    if(PlayerInfo[playerid][pUcp] == 0)
	{
 		SCM(playerid, COLOR_RED, "{deb545}SERVER: {ffffff}Checking Your Account...");
   		SCM(playerid, COLOR_RED, "{deb545}SERVER: {ffffff}Please Wait...");
	    SetPlayerPos(playerid, 1754.1814,-1901.9937,13.6206);
	    TogglePlayerControllableEx(playerid, 0);
	    if(PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pFrSkin])
		{
			SetPlayerSkinEx(playerid,PlayerInfo[playerid][pFrSkin]);
			form_fraction[playerid] = PlayerInfo[playerid][pMember];
		}
		else
		{
		    SetPlayerSkinEx(playerid, PlayerInfo[playerid][pSkin]);
		    form_fraction[playerid] = 0;
		}
	    Ucp_Checking[playerid] = SetTimerEx("UcpCheck", 6000, false, "d", playerid);
		return 1;
	}

//pasang di clickedid == skintd[0]
if(PlayerInfo[playerid][pUcp] == 0)
		{
 		SCM(playerid, COLOR_RED, "{deb545}SERVER: {ffffff}Checking Your Account...");
   		SCM(playerid, COLOR_RED, "{deb545}SERVER: {ffffff}Please Wait...");
	    SetPlayerPos(playerid, 1754.1814,-1901.9937,13.6206);
	    if(PlayerInfo[playerid][pMember] && PlayerInfo[playerid][pFrSkin])
		{
			SetPlayerSkinEx(playerid,PlayerInfo[playerid][pFrSkin]);
			form_fraction[playerid] = PlayerInfo[playerid][pMember];
		}
		else
		{
		    SetPlayerSkinEx(playerid, PlayerInfo[playerid][pSkin]);
		    form_fraction[playerid] = 0;
		}
	    Ucp_Checking[playerid] = SetTimerEx("UcpCheck", 6000, false, "d", playerid);
		}

//pasang di deket stock checktextday()
epublic: UcpBlacklist(playerid)
{
    SCM(playerid, COLOR_YELLOW, "{deb545}SERVER: {ffffff}Akun Anda Di Blacklist");
    SPD(playerid, 0000, DIALOG_STYLE_MSGBOX, "Whitelist System", "{ffffff}Mohon Maaf\nAkun Anda Telah Di {45dede}Blacklist {ffffff}\nJika Menurut Anda Ini Keliru\nAnda Bisa Menghubungi Kami {ffffff}Di Dc Kami:\n{ffff00}https://discord.gg/xXjzywB5Mq", "Tutup", "");
    return KickD(playerid, "");
}
epublic: UcpCheck(playerid)
{
    SCM(playerid, COLOR_YELLOW, "{deb545}SERVER: {ffffff}Akun Anda Belom Terdaftar Di Whitelist");
	format(format_string, 133, "{FFA352}Lexx's Bot: {FFFF00}%s {FF541F}Has Been Kicked From Server {FFFF00}(No Whitelist)", Name(playerid));
    SendClientMessageToAll(playerid, format_string);
    SPD(playerid, 0000, DIALOG_STYLE_MSGBOX, "Whitelist System", "{ffffff}Mohon Maaf\nAkun Anda Belom Terdaftar Di {45dede}Whitelist {ffffff}Kami\nSilakan Req {45dede}Whitelist {ffffff}Di Dc Kami:\n{ffff00}https://discord.gg/xXjzywB5Mq", "Tutup", "");
    return KickD(playerid, "");
}

//pasang di bawah publics: OnPlayerLoadAccounts(playerid) dan di bagian cache
cache_get_value_int(0, "pUcp", PlayerInfo[playerid][pUcp]);
