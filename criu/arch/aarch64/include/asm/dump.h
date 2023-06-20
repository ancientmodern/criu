#ifndef __CR_ASM_DUMP_H__
#define __CR_ASM_DUMP_H__

#include "log.h"

extern int save_task_regs(void *, user_regs_struct_t *, user_fpregs_struct_t *);
extern int arch_alloc_thread_info(CoreEntry *core);
extern void arch_free_thread_info(CoreEntry *core);

static inline void core_put_tls(CoreEntry *core, tls_t tls)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	core->ti_aarch64->tls = tls;
}

#define get_task_futex_robust_list_compat(pid, info) -1

#endif
