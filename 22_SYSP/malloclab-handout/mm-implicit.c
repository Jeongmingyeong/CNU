/*
 * mm-implicit.c - an empty malloc package
 *
 * NOTE TO STUDENTS: Replace this header comment with your own header
 * comment that gives a high level description of your solution.
 *
 * @id : 202102699   
 * @name : JeongMingyeong 
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "mm.h"
#include "memlib.h"

/* If you want debugging output, use the following macro.  When you hand
 * in, remove the #define DEBUG line. */
#define DEBUG
#ifdef DEBUG
# define dbg_printf(...) printf(__VA_ARGS__)
#else
# define dbg_printf(...)
#endif


/* do not change the following! */
#ifdef DRIVER
/* create aliases for driver tests */
#define malloc mm_malloc
#define free mm_free
#define realloc mm_realloc
#define calloc mm_calloc
#endif /* def DRIVER */

/* single word (4) or double word (8) alignment */
#define ALIGNMENT 8

/* rounds up to the nearest multiple of ALIGNMENT */
#define ALIGN(p) (((size_t)(p) + (ALIGNMENT-1)) & ~0x7)

/* Implicit use macro */
#define WSIZE 4 /* word and header footer size -> byte */
#define DSIZE 8 /* double word size -> byte*/
#define CHUNKSIZE (1 << 12) /* size of extend heap */
#define OVERHEAD 8

#define MAX(x,y) ((x) > (y) ? (x) : (y)) /* lagger x or y */
#define PACK(size, alloc) ((size) | (alloc))

#define GET(p) (*(unsigned int*)(p))
#define PUT(p, val) (*(unsigned int*)(p) = (val))

#define GET_SIZE(p) (GET(p) & ~0x7)
#define GET_ALLOC(p) (GET(p) & 0x1)

#define HDRP(bp) ((char*)(bp) - WSIZE)
#define FTRP(bp) ((char*)(bp) + GET_SIZE(HDRP(bp)) - DSIZE)

#define NEXT_BLKP(bp) ((char*)(bp) + GET_SIZE(((char*)(bp) - WSIZE)))
#define PREV_BLKP(bp) ((char*)(bp) - GET_SIZE(((char*)(bp) - DSIZE)))

/* declaration of function */
static void *extend_heap(size_t words);
static void *coalesce (void *bp);
static void *find_fit(size_t asize);
static void place(void *pbp, size_t asize);

/*
 * Initialize: return -1 on error, 0 on success.
 */
static char *heap_listp = 0;
static char *last_bp;
void* cur_heap;

int mm_init(void) {
    if((heap_listp = mem_sbrk(4*WSIZE)) == NULL) {
        return -1;
    }

    PUT(heap_listp, 0);
    PUT(heap_listp + WSIZE, PACK(OVERHEAD, 1));
    PUT(heap_listp + DSIZE, PACK(OVERHEAD, 1));
    PUT(heap_listp + WSIZE + DSIZE, PACK(0, 1));
    heap_listp += DSIZE;
    cur_heap = heap_listp;

    if (extend_heap(CHUNKSIZE/WSIZE) == NULL) {
        return -1;
    }

    last_bp = heap_listp;
    return 0;
}

/*
 * extend_heap : extend new available heap
 * use 1) initialize heap
 * use 2) malloc not found fit
 */
static void *extend_heap(size_t words){
    char *bp;
    size_t size;

    /* even number of words allocate for keep alignment */
    size = ((words%2) == 0)? words * WSIZE : (words+1) * WSIZE;

    if ( (long)(bp = mem_sbrk(size)) == -1){ /* if mem_sbrk return, bp is located in end of block */
        return NULL;
    }

    /* free block header, footer init and epilogue header init */
    PUT(HDRP(bp), PACK(size, 0));
    PUT(FTRP(bp), PACK(size, 0));
    PUT(HDRP(NEXT_BLKP(bp)), PACK(0, 1)); 
    
    /* if prev block == free, coalesce */
    return coalesce(bp);
}

/*
 * place : Place the requested block at the beginning of the available block
 * A function that splits only if the size of the rest is equal to or larger than the minimum block size.
 */
static void place(void *bp, size_t asize){
    size_t csize = GET_SIZE(HDRP(bp)); /* present block size */

    if ((csize - asize) >= (DSIZE + OVERHEAD)) { /* it is true -> possible to put in other data */
        /* Put asize in header position, convert status to 1 (alloc) and update size to asize*/
        PUT(HDRP(bp), PACK(asize, 1));
        PUT(FTRP(bp), PACK(asize, 1)); /* change footer position */

        bp = NEXT_BLKP(bp); /* update bp position */

        PUT(HDRP(bp), PACK(csize-asize, 0)); /* mark next header that (csize-asize) blocks are available(0) */
        PUT(FTRP(bp), PACK(csize-asize, 0)); /* mark next footer that (csize-asize) blocks are available(0) */
    } else {
        PUT(HDRP(bp), PACK(csize, 1));
        PUT(FTRP(bp), PACK(csize, 1));
    }
}

/*
 * find_fit
 */
