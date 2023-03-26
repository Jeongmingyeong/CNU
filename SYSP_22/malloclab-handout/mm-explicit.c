/*
 * mm-explicit.c - an empty malloc package
 *
 * NOTE TO STUDENTS: Replace this header comment with your own header
 * comment that gives a high level description of your solution.
 *
 * @id : ?븰踰? 
 * @name : ?씠由? 
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

/* Basic constants and macro */
#define HDRSIZE 4 /* header size (bytes) */
#define FTRSIZE 4 /* footer size (bytes) */
#define WSIZE 4 /* word and header footer size -> byte */
#define DSIZE 8 /* double owrd size -> byte*/
#define CHUNKSIZE (1 << 12) /* size of extend heap */
#define OVERHEAD 8

#define MAX(x,y) ((x) > (y) ? (x) : (y)) /* lagger x or y */
#define MIN(x, y) ((x) < (y) ? (x) : (y)) /* smaller x or y */

/* Pack a size and allocated bit into a word */
#define PACK(size, alloc) ((size) | (alloc))

/* Read and write a word at address p */
#define GET(p) (*(unsigned *)(p))
#define PUT(p, val) (*(unsigned *)(p) = (val))
#define GET8(p) (*(unsigned long *)(p))
#define PUT8(p, val) (*(unsigned long *)(p) = (unsigned long)(val))

/* Read the size and allocated fields from address p */
#define GET_SIZE(p) (GET(p) & ~0x7)
#define GET_ALLOC(p) (GET(p) & 0x1)

/* Given block ptr bp, compute address of its header and footer */
#define HDRP(bp) ((char*)(bp) - WSIZE)
#define FTRP(bp) ((char*)(bp) + GET_SIZE(HDRP(bp)) - DSIZE)

/* Given block ptr bp, compute address of next and previous blocks */
#define PREV_FREEP(bp) ((char*)(bp))
#define NEXT_FREEP(bp) ((char*)(bp) + DSIZE)

/* Given free block pointer bp, compute address of next and previous free blocks */
#define PREV_FREE_BLKP(bp) ((char*)GET8((char*)(bp)))
#define NEXT_FREE_BLKP(bp) ((char*)GET8((char*)(bp) + DSIZE)) 

/*Given free block pointer bp, compute address of next pointer and prev pointer */
#define NEXT_BLKP(bp) ((char*)(bp) + GET_SIZE((char*)(bp) - WSIZE))
#define PREV_BLKP(bp) ((char*)(bp) - GET_SIZE((char*)(bp) - DSIZE))

static char *heap_listp = NULL; /* prologue block pointer */
static char *free_listp = NULL; /* 첫번째 가용블럭 포인터 */

/* declaration of function */
static void *extend_heap(size_t words);
static void *coalesce (void *bp);
static void *find_fit(size_t asize);
static void place(void *bp, size_t asize);
static void list_add(void *bp);
static void list_remove(void *bp);

/*
 * Initialize: return -1 on error, 0 on success.
 */
int mm_init(void) {
    /* Request memory for the initial empty heap */
    if ((heap_listp = mem_sbrk(DSIZE + 4 * HDRSIZE)) < 0) {
        return -1;
    }

    PUT8(heap_listp, NULL); /* padding part */
    PUT8(heap_listp + WSIZE, PACK((DSIZE + OVERHEAD), 1)); /* header */
    PUT8(heap_listp + DSIZE, 0); /* prev pointer */
    PUT8(heap_listp + DSIZE + HDRSIZE , PACK(OVERHEAD, 1)); /* next pointer */
    PUT8(heap_listp + DSIZE + HDRSIZE + FTRSIZE, PACK(OVERHEAD, 1)); /* footer */

    /* initialize epilogue block */
    PUT8(heap_listp + DSIZE + 2 * HDRSIZE + FTRSIZE, PACK(0, 1));

    free_listp = heap_listp + DSIZE;

    /* Extend the empty heap with a free block of CHUNKSIZE bytes */
    if(extend_heap(CHUNKSIZE / WSIZE) == NULL) {
        return -1;
    }

    return 0; 
}

/*
 * coalesce
 */
static void *coalesce (void *bp) {
    size_t prev_alloc = GET_ALLOC(FTRP(PREV_BLKP(bp))); /* IS allocate prev block? 0 = NO, 1 = YES */
    size_t next_alloc = GET_ALLOC(HDRP(NEXT_BLKP(bp))); /* IS allocate next block? 0 = NO, 1 = YES */
    size_t size = GET_SIZE(HDRP(bp)); /* present block size */

    /*
     * case 1 : prev block's last bit = 1 && next block's last bit = 1 
     *          bp return (no block merge)
     */

    /*
     * case 2 : prev block's last bit = 1 && next block's last bit = 0 
     *          bp return after merge next block
     */
    if (prev_alloc && !next_alloc) {
        size += GET_SIZE(HDRP(NEXT_BLKP(bp)));
        list_remove(NEXT_BLKP(bp));
        PUT8(HDRP(bp), PACK(size, 0));
        PUT8(FTRP(bp), PACK(size, 0));
    }

    /*
     * case 3 : prev block's last bit = 0 && next block's last bit = 1 
     *          bp return after merge prev block
     */
    else if(!prev_alloc && next_alloc) {
        size += GET_SIZE(HDRP(PREV_BLKP(bp)));
        bp = PREV_BLKP(bp);
        list_remove(bp);
        PUT8(FTRP(bp), PACK(size, 0));
        PUT8(HDRP(bp), PACK(size, 0));
    }

    /*
     * case 4 : prev block's last bit = 0 && next block's last bit = 0 
     *          bp return after merge prev block, present block, next block
     */
    else if (!prev_alloc && !next_alloc) {
        size += GET_SIZE(HDRP(PREV_BLKP(bp))) + GET_SIZE(FTRP(NEXT_BLKP(bp)));
        list_remove(NEXT_BLKP(bp));
        list_remove(PREV_BLKP(bp));
        bp = PREV_BLKP(bp);
        PUT8(HDRP(bp), PACK(size, 0));
        PUT8(FTRP(bp), PACK(size, 0));
    }

    list_add(bp);
    return bp;
}

