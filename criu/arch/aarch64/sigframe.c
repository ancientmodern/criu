#include "asm/types.h"
#include <compel/asm/infect-types.h>
#include "asm/sigframe.h"

int sigreturn_prep_fpu_frame(struct rt_sigframe *sigframe, struct rt_sigframe *rsigframe)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return 0;
}
