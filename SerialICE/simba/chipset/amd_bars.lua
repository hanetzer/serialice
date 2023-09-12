dev_ryzen_14_4 = {
	pci_dev = pci_bdf(0,0x14,0x4,0,0),
	name = "Mystery 14.4",
	bar = {},
}

dev_ryzen_lpc = {
	pci_dev = pci_bdf(0, 0x14, 0x3, 0, 0),
	name = "FCH LPC Bridge",
	bar = {}
}

dev_ryzen_fabric_0 = {
	pci_dev = pci_bdf(0, 0x18, 0x0, 0, 0),
	name = "data_fabric_0",
}

function fch_ryzen_14_4()
	add_mem_bar(dev_ryzen_lpc, 0x10, "LPC", 0x100)
	add_mem_bar(dev_ryzen_lpc, 0xa0, "SPI", 0x100)
	-- add_mem_bar(dev_ryzen_fabric_0,
	-- add_mem_bar(dev_ryzen_14_4, 0x10, "Mystery BAR", 0x10000)
end
