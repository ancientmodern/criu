#include <unistd.h>

#include "restorer.h"
#include "asm/restorer.h"

#include <compel/plugins/std/syscall.h>
#include "log.h"
#include <compel/asm/fpu.h>
#include "cpu.h"

int restore_nonsigframe_gpregs(UserRegsEntry *r)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return 0;
}
