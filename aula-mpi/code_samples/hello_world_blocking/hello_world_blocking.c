/******************************************************************************
* FILE: mpi_helloBsend.c
* DESCRIPTION:
*   MPI tutorial example code: Simple hello world program that uses blocking
*   send/receive routines.
* AUTHOR: Blaise Barney
* LAST REVISED: 06/08/15
******************************************************************************/
#include "mpi.h"
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#define MASTER 0
#define SIZE 1

int main (int argc, char *argv[])
{
    int  numtasks, taskid, len, partner;

    int message[SIZE], receive[SIZE];

    char hostname[MPI_MAX_PROCESSOR_NAME];
    MPI_Status status;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &taskid);
    MPI_Comm_size(MPI_COMM_WORLD, &numtasks);

    #pragma omp parallel for
    for (int i = 0; i < SIZE; i++){
        message[i] = taskid;
        receive[i] = -1;
    }

    /* need an even number of tasks  */
    if (numtasks % 2 != 0) {
        if (taskid == MASTER)
            printf("Quitting. Need an even number of tasks: numtasks=%d\n", numtasks);
    }

    else {
        if (taskid == MASTER)
            printf("MASTER: Number of MPI tasks is: %d\n",numtasks);

        MPI_Get_processor_name(hostname, &len);
        printf ("Hello from task %d on %s!\n", taskid, hostname);

        /* determine partner and then send/receive with partner */
        if (taskid < numtasks/2) {
            partner = numtasks/2 + taskid;

            MPI_Ssend(message, SIZE, MPI_INT, partner, 1, MPI_COMM_WORLD);
            MPI_Recv(receive, SIZE, MPI_INT, partner, 1, MPI_COMM_WORLD, &status);
        }
        else if (taskid >= numtasks/2) {
            partner = taskid - numtasks/2;
            if(taskid != 2)
                MPI_Recv(receive, SIZE, MPI_INT, partner, 1, MPI_COMM_WORLD, &status);
            MPI_Ssend(message, SIZE, MPI_INT, partner, 1, MPI_COMM_WORLD);
        }

        /* print partner info and exit*/
        printf("Task %d is partner with %d and status %d\n",taskid,receive[0],status);
    }

    MPI_Finalize();

}