static void *find_fit(size_t asize){
    /* next-fit search */
    char * bp = last_bp;

    for(bp = NEXT_BLKP(bp); GET_SIZE(HDRP(bp)) != 0; bp = NEXT_BLKP(bp)) {
        if(!GET_ALLOC(HDRP(bp)) && GET_SIZE(HDRP(bp)) >= asize) {
            last_bp = bp;
            return bp;
        }
    }

    bp = heap_listp;
    while (bp < last_bp) {
        bp = NEXT_BLKP(bp);
        if(!GET_ALLOC(HDRP(bp)) && GET_SIZE(HDRP(bp)) >= asize) {
            last_bp = bp;
            return bp;
        }
    }

    return NULL; /* No fit */
}

/*
 * malloc
 */
void *malloc (size_t size) {
    size_t asize;
    size_t extendsize;
    char *bp;

    if (size <= 0) {
        return NULL;
    }

    if (size <= DSIZE) {
        asize = DSIZE + OVERHEAD;
    } else {
        asize = DSIZE * ((size + (DSIZE) + (DSIZE-1)) / DSIZE);
    }

    if ((bp = find_fit(asize)) != NULL) {
        place(bp,asize);
        last_bp = bp;
        return bp;
    }

    extendsize = MAX(asize, CHUNKSIZE); /* extendsize = the larger asize or CHUNKSIZE(first setting size) */
    
    if ((bp = extend_heap(extendsize / WSIZE)) == NULL) { 
        return NULL;
    }
    place(bp, asize);
    last_bp = bp;
    cur_heap = NEXT_BLKP(bp);

    return bp;
}

/*
 * free
 */
void free (void *ptr) {

    if(ptr == 0) {
        return;
    }

    size_t size = GET_SIZE(HDRP(ptr));

    PUT(HDRP(ptr), PACK(size, 0));
    PUT(FTRP(ptr), PACK(size, 0));

    coalesce(ptr);
}

/*
 * coalesce
 */
void *coalesce (void *bp) {
    size_t prev_alloc = GET_ALLOC(FTRP(PREV_BLKP(bp)));
    size_t next_alloc = GET_ALLOC(HDRP(NEXT_BLKP(bp)));
    size_t size = GET_SIZE(HDRP(bp)); /* present block size */

    /*
     * case 1 : prev block's last bit = 1 && next block's last bit = 1 
     *          bp return (no block merge)
     */
    if (prev_alloc && next_alloc) {
        last_bp = bp;
        return bp;
    }

    /*
     * case 2 : prev block's last bit = 1 && next block's last bit = 0 
     *          bp return after merge next block
     */
    else if (prev_alloc && !next_alloc) {
        size += GET_SIZE(HDRP(NEXT_BLKP(bp)));
        PUT(HDRP(bp), PACK(size, 0));
        PUT(FTRP(bp), PACK(size, 0));
    }

    /*
     * case 3 : prev block's last bit = 0 && next block's last bit = 1 
     *          bp return after merge prev block
     */
    else if(!prev_alloc && next_alloc) {
        size += GET_SIZE(HDRP(PREV_BLKP(bp)));
        PUT(FTRP(bp), PACK(size, 0));
        PUT(HDRP(PREV_BLKP(bp)), PACK(size, 0));
        bp = PREV_BLKP(bp);
    }

    /*
     * case 4 : prev block's last bit = 0 && next block's last bit = 0 
     *          bp return after merge prev block, present block, next block
     */
    else {
        size += GET_SIZE(HDRP(PREV_BLKP(bp))) + GET_SIZE(FTRP(NEXT_BLKP(bp)));
        PUT(HDRP(PREV_BLKP(bp)), PACK(size, 0));
        PUT(FTRP(NEXT_BLKP(bp)), PACK(size, 0));
        bp = PREV_BLKP(bp);
    }

    if (cur_heap > bp) {
        cur_heap = bp;
    }

    last_bp = bp;
    return bp;
}


/*
 * realloc - you may want to look at mm-naive.c
 */
void *realloc(void *oldptr, size_t size) {

    size_t oldsize;
    void *newptr;

    if (size == 0) {
        free(oldptr);
        return 0;
    }
    if (oldptr == NULL) {
        return malloc(size);
    }

    newptr = malloc(size);

    if (!newptr) {
        return 0;
    }
    oldsize = GET_SIZE(HDRP(oldptr));
    if (size < oldsize) {
        oldsize = size;
    }
    memcpy(newptr, oldptr, oldsize);

    free(oldptr);

    return newptr;
}


/*
 * calloc - you may want to look at mm-naive.c
 * This function is not tested by mdriver, but it is
 * needed to run the traces.
 */
void *calloc (size_t nmemb, size_t size) {
    return NULL;
}


/*
 * Return whether the pointer is in the heap.
 * May be useful for debugging.
 */
static int in_heap(const void *p) {
    return p < mem_heap_hi() && p >= mem_heap_lo();
}

/*
 * Return whether the pointer is aligned.
 * May be useful for debugging.
 */
static int aligned(const void *p) {
    return (size_t)ALIGN(p) == (size_t)p;
}

/*
 * mm_checkheap
 */
void mm_checkheap(int verbose) {
}
