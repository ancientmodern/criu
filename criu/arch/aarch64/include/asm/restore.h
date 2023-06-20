#ifndef __CR_ASM_RESTORE_H__
#define __CR_ASM_RESTORE_H__

#include "asm/restorer.h"

#include "images/core.pb-c.h"

#include "log.h"

/* clang-format off */
#define JUMP_TO_RESTORER_BLOB(new_sp, restore_task_exec_start, task_args) \
    do { \
        pr_msg("~Arm64~ Executing function: JUMP_TO_RESTORER_BLOB in file: criu/arch/aarch64/include/asm/restore.h\n"); \
        asm volatile( \
            "and  sp, %0, #~15        \n" \
            "mov  x0, %2              \n" \
            "br   %1                  \n" \
            : \
            : "r"(new_sp), \
              "r"(restore_task_exec_start), \
              "r"(task_args) \
            : "x0", "memory"); \
    } while(0)
/* clang-format on */

static inline void core_get_tls(CoreEntry *pcore, tls_t *ptls)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	*ptls = pcore->ti_aarch64->tls;
}

int restore_fpu(struct rt_sigframe *sigframe, CoreEntry *core);

#endif
