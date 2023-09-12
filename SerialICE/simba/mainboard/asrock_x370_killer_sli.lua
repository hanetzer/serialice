load_filter("amd_bars")

function mainboard_io_pre(f, action)
	if action.write and action.addr == 0x80 and action.data == 0xb000a952 and not ram_enabled() then
		if not ram_enabled() then
			enable_ram()
		end
	end
	return false
end

filter_mainboard_io = {
	name = "Asrock X370 Killer",
	pre = mainboard_io_pre,
	hide = hide_mainboard_io,
	base = 0x0,
	size = 0x10000
}

function nvar_pre(f, action)
	if (action.write) then
		mem_qemu_rom_pre(f, action)
	else
		action.to_hw = false
		action.to_qemu = true
	end
end

function nvar_post(f, action)
	if (action.write) then
		printk(f, action, "%s:asdf [0x%08] <= 0x%02x\n", f.name, action.addr, action.data)
	else
		printk(f, action, "%s:asdf [0x%08] => 0x%02x\n", f.name, action.addr, action.data)
	end
end

function serial_post(f, action)
	local str = size_data(action.size, action.data)
	if action.write and action.addr == 0x3f8 then
		-- printf("%s=%d",str, tonumber(str,16))
		if tonumber(str,16) <= 126 and tonumber(str,16) >= 32 then
			f.output = f.output .. string.fromhex(str)
		elseif tonumber(str,16) == 13 then
			f.output = f.output .. "\\r"
		elseif tonumber(str,16) == 10 then
			f.output = f.output .. "\\n"
			printk(f, action, "%s\n", f.output)
			-- printf("%s\n", f.output)
			f.output = ""
			-- return true
		else
			f.output = f.output .. " "
		end
	-- else
	-- 	io_post(f, action)
	end
	-- printf("%s\n", f.output)
	return true
end

filter_serial1 = {
	name = "Serial",
	pre = com_pre,
	post = serial_post,
	base = 0x3f8,
	size = 8,
	hide = hide_serial,
	output = "",
}

filter_nvar_access1 = {
	name = "Backup NVRAM area",
	base = 0xff037000,
	size = 0x00020000,
	pre = nvar_pre,
	post = nvar_post,
	hide = true,
	nvar_data = {},
}

filter_nvar_access2 = {
	name = "NVRAM area",
	base = 0xff057000,
	size = 0x00020000,
	pre = mem_qemu_rom_pre,
	post = nvar_post,
	hide = true,
	nvar_data = {},
}

function do_mainboard_setup()
	do_default_setup()
	disable_hook(filter_com1)
	disable_hook(filter_superio_2e)
	-- disable_hook(filter_rom_low)
	-- disable_hook(filter_rom_high)

	-- enable_hook(cpumsr_hooks, filter_mtrr)
	-- enable_hook(cpumsr_hooks, filter_amd_microcode)
	enable_hook(cpuid_hooks, filter_multiprocessor)
	-- enable_hook(cpuid_hooks, filter_feature_smx)


	fch_ryzen_14_4()
	new_car_region(0x000000, 0x100000)
	-- new_car_region(0x000000, 0x10000000)
	-- new_car_region(0x9d00000, 0x300000)
	-- enable_hook(io_hooks, filter_mainboard_io)
	-- enable_hook(mem_hooks, filter_nvar_access1)
	-- enable_hook(mem_hooks, filter_nvar_access1)
	-- enable_hook(mem_hooks, filter_nvar_access2)
	-- enable_hook(mem_hooks, filter_rom_low)
	-- enable_hook(mem_hooks, filter_rom_high)
	enable_hook(io_hooks, filter_serial1)
	-- enable_ram()
end
