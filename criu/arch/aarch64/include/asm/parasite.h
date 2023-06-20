#ifndef __ASM_PARASITE_H__
#define __ASM_PARASITE_H__

#include "log.h"

static inline void arch_get_tls(tls_t *ptls)
{
	tls_t tls;
	
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);

	asm("mrs %0, tpidr_el0" : "=r"(tls));
	*ptls = tls;
}

#endif
