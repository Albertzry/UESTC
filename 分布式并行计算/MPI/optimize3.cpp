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

    // Each process finds the primes in the range [3, sqrt(n)] to use as bases for subsequent sieving.
    LL sqrtN = (LL)sqrt(n);
    LL subLowerBound = 3;
    LL subUpperBound = sqrtN % 2 == 0 ? sqrtN - 1 : sqrtN;

    // Create a flag array to mark whether each odd number in the range [3, sqrt(n)] is composite.
    LL subSize = (subUpperBound - subLowerBound) / 2 + 1;
    bool* subCompositeFlags = (bool*)malloc(subSize);

    // If memory is insufficient, exit.
    if (subCompositeFlags == NULL)
    {
        printf("Cannot allocate enough memory\n");
        MPI_Finalize();
        exit(1);
    }

    // Initialize the flag array to all false.
    memset(subCompositeFlags, 0, subSize);

    // Start from base 3 and check if each odd number is a multiple of the base.
    for (LL flagIndex = 0; flagIndex < subSize; flagIndex++)
    {
        // If the current base has already been marked as composite, skip it.
        if (subCompositeFlags[flagIndex])
        {
            continue;
        }

        // If the base is greater than sqrt(sqrt(n)), then all its multiples have already been marked by primes smaller than the base.
        LL base = flagIndex * 2 + 3;
        if (base * base > sqrtN)
        {
            break;
        }

        // Find the first multiple of the current base.
        LL firstMultipleIndex = (base * base - subLowerBound) / 2;

        // Mark all multiples of the current base as composite.
        for (LL multipleIndex = firstMultipleIndex; multipleIndex < subSize; multipleIndex += base)
        {
            subCompositeFlags[multipleIndex] = true;
        }
    };

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

    // Total number of numbers in the responsibility range.
    LL totalSize = (upperBound - lowerBound) / 2 + 1;

    // Divide the responsibility range into multiple blocks based on cache size.
    LL CACHE_SIZE = 4194304;
    LL blockSize = CACHE_SIZE / sizeof(LL) / processCount;
    LL blockNum = totalSize / blockSize;
    if (totalSize % blockSize != 0)
    {
        blockNum++;
    }

    // Create a flag array to mark whether each odd number in the block is composite.
    bool* compositeFlags = (bool*)malloc(blockSize);

    // If memory is insufficient, exit.
    if (compositeFlags == NULL)
    {
        printf("Cannot allocate enough memory\n");
        MPI_Finalize();
        exit(1);
    }

    // Create a counter to record the number of primes in the responsibility range.
    LL count = 0;

    // Process each block in sequence.
    for (LL blockIndex = 0; blockIndex < blockNum; blockIndex++)
    {
        // Reset the flag array to all false.
        memset(compositeFlags, 0, blockSize);

        // Calculate the lower and upper bounds of the current block.
        LL blockLowerBound = lowerBound + blockIndex * blockSize * 2;
        LL blockUpperBound = blockLowerBound + blockSize * 2 - 1;
        if (blockUpperBound > upperBound)
        {
            blockUpperBound = upperBound;
        }
        if (blockUpperBound % 2 == 0)
        {
            blockUpperBound--;
        }
        LL realBlockSize = (blockUpperBound - blockLowerBound) / 2 + 1;

        // Start from base 3 and check if each odd number is a multiple of the base.
        for (LL flagIndex = 0; flagIndex < subSize; flagIndex++)
        {
            // If the current base has already been marked as composite, skip it.
            if (subCompositeFlags[flagIndex])
            {
                continue;
            }

            // Find the first multiple of the current base within the range.
            LL base = flagIndex * 2 + 3;
            LL firstMultipleIndex = 0;
            if (base * base > blockLowerBound)
            {
                firstMultipleIndex = (base * base - blockLowerBound) / 2;
            }
            else if (blockLowerBound % base == 0)
            {
                firstMultipleIndex = 0;
            }
            else
            {
                firstMultipleIndex = base - blockLowerBound % base;
                if ((blockLowerBound + firstMultipleIndex) % 2 == 0)
                {
                    firstMultipleIndex += base;
                }
                firstMultipleIndex /= 2;
            }

            // Mark all multiples of the current base within the range as composite.
            for (LL multipleIndex = firstMultipleIndex; multipleIndex < realBlockSize; multipleIndex += base)
            {
                compositeFlags[multipleIndex] = true;
            }
        };

        // Count the number of primes within the range.
        for (LL flagIndex = 0; flagIndex < realBlockSize; flagIndex++)
        {
            if (!compositeFlags[flagIndex])
            {
                count++;
            }
        }
    }

    // Communicate between processes to calculate the total number of primes.
    LL globalCount = 0;
    if (processCount > 1)
    {
        MPI_Reduce(&count, &globalCount, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    }

    // Add 1 to the total count to account for the prime number 2, which was ignored.
    globalCount++;

    // Stop the timer.
    elapsedTime += MPI_Wtime();

    // Process 0 outputs the result.
    if (processId == 0)
    {
        printf("There are %lld primes less than or equal to %lld\n", globalCount, n);
        printf("SIEVE (%d) %10.6f\n", processCount, elapsedTime);
    }

    // Exit the MPI environment.
    MPI_Finalize();
    return 0;
}