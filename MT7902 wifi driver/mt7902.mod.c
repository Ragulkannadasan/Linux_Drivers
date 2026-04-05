#include <linux/module.h>
#include <linux/export-internal.h>
#include <linux/compiler.h>

MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

KSYMTAB_FUNC(BT_rst_L0_notify_WF_step1, "", "");
KSYMTAB_FUNC(BT_rst_L0_notify_WF_2, "", "");
KSYMTAB_FUNC(rlm_get_alpha2, "", "");

MODULE_INFO(depends, "cfg80211");

MODULE_ALIAS("pci:v000014C3d00007902sv*sd*bc*sc*i*");
