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

#include <semaphore.h>
#include <pthread.h>

#include "mandel-lib.h"

#define MANDEL_MAX_ITERATION 100000

/***************************
 * Compile-time parameters *
 ***************************/

/*
 * Output at the terminal is is x_chars wide by y_chars long
*/
int y_chars = 50;
int x_chars = 90;

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

//Declare semaphore
sem_t semOutput;


//Initialise current line priority
int next_line = 0;

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

void output_mandel_line(int fd, int color_val[],int current_line)
{
	int i;
	
	char point ='@';
	char newline='\n';


	for (i = 0; i < x_chars; i++) {
		/* Set the current color, then output the point */
		set_xterm_color(fd, color_val[i]);
		if (write(fd, &point, 1) != 1) {
			perror("compute_and_output_mandel_line: write point");
			sem_post(&semOutput);
			exit(1);
		}
	}

	/* Now that the line is done, output a newline character */
	if (write(fd, &newline, 1) != 1) {
		perror("compute_and_output_mandel_line: write newline");
		sem_post(&semOutput);
		exit(1);
	}	
	
}


/*
 * This function outputs an array of x_char color values
 * to a 256-color xterm.
 */
void compute_and_output_mandel_line(int fd, int current_line)
{
	/*
	 * A temporary array, used to hold color values for the line being drawn
	 */
	int color_val[x_chars];

	compute_mandel_line(current_line, color_val);


	sem_wait(&semOutput);
	// While the next_line != current_line wait	
	while (current_line != next_line) {
		sem_post(&semOutput);  // Release while waiting
		sched_yield();                // Let other threads run
		sem_wait(&semOutput);
    	}

	
	output_mandel_line(fd, color_val,current_line);

	next_line++;
	sem_post(&semOutput);
}

typedef struct {
	pthread_t thread;
//        int priority;	
	int args[3]; // fd,first_line and NTHREADS
}mandelThread;


void threads_destructor(mandelThread* threads,int NTHREADS){
	if(threads == NULL){
		return;
	}	
	free(threads);
}

void *calculateLines(void* args){
	//The thread has to process lines: first_line, first_line + NTHREADS, ...
	int *params = (int*) args;	
	int line = params[1]; 
	int NTHREADS =  params[2];
	while(line < y_chars){ // check y_cols if its correct
		compute_and_output_mandel_line(params[0],line);
		line += NTHREADS; 	
	}

	return NULL;
}

void threads_init(mandelThread *threads,int NTHREADS){
	for(int i=0;i<NTHREADS;i++){
		//threads[i].priority = i + 1;
		threads[i].args[0] = 1;
		threads[i].args[1] = i;
		threads[i].args[2] = NTHREADS; 	
		if(pthread_create(&(threads[i].thread),NULL,calculateLines,threads[i].args) != 0){
			perror("There was an error creating the thread");
			free(threads);
			exit(EXIT_FAILURE);
		}
	}
}

int main(int argc, char* argv[]){
	//Must have the NTHREADS as an argument
	if(argc != 2){
		printf("Please insert the number of threads \n");
		return(1);
	}
	const int NTHREADS = atoi(argv[1]);
	if(NTHREADS <= 0){
		printf("Please enter a positive integer \n");
		return(1);
	}	
	//Initialise semaphore
	if(sem_init(&semOutput,0,1) != 0){
		perror("There was an error with creating the semaphore");
		return(2);
	}

	//The threads need this variables to run properply
	xstep = (xmax - xmin) / x_chars;
	ystep = (ymax - ymin) / y_chars;
	mandelThread *threads = malloc(NTHREADS * sizeof(mandelThread));

	//check malloc
	if(!threads){
		perror("There was an error in malloc threads");
		return(2);
	}	
	
	//Initialize threads
	threads_init(threads,NTHREADS);

	/*
	 * draw the Mandelbrot Set, one line at a time.
	 * Output is sent to file descriptor '1', i.e., standard output.
	 */

	//Join Threads
	for(int i=0;i<NTHREADS;i++){
		pthread_join(threads[i].thread,NULL);
	}
	
	//Free memory allocated
	sem_destroy(&semOutput);
	threads_destructor(threads,NTHREADS);
	reset_xterm_color(1);
	return 0;
}
