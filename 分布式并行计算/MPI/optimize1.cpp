#include "mpi.h"
#include <math.h>
#include <cstring>
#include <stdio.h>

#define LL long long

int main(int argc, char* argv[])
{
    // Initialize the MPI environment.
    int processId = 0, processCount = 0;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &processCount);
    MPI_Comm_rank(MPI_COMM_WORLD, &processId);
    MPI_Barrier(MPI_COMM_WORLD);

    // Start the timer.
    double elapsedTime = -MPI_Wtime();

    // Ensure n has been passed through the command line argument.
    if (argc != 2)
    {
        if (processId == 0)
        {
            printf("Command line: %s <m>\n", argv[0]);
        }

        MPI_Finalize();
        exit(1);
    }

    // Parse n from the command line argument.
    LL n = atoll(argv[1]);

    // If process 0 does not own all primes within sqrt(n), exit.
    if (2 + (n - 1) / processCount < (LL)sqrt(n))
    {
        if (processId == 0)
        {
            printf("Too many processes\n");
        }

        MPI_Finalize();
        exit(1);
    }

    // Calculate the lower bound of the current process's responsibility range.
    LL lowerBound = 2 + processId * (n - 1) / processCount;
    if (lowerBound % 2 == 0)
    {
        lowerBound++;
    }

    // Calculate the upper bound of the current process's responsibility range.
    LL upperBound = 1 + (processId + 1) * (n - 1) / processCount;
    if (upperBound % 2 == 0)
    {
        upperBound--;
    }

    // Create a flag array to mark whether each odd number in the responsibility range is composite.
    LL size = (upperBound - lowerBound) / 2 + 1;
    bool* compositeFlags = (bool*)malloc(size);

    // If memory is insufficient, exit.
    if (compositeFlags == NULL)
    {
        printf("Cannot allocate enough memory\n");
        MPI_Finalize();
        exit(1);
    }

    // Initialize
    memset(compositeFlags, 0, size);

    // Process 0 needs to keep track of the index of the smallest prime in its responsibility range that has not been processed.
    LL currentPrimeIndex = 0;

    LL base = 3;
    do
    {
        // Find the first multiple of the current base within the range.
        LL firstMultipleIndex = 0;
        if (base * base > lowerBound)
        {
            firstMultipleIndex = (base * base - lowerBound) / 2;
        }
        else if (lowerBound % base == 0)
        {
            firstMultipleIndex = 0;
        }
        else
        {
            firstMultipleIndex = base - lowerBound % base;
            if ((lowerBound + firstMultipleIndex) % 2 == 0)
            {
                firstMultipleIndex += base;
            }
            firstMultipleIndex /= 2;
        }

        // Mark all multiples of the current base within the range as composite.
        for (LL multipleIndex = firstMultipleIndex; multipleIndex < size; multipleIndex += base)
        {
            compositeFlags[multipleIndex] = true;
        }

        if (processId == 0)
        {
            while (compositeFlags[++currentPrimeIndex]);
            base = 2 * currentPrimeIndex + 3;
        }

        if (processCount > 1)
        {
            MPI_Bcast(&base, 1, MPI_INT, 0, MPI_COMM_WORLD);
        }
    } while (base * base <= n);

    // Count the number of primes within the range.
    LL count = 0;
    for (LL flagIndex = 0; flagIndex < size; flagIndex++)
    {
        if (!compositeFlags[flagIndex])
        {
            count++;
        }
    }

    LL globalCount = 0;
    if (processCount > 1)
    {
        MPI_Reduce(&count, &globalCount, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    }

    // Add 1 to the total count to account
    globalCount++;

    // Stop the timer.
    elapsedTime += MPI_Wtime();

    // Process 0 outputs the result.
    if (processId == 0)
    {
        printf("There are %lld primes less than or equal to %lld\n", globalCount, n);
        printf("SIEVE (%d) %10.6f\n", processCount, elapsedTime);
    }

    MPI_Finalize();
    return 0;
}