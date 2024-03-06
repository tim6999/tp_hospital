ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()

	local lmodel = (true) and GetHashKey('s_m_m_doctor_01') or GetHashKey(GetHashKey('s_m_m_doctor_01'))
	RequestModel(lmodel)
	while not HasModelLoaded(lmodel) do
		Wait(10)
	end
	lPed = CreatePed(4, lmodel, 308.2850, -595.4688, 42.2840, 70.0, false, false)
	SetEntityInvincible(lPed, true)
	FreezeEntityPosition(lPed, true)
	SetBlockingOfNonTemporaryEvents(lPed, true)
	SetAmbientVoiceName(lPed, "s_m_y_dealer_01")
	TaskStartScenarioInPlace(lPed, "WORLD_HUMAN_CLIPBOARD", 0, 0)
	SetModelAsNoLongerNeeded(lmodel)
end)

exports.ox_target:addSphereZone({
	coords = vec3(308.2850, -595.4688, 43.2840),
	radius = 1,
	options = {
		{
			name = 'npctarget',
            distance = 3.0,
			icon = 'fa-solid fa-user-doctor',
			label = 'Bliv tilset af doktoren',
			onSelect = function()
                StartMedAtBliveTilset()
            end
		}
	}
})

StartMedAtBliveTilset = function()
    lib.progressBar({
        duration = 7000,
        label = 'Skriver dig ind på ventelisten...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
        },
        anim = {
            dict = 'amb@world_human_clipboard@male@base',
            clip = 'base'
        },
        prop = {
            model = `p_amb_clipboard_01`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.5, 0.0, -1.0)
        },
    })
    TPIndISeng()
end

TPIndISeng = function()
    local playerPed = PlayerPedId()

	isHealing = true
	local bed = math.random(1, #Config.Beds)
	DoScreenFadeOut(500)
	Citizen.Wait(3500)
	SetEntityCoords(playerPed, Config.Beds[bed].coords.x, Config.Beds[bed].coords.y, Config.Beds[bed].coords.z + 0.3)
	ExecuteCommand('e passout3')
	SetEntityHeading(playerPed, Config.Beds[bed].heading + 180.0)
	DoScreenFadeIn(1000)
    lib.progressBar({
        duration = 30000,
        label = 'Du bliver tilset af lægen...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
        },
    })
	ClearPedTasksImmediately(playerPed)
	SetEntityHealth(playerPed, 200)
	TriggerEvent('esx_ambulancejob:revive')
end