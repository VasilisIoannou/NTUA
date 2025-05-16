#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int convertStringToNumber(char* str){
	char temp[200] = {0};
	int i=0,k=0;
	while(str[i] != '\0'){
		if(str[i] >= '0' && str[i] <= '9'){
			temp[k] = str[i];
			k++;
		}
		i++;
	}
	temp[k] = '\0';
	int n = 0;
	k=0;
	while(temp[k] != '\0'){
		n *= 10;
		n+= temp[k] -'0';
		k++;
	}
	return n;
}

void convertLineToTwoInt(char* line,int numbers[2]){
	char buffer[2][200] = {0};
	int i=0,j=0,k=0;
	while(line[i] != '\0' && j<2){
		if(line[i] == ' '){
			buffer[j][k] = '\0';
			j++;
			k = 0;
		}
		buffer[j][k] = line[i];
		k++;
		i++;
	}	
	buffer[j][i] = '\0';

	numbers[0] = convertStringToNumber(buffer[0]);
	numbers[1] = convertStringToNumber(buffer[1]);
}


void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int partition(int arr[][2], int low, int high) {
    int pivot = arr[high][0]; 
    int i = (low - 1);     

    for (int j = low; j <= high - 1; j++) {
        if (arr[j][0] >  pivot) {
            i++; 
	    swap(&arr[i][0], &arr[j][0]);
        }
    }
    swap(&arr[i+1][0], &arr[high][0]);
    swap(&arr[i+1][1], &arr[high][1]);
    return (i + 1);
}

void quicksort(int arr[][2], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);

        quicksort(arr, low, pi - 1);
        quicksort(arr, pi + 1, high);
    }
}

int main(int argc,char* argv[]){
	if ( argc != 2){
		perror("Wrong number of arguments \n");
		return 1;
	}

	FILE* inputFile = fopen(argv[1],"r");
	if(!inputFile){
		perror("file did not open properly \n");
		return 2;
	}

	char buffer[200];

	fscanf(inputFile,"%[^\n]",buffer);
	
	int N[2]; //N[0] = M, N[1] = K M+K=N
	convertLineToTwoInt(buffer,N);

	int *A,*B;

	A = (int*)malloc(N[0]*sizeof(int));
	B = (int*)malloc(N[1]*sizeof(int));

	fgetc(inputFile);
	int i=0;
	while (fscanf(inputFile,"%[^\n]",buffer) == 1){
		int tempN[2];
		convertLineToTwoInt(buffer,tempN);
		A[i] = tempN[0];
		B[i] = tempN[1];
		i++;
		fgetc(inputFile);
	}

	int numberOfWorkers = i - 1;

	if(numberOfWorkers != N[0] + N[1]){
		printf("There was a mistake with the worker numbers \n");
		printf("NumberOfWorkers: %d N: %d\n",numberOfWorkers,N[0]+N[1]);
		return 3;
	}

	int Diff[numberOfWorkers][2];

	for(int i=0;i<numberOfWorkers;i++){
		Diff[i][0] = A[i] - B[i];
		Diff[i][1] = i;
	}

	quicksort(Diff,0,numberOfWorkers-1);
	
	int *Position = (int*)malloc(numberOfWorkers * sizeof(int));// 0 - M 1 - K 2 -Nutral
	for(int i=0;i<numberOfWorkers;i++){
		if(Diff[0][i] > 0 && N[0] > 0){
			Position[Diff[i][1]] = 0;
			N[0]--;
		} else if(N[1] > 0){
			Position[Diff[i][1]] = 1;
			N[1] --;
		}
	}
	//Print Results
	
	int sum = 0;
	for(int i=0;i<numberOfWorkers;i++){
		if(Position[i] == 0){
			sum += A[i];
		}else sum+= B[i];	
	}

	printf("%d\n",sum);
	return 0;
}
