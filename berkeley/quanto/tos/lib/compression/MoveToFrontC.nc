generic module MoveToFrontC() {
    provides interface MoveToFront;
}
implementation {
   
    /* The implementation represents the order of integers
     * from 0 to 255 as a linked list implemented using an
     * array plus a head "pointer". Each element of the array
     * contains the index of the next element in the ordering,
     * except for the last element in the list, which points to
     * its own position. */

    /* Todo: currently init() resets the entire list. By being 
     * more careful in the beginning, we can make init() just
     * make the list empty, and grow the list as we reference new
     * elements. In this fashion, we might never have to pay
     * the entire 256-position loop to initialize the array.*/

    typedef struct {
        uint8_t next[256]; //order
        uint8_t h;          //head
    } mtf_order;

    mtf_order mtf;

    command void MoveToFront.init() {
        int i;
        for (i = 0; i < 255; i++)
            mtf.next[i] = i+1;
        mtf.h = 0;
    }

    /* moves b to the front and returns the
     * distance */
    command uint8_t MoveToFront.encode(uint8_t b) {
        uint8_t p, i;
        p = mtf.h;
        if (p == b)
            return 0;
        //search the list for b.
        for (i = 1, p = mtf.h; 
             mtf.next[p] != b; 
             i++, p = mtf.next[p])
            ;
        //i is the position in the list
        //now we move to front
        if (mtf.next[b] == b)                 //is b the last?
            mtf.next[p] = p;                  //now p is the last
        else
            mtf.next[p] = mtf.next[b];      //next(p) = next(b)
        mtf.next[b] = mtf.h;                 //b comes before head
        mtf.h = b;                             //head points to b
    
        return i;
    }

    command uint8_t MoveToFront.decode(uint8_t b) {
        uint8_t v, p;
        uint8_t i;
    
        if (b == 0)
            return mtf.h;
        //if not head, we have to find the b-th element in the 
        //list, move it to the front, and return it.    
        for (i = 1, p = mtf.h;
             i < b ; 
             i++, p = mtf.next[p])
            ;
        //p = predecessor of the value v
        v = mtf.next[p];   
        //move to front
        if (mtf.next[v] == v)
            mtf.next[p] = p;
        else
            mtf.next[p] = mtf.next[v];
        mtf.next[v] = mtf.h;
        mtf.h = v;
        
        return  v;
    }
}