/*
 * extend_heap : extend new available heap
 */
static void *extend_heap(size_t words){
    char *bp;
    unsigned size;

    /* Allocate an even number of words to maintain alignment */
    size = (words % 2) ? (words + 1) * WSIZE : words*WSIZE;

    if(size < (DSIZE + OVERHEAD)) {
        size = (DSIZE + OVERHEAD);
    }
    /* Request more memory from heap */
    if((long)(bp = mem_sbrk(size)) < 0) {
        return NULL;
    }

    /* Write in the header, footer, and new epilogue */
    PUT8(HDRP(bp), PACK(size, 0));
    PUT8(FTRP(bp), PACK(size, 0));
    //PUT(epilogue, PACK(0, 1)); /* new epilogue header */
    PUT8(HDRP(NEXT_BLKP(bp)), PACK(0, 1));

    return coalesce(bp);
}

/*
 * find_fit
 */
static void *find_fit(size_t asize){
    /* first-fit search */
    void *bp;
    for (bp = free_listp; GET_SIZE(HDRP(bp)) == 0; bp = NEXT_FREEP(bp)){ /* follow the for statement, bp reach epilogue header(0) */
        if (asize <= (size_t) GET_SIZE(HDRP(bp))){ /* block is available && asize <= empty block size */
            return bp; /* fit block */
        }
    }
    return NULL;  /* no fit */
}

/*
 * list_add
 */
static void list_add(void* bp) {
    PUT8(NEXT_FREEP(bp), free_listp);
    PUT8(PREV_FREEP(free_listp), bp);
    PUT8(PREV_FREEP(bp), NULL);

    free_listp = bp;
}

/*
 * list_remove
 */
static void list_remove(void* bp) {
     if(PREV_FREEP(bp)) {
        PUT8(NEXT_FREEP(PREV_FREEP(bp)), NEXT_FREEP(bp));
     } else {
        free_listp = NEXT_FREEP(bp);
     }

     PUT8(PREV_FREEP(NEXT_FREEP(bp)), PREV_FREEP(bp));
}

/*
 * malloc
 */
void *malloc (size_t size) {
    char *bp;
    unsigned asize;
    unsigned extendsize;

    if (size == 0) {
        return NULL;
    }

    if (size <= DSIZE) {
        asize = DSIZE + OVERHEAD;
    } else {
        asize = DSIZE * ((size + (DSIZE) + (DSIZE-1)) / DSIZE);
    }

    /* 결정한 크기에 알맞은 블록을 list에서 검색하여 해당 위치에 할당 */
    if((bp = find_fit(asize)) != NULL) {
        place(bp, asize);
        return bp;
    }

    extendsize = MAX(asize, CHUNKSIZE);

    if((bp = extend_heap(extendsize / WSIZE)) == NULL) {
        return NULL;
    }

    place(bp, asize);
    return bp;
}

/*
 * free
 */
void free (void *bp) {

    if(bp == NULL) {
        return;
    }
    size_t size = GET_SIZE(HDRP(bp));

    PUT(HDRP(bp), PACK(size, 0));
    PUT(FTRP(bp), PACK(size, 0));

    coalesce(bp);
}

/*
 * place
 */
static void place(void *bp, size_t asize){
    size_t csize = GET_SIZE(HDRP(bp));

    list_remove(bp);

    if ((csize-asize) >= (2*DSIZE)){

        PUT(HDRP(bp), PACK(asize, 1));
        PUT(FTRP(bp), PACK(asize, 1));

        list_remove(bp);
        bp = NEXT_BLKP(bp);

        PUT(HDRP(bp), PACK(csize-asize, 0));
        PUT(FTRP(bp), PACK(csize-asize, 0));

        coalesce(bp);
    } else {
        PUT(HDRP(bp), PACK(csize, 1));
        PUT(FTRP(bp), PACK(csize, 1));
        list_remove(bp);
    }
}

/*
 * realloc - you may want to look at mm-naive.c
 */
void *realloc(void *ptr, size_t size) {
    size_t oldsize;
    void *newptr;
    size_t asize;

    if (size <= DSIZE) {
        asize = DSIZE + OVERHEAD;
    } else {
        asize = DSIZE * ((size + (DSIZE) + (DSIZE-1)) / DSIZE);
    }

    if(size <= 0) {
        free(ptr);
        return 0;
    } 

    if(ptr == NULL) {
        return malloc(size);
    }

    oldsize = GET_SIZE(HDRP(ptr));

    if(asize == oldsize) {
        return ptr;
    } 

    if(asize <= oldsize) {
        size = asize;
        if(oldsize - size <= DSIZE + OVERHEAD) {
            return ptr;
        }
        PUT8(HDRP(ptr), PACK(size, 1));
        PUT8(FTRP(ptr), PACK(size, 1));
        PUT8(HDRP(NEXT_BLKP(ptr)), PACK(oldsize-size, 1));
        free(NEXT_BLKP(ptr));
        return ptr;
    }

    newptr = malloc(size);

    if(!newptr) {
        return 0;
    }

    if(size < oldsize) {
        oldsize = size;
    }

    memcpy(newptr, ptr, oldsize);

    free(ptr);

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
