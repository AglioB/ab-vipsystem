local QBCore = exports['qb-core']:GetCoreObject()

function GetRankLabel(name)
	local label = ""
	for _, v in pairs(Config.Ranks) do
		if v.name == name then
			label = v.label
			break
		end
	end
	return label
end

function GetVip()
	local vip = false
	QBCore.Functions.TriggerCallback('ab-vipsystem:cb:getVIPStatus', function(result)
		if result then
			vip = true
		end
	end)
	return vip
end exports('GetVip', GetVip)

RegisterNetEvent('ab-vipsystem:cl:OpenVipMenu:Give', function()
	local L = Lang.Give
	local input_table = {
		{type = 'number', label = L.Input.id, icon = Lang.Icons.id, required = true},
		{type = 'input', label = L.Input.rank, icon = Lang.Icons.rank, required = true},
		{type = 'date', label = L.Input.expire, icon = Lang.Icons.id, default = true, format = "DD/MM/YYYY"},
	}
	if Config.AllowPermanentVips then
		input_table[#input_table+1] = {type = 'checkbox', label = L.Input.permanent}
	end
	
	local input = lib.inputDialog(L.Input.title, input_table)
	local result = {
		id = input[1],
		rank = input[2],
		expire = input[3],
		permanent = input[4] or false
	}
	QBCore.Functions.TriggerCallback('ab-vipsystem:cb:ConvertTime', function(expire)
		local Acontent = string.gsub(L.Alert.content, '{id}', tostring(result.id))
		Acontent = string.gsub(Acontent, '{rank}', GetRankLabel(result.rank))
		Acontent = string.gsub(Acontent, '{permanent}', tostring(result.permanent))
		Acontent = string.gsub(Acontent, '{expire}', expire)
	
		local alert = lib.alertDialog({
			header = L.Alert.title,
			content = Acontent,
			centered = true,
			cancel = true
		})
		if alert == 'confirm' then
			TriggerServerEvent('ab-vipsystem:sv:GiveVip', result)
		end
	end, result.expire)
end)

RegisterNetEvent('ab-vipsystem:cl:OpenVipMenu:Check', function()
	local L = Lang.Check
	local input = lib.inputDialog(L.Input.title, {
		{type = 'number', label = L.Input.id, icon = Lang.Icons.id, required = true},
	})
	QBCore.Functions.TriggerCallback('ab-vipsystem:cb:CheckVip', function(vip)
		if vip then
			local Acontent = string.gsub(L.Alert.content, '{id}', input[1])
			Acontent = string.gsub(Acontent, '{label}', vip.label)
			Acontent = string.gsub(Acontent, '{expire}', vip.date)
			lib.alertDialog({
				header = L.Alert.title,
				content = Acontent,
				centered = true,
			})
		else
			QBCore.Functions.Notify(L.Notify.error.novip, Config.NotifyType.error, 5000)
		end
	end, input[1])
end)

RegisterNetEvent('ab-vipsystem:cl:OpenVipMenu:Remove', function()
	local L = Lang.Remove
	local input = lib.inputDialog(L.Input.title, {
		{type = 'number', label = L.Input.id, icon = Lang.Icons.id, required = true},
	})
	QBCore.Functions.TriggerCallback('ab-vipsystem:cb:CheckVip', function(vip)
		if vip then
			local Acontent = string.gsub(L.Alert.content, '{id}', input[1])
			Acontent = string.gsub(Acontent, '{label}', vip.label)
			Acontent = string.gsub(Acontent, '{expire}', vip.date)
			local alert = lib.alertDialog({
				header = L.Alert.title,
				content = Acontent,
				labels = {confirm = L.Alert.confirm},
				centered = true,
				cancel = true
			})
			if alert == 'confirm' then
				TriggerServerEvent('ab-vipsystem:sv:RemoveVip', input[1])
			end
		else
			QBCore.Functions.Notify(L.Notify.error.novip, Config.NotifyType.error, 5000)
		end
	end, input[1])
end)


RegisterNetEvent('ab-vipsystem:cl:OpenVipMenu', function(data)
	local L = Lang.Menu
	lib.registerMenu({
		id = 'vipmenu_admin',
		title = L.title,
		position = 'bottom-right',
		options = {
			{label = L.Check, args = {action = 'Check'}, icon = Lang.Icons.Menu.Check},
			{label = L.Give, args = {action = 'Give'}, icon = Lang.Icons.Menu.Give},
			{label = L.Remove, args = {action = 'Remove'}, icon = Lang.Icons.Menu.Remove},
		}
	}, function(selected, scrollIndex, args)
		if args.action == 'Check' then
			TriggerEvent('ab-vipsystem:cl:OpenVipMenu:Check')
		elseif args.action == 'Give' then
			TriggerEvent('ab-vipsystem:cl:OpenVipMenu:Give')
		elseif args.action == 'Remove' then
			TriggerEvent('ab-vipsystem:cl:OpenVipMenu:Remove')
		end
	end)
	Wait(10)
	lib.showMenu('vipmenu_admin')
end)
