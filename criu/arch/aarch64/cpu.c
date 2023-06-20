#undef LOG_PREFIX
#define LOG_PREFIX "cpu: "

#include <errno.h>
#include "cpu.h"
#include "criu-log.h"

int cpu_init(void)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return 0;
}

int cpu_dump_cpuinfo(void)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return 0;
}

int cpu_validate_cpuinfo(void)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return 0;
}

int cpu_dump_cpuinfo_single(void)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return -ENOTSUP;
}

int cpu_validate_image_cpuinfo_single(void)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return -ENOTSUP;
}

int cpuinfo_dump(void)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return -ENOTSUP;
}

int cpuinfo_check(void)
{
	pr_msg("~Arm64~ Executing function: %s in file: %s\n", __func__, __FILE__);
	return -ENOTSUP;
}
