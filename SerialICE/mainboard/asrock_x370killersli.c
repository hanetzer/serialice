const char boardname[33]="ASRock X370 Killer Sli          ";

#define SUPERIO_CONFIG_PORT 0x2e

static void chipset_init(void)
{
	superio_init(0x2e);
}
