/*
 * mandel.c
 *
 * A program to draw the Mandelbrot Set on a 256-color xterm.
 *
 */

#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

#include <sys/wait.h>
#include <sys/mman.h>

#include "mandel-lib.h"

#define MANDEL_MAX_ITERATION 100000

/***************************
 * Compile-time parameters *
 ***************************/

/*
 * Output at the terminal is is x_chars wide by y_chars long
*/
//const int y_chars = 50;
//const int x_chars = 90;

#define y_chars 50
#define x_chars 90

/*
 * The part of the complex plane to be drawn:
 * upper left corner is (xmin, ymax), lower right corner is (xmax, ymin)
*/
double xmin = -1.8, xmax = 1.0;
double ymin = -1.0, ymax = 1.0;
	
/*
 * Every character in the final output is
 * xstep x ystep units wide on the complex plane.
 */
double xstep;
double ystep;

// make Number of Processes a global variable
int NPROC;

/*
 * This function computes a line of output
 * as an array of x_char color values.
 */


void compute_mandel_line(int line, int color_val[])
{
	/*
	 * x and y traverse the complex plane.
	 */
	double x, y;

	int n;
	int val;

	/* Find out the y value corresponding to this line */
	y = ymax - ystep * line;

	/* and iterate for all points on this line */
	for (x = xmin, n = 0; n < x_chars; x+= xstep, n++) {

		/* Compute the point's color value */
		val = mandel_iterations_at_point(x, y, MANDEL_MAX_ITERATION);
		if (val > 255)
			val = 255;

		/* And store it in the color_val[] array */
		val = xterm_color(val);
		color_val[n] = val;
	}
}

/*
 * This function outputs an array of x_char color values
 * to a 256-color xterm.
 */
void output_mandel_line(int fd, int color_val[])
{
	int i;
	
	char point ='@';
	char newline='\n';

	for (i = 0; i < x_chars; i++) {
		/* Set the current color, then output the point */
		set_xterm_color(fd, color_val[i]);
		if (write(fd, &point, 1) != 1) {
			perror("compute_and_output_mandel_line: write point");
			exit(1);
		}
	}

	/* Now that the line is done, output a newline character */
	if (write(fd, &newline, 1) != 1) {
		perror("compute_and_output_mandel_line: write newline");
		exit(1);
	}
}

void compute_and_output_mandel_line(int fd, int line)
{
	/*
	 * A temporary array, used to hold color values for the line being drawn
	 */
	int color_val[x_chars];

	compute_mandel_line(line, color_val);
	output_mandel_line(fd, color_val);
}

/*
 * Create a shared memory area, usable by all descendants of the calling
 * process.
 */
void *create_shared_memory_area(unsigned int numbytes)
{
	int pages;
	void *addr;

	if (numbytes == 0) {
		fprintf(stderr, "%s: internal error: called for numbytes == 0\n", __func__);
		exit(1);
	}

	/*
	 * Determine the number of pages needed, round up the requested number of
	 * pages
	 */
	pages = (numbytes - 1) / sysconf(_SC_PAGE_SIZE) + 1;

	/* Create a shared, anonymous mapping for this number of pages */
	
	addr = mmap(NULL, pages * sysconf(_SC_PAGE_SIZE),PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0 );

	if(addr == MAP_FAILED){
		perror("failed to create shared memory");
		exit(2);
	}


	return addr;
}

void destroy_shared_memory_area(void *addr, unsigned int numbytes) {
	int pages;

	if (numbytes == 0) {
		fprintf(stderr, "%s: internal error: called for numbytes == 0\n", __func__);
		exit(1);
	}

	/*
	 * Determine the number of pages needed, round up the requested number of
	 * pages
	 */
	pages = (numbytes - 1) / sysconf(_SC_PAGE_SIZE) + 1;

	if (munmap(addr, pages * sysconf(_SC_PAGE_SIZE)) == -1) {
		perror("destroy_shared_memory_area: munmap failed");
		exit(1);
	}
}


/*
	First Idea of what I need to do:
	1 - Create shared memory and semaphores
	2 - Fork children
	3 - The children should calculate the lines i, i + N, i + 2N, ...
	4 - The children should output in order ( use the semaphores to avoid racing problems)  
  	Note: First calculate then output fort faster results	
*/	

typedef struct{
	int colors[y_chars][x_chars];
}sharedData;

int main(int argc, char* argv[])
{

	if ( argc != 2 ){
		printf("You should input the Number of Processes\n");
		return 1;
	}

	NPROC = atoi(argv[1]);

	//Initialize Shared Data
	size_t size = sizeof(sharedData); 
	sharedData* data = (sharedData*)create_shared_memory_area(size);

	xstep = (xmax - xmin) / x_chars;
	ystep = (ymax - ymin) / y_chars;

	// 2 Here I will need to create NPROC children

	// Initialize an array of pid_t
	pid_t *proc = (pid_t*) malloc(sizeof(pid_t) * NPROC);
		
	if(proc == NULL){
		perror("There was an error with allocating memory for the pid's");
		return 2;
	}	

	//Loop - Fork
	for(int i=0; i < NPROC;i++){
		proc[i] = fork();
		if(proc[i] == -1){
			perror("There was an error forking");
			return(3);
		} else if(proc[i] == 0){
			//Child process
			//Here the calculation needs to happen

			/*
			 * draw the Mandelbrot Set, one line at a time.
			 * Output is sent to file descriptor '1', i.e., standard output.
			 */

			for(int line = i;line < y_chars ; line+= NPROC){
			        compute_mandel_line(line,data->colors[line]); 
				
			}	
			exit(0);
		} 
	}

	for (int i = 0; i < NPROC; i++) {
	    waitpid(proc[i], NULL, 0);
	}

	//Here we will have the output
	for(int line = 0;line < y_chars ; line++){
		output_mandel_line(1,data->colors[line]);
	}
	printf("Mandle fork 2 \n");

	// Cleanup
	free(proc);
	destroy_shared_memory_area(data, sizeof(sharedData));
	reset_xterm_color(1);
	return 0;
}

