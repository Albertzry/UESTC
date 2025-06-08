#include "mpi.h" 
#include <math.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <vector>
#include <cstring> 
using namespace std;

#define MIN(a, b) ((a) < (b) ? (a) : (b)) 
#define LL long long 
#define CACHE_SIZE 33554432 
#define likely(x) __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0) 

int main(int argc, char* argv[]) {
    LL count = 0; 
    double elapsed_time; 
    LL first; 
    LL global_count = 0; 
    LL high_value; 
    LL i;
    int id; 
    LL index;
    LL low_value; 
    bool* marked; 
    bool* mark;
    LL n; 
    int p; 
    LL proc0_size; 
    LL prime; 
    LL size; 
    LL Block_low_value, Block_high_value, Block_first, Block_last;
    LL prime_square;
    LL tmpSize; 
    LL tmpPrime;
    LL count_cacheBlock0 = 0, count_cacheBlock1 = 0, count_cacheBlock2 = 0, count_cacheBlock3 = 0, count_cacheBlock4 = 0, count_cacheBlock5 = 0, count_cacheBlock6 = 0, count_cacheBlock7 = 0;

    bool* tmp_marked;
    unsigned LL tmp_i;
    unsigned LL tmp_prime;
    unsigned int zero;

    MPI_Init(&argc, &argv); 
    MPI_Comm_rank(MPI_COMM_WORLD, &id); 
    MPI_Comm_size(MPI_COMM_WORLD, &p); 
    MPI_Barrier(MPI_COMM_WORLD); 
    elapsed_time = -MPI_Wtime(); 

    if (argc != 2) { // Check command line arguments
        if (!id) printf("Command line: %s <m>\n", argv[0]);
        MPI_Finalize();
        exit(1);
    }

    n = atoll(argv[1]); // Convert argument to long long

    vector<int> pri; // Store primes
    int pri_i = 1;
    int sqrt_N = sqrt(n) + 10;
    bool not_prime[sqrt_N + 10] = { 0 }; // Mark non-primes
    for (int i = 2; i <= sqrt_N; i++) {
        if (!not_prime[i]) pri.emplace_back(i);
        for (int prime_i : pri) {
            if (i * prime_i > sqrt_N) break;
            not_prime[i * prime_i] = true;
            if (i % prime_i == 0) break;
        }
    }

    LL N = (n - 1) >> 1; // Adjust range for odd numbers
    LL low_index = id * (N / p) + MIN(id, N % p); // Calculate starting index
    LL high_index = (id + 1) * (N / p) + MIN(id + 1, N % p) - 1; // Calculate ending index
    low_value = (low_index << 1) + 3; // Calculate lowest value
    high_value = ((high_index + 1) << 1) + 1; // Calculate highest value
    size = ((high_value - low_value) >> 1) + 1; // Calculate number of elements

    proc0_size = (n - 1) / p; // Check if process 0 has enough primes
    if ((2 + proc0_size) < (int)sqrt((double)n)) {
        if (!id) printf("Too many processes\n");
        MPI_Finalize();
        exit(1);
    }

    int CacheBlock_size = (CACHE_SIZE / p) >> 4; // Calculate cache block size
    int Block_need = size / CacheBlock_size; // Number of blocks needed
    int Block_rest = size % CacheBlock_size; // Remaining elements
    int Block_id = 0; // Block index
    int Block_N = CacheBlock_size - 1; // Last index of block
    int BlocLowModPrime; // Temporary variable for modulo
    marked = (bool*)malloc(CacheBlock_size); // Allocate marked array

    if (marked == NULL) { // Check memory allocation
        printf("Cannot allocate enough memory\n");
        MPI_Finalize();
        exit(1);
    }

    while (Block_id <= Block_need) { // Process each cache block
        pri_i = 1; // Reset prime index
        prime = 3; // Start with first prime
        prime_square = prime * prime; // Square of prime
        memset(marked, 1, CacheBlock_size); // Initialize marked array
        count_cacheBlock0 = 0, count_cacheBlock1 = 0, count_cacheBlock2 = 0, count_cacheBlock3 = 0, count_cacheBlock4 = 0, count_cacheBlock5 = 0, count_cacheBlock6 = 0, count_cacheBlock7 = 0; // Reset counts
        Block_first = Block_id * Block_N + MIN(Block_id, Block_rest) + low_index; // Update block range
        Block_last = (Block_id + 1) * Block_N + MIN(Block_id + 1, Block_rest) - 1 + low_index;
        Block_low_value = (Block_first << 1) + 3;
        if (unlikely(Block_id == Block_need)) { // Handle last block
            Block_high_value = high_value;
            Block_last = high_index;
            CacheBlock_size = ((Block_high_value - Block_low_value) >> 1) + 1;
        }
        else {
            Block_high_value = (Block_last << 1) + 3;
        }

        do { // Sieve non-primes in block
            BlocLowModPrime = Block_low_value % prime; // Calculate modulo
            if (unlikely(prime_square > Block_low_value))
                first = (prime_square - Block_low_value) >> 1; // Calculate first multiple
            else {
                if (unlikely(BlocLowModPrime == 0))
                    first = 0;
                else {
                    first = ((BlocLowModPrime & 1) == 0) ?
                        (prime - (BlocLowModPrime >> 1)) :
                        (prime - BlocLowModPrime) >> 1;
                }
            }

            tmpSize = CacheBlock_size - (CacheBlock_size - first) % (prime << 3); // Calculate loop size
            i = first;
            tmp_marked = &marked[0];
            tmp_i = (unsigned LL)i;
            tmp_prime = (unsigned LL)prime;
            zero = 0;
            asm volatile( // Inline assembly for optimization
                "2:\n"
                "cmp %0, %2\n"
                "jge 1f\n"
                "movb %b3, (%1,%0)\n"
                "add %0, %4\n"
                "movb %b3, (%1,%0)\n"
                "add %0, %4\n"
                "movb %b3, (%1,%0)\n"
                "add %0, %4\n"
                "movb %b3, (%1,%0)\n"
                "add %0, %4\n"
                "movb %b3, (%1,%0)\n"
                "add %0, %4\n"
                "movb %b3, (%1,%0)\n"
                "add %0, %4\n"
                "movb %b3, (%1,%0)\n"
                "add %0, %4\n"
                "movb %b3, (%1,%0)\n"
                "add %0, %4\n"
                "jmp 2b\n"
                "1:\n"
                : "+r"(tmp_i)
                : "r"(tmp_marked), "r"(tmpSize), "r"(zero), "r"(tmp_prime)
                : "cc", "memory");
            i = tmp_i;
            for (; i < CacheBlock_size; i += prime) marked[i] = 0;

            prime = pri[++pri_i]; // Move to next prime
            prime_square = prime * prime;
        } while (prime_square <= Block_high_value);

        tmpSize = (CacheBlock_size >> 6) << 6; // Process block in chunks
        for (i = 0; i < tmpSize; i += 64) {
            mark = marked + i;
            count_cacheBlock0 += __builtin_popcountll(*((unsigned long long*)(mark)));
            count_cacheBlock1 += __builtin_popcountll(*((unsigned long long*)(mark + 8)));
            count_cacheBlock2 += __builtin_popcountll(*((unsigned long long*)(mark + 16)));
            count_cacheBlock3 += __builtin_popcountll(*((unsigned long long*)(mark + 24)));
            count_cacheBlock4 += __builtin_popcountll(*((unsigned long long*)(mark + 32)));
            count_cacheBlock5 += __builtin_popcountll(*((unsigned long long*)(mark + 40)));
            count_cacheBlock6 += __builtin_popcountll(*((unsigned long long*)(mark + 48)));
            count_cacheBlock7 += __builtin_popcountll(*((unsigned long long*)(mark + 56)));
        }
        count += count_cacheBlock0 + count_cacheBlock1 + count_cacheBlock2 + count_cacheBlock3 + count_cacheBlock4 + count_cacheBlock5 + count_cacheBlock6 + count_cacheBlock7;
        for (; i < CacheBlock_size; i++) count += marked[i];

        Block_id++;
    }

    MPI_Reduce(&count, &global_count, 1, MPI_LONG_LONG, MPI_SUM, 0, MPI_COMM_WORLD); // Reduce counts
    global_count++;

    elapsed_time += MPI_Wtime(); // Stop timer

    if (!id) { // Print results
        printf("There are %lld primes less than or equal to %lld\n", global_count, n);
        printf("SIEVE (%d) %10.6f\n", p, elapsed_time);
    }
    MPI_Finalize();
    return 0;
}