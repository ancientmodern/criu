// #include <stdio.h>
// #include <unistd.h>
// #include <stdlib.h>
// #include <sys/wait.h>
// #include <sys/syscall.h>
// #include <sys/time.h>
// #include <errno.h> 
// #include <string.h>


// int main(int argc, char **argv)
// {
// 	int i;
// 	int count=0;
// 	ssize_t num_bytes;
// 	struct timeval tv;
	
// 		fprintf(stderr, "\033[1;31m I'm in victim.c main! :)\n\033[0m");
	
// 	while (1) {

// 		fprintf(stderr, "\033[1;31m I'm in the BEGINNING of the while loop!\n\033[0m");
// 		count += 1;
// 		fprintf(stderr, "\033[1;31m Loop count is %d\n\033[0m", count);
	
// 		gettimeofday(&tv, NULL);
// 		fprintf(stderr, "\033[1;31m calling READ at time Seconds: %ld Microseconds: %ld\n\033[0m", tv.tv_sec, tv.tv_usec);

// 		if (count == 3) {
// 			fprintf(stderr, "\033[1;31m Victim is sleeping 1 sec when count == 3\n\033[0m");
// 			// sleep(3);
// 			fflush(stderr);
// 		}

// 		num_bytes = read(0, &i, sizeof(i));
// 		fprintf(stderr, "\033[1;31m READ value is: %d size is: %ld num_bytes is: %ld\n\033[0m", i, sizeof(i), num_bytes);
// 		if (num_bytes != sizeof(i)){
// 			fprintf(stderr, "\033[1;31m after READ, ERROR is: %s, errno is: %d\n\033[0m", strerror(errno), errno);
// 			break;
// 		}
// 		fprintf(stderr, "\033[1;31m I'm in the MIDDLE of the while loop!\n\033[0m");
// 		if (write(1, &i, sizeof(i)) != sizeof(i)){
// 			fprintf(stderr, "\033[1;31m after WRITE, size is not equal, about to break!\n\033[0m");
// 			break;
// 		}else{
// 			fprintf(stderr, "\033[1;31m WRITE value is: %d\n\033[0m", i);
// 		}
			
// 		fprintf(stderr,"\033[1;31m I'm at the END of the while loop!\n\033[0m");	
// 		fprintf(stderr,"\033[1;31m ===========================================================================================================\n\033[0m");
// 	}

// 	fprintf(stderr,"\033[1;31m I'm at OUTSIDE of the while loop!\n\033[0m");	

// 	return 0;
// }

#include <unistd.h>

int main(int argc, char **argv)
{
	int i;

	while (1) {
		if (read(0, &i, sizeof(i)) != sizeof(i))
			break;

		if (write(1, &i, sizeof(i)) != sizeof(i))
			break;
	}

	return 0;
}