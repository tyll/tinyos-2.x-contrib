
/**
 * The test does several checks:
 *  > Make sure network types are extendable with no problems (ComponentA)
 *  > Make sure regular structures are extendable with no problems (ComponentB)
 *  > Make sure we can add in bytes or words to a struct; store, and load them
 *  > Extend multiple structures within a system (ComponentA + ComponentB)
 *  > Allow multiple components access to their added elements in a given struct
 *        (ComponentC)
 *
 * Try removing components to see the RAM consumption shrink/grow as bytes are 
 * added to existing structures at compile time.
 *
 * Any red light is an indicator of trouble, which I have yet to see.
 *
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */

configuration ApplicationC {
}

implementation {
  components ComponentAC,
    ComponentBC,
    ComponentCC;
}


