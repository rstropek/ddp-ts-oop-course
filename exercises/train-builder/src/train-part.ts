/**
 * Where in the train a part is allowed to sit.
 *
 * - 'must-be-first': only allowed while the train is still empty
 * - 'must-be-last':  nothing may be coupled behind this part
 * - 'none':          no rule about the position
 */
export type PartRestriction = 'must-be-first' | 'must-be-last' | 'none';

/**
 * The five kinds of part this app can build. The same string is the CSS class
 * of the box on the page, so `src/styles.css` already has a rule for each one.
 */
export type PartKind = 'locomotive' | 'passenger' | 'cargo' | 'dining' | 'caboose';

/**
 * The base class of every part that can be coupled to a train.
 *
 * `Train` only ever sees a `TrainPart`. Everything it needs in order to decide
 * has to be readable here, so it never has to ask which subclass it is holding.
 */
export abstract class TrainPart {
  /** Names the part on the page, and names its CSS class. */
  abstract readonly kind: PartKind;

  /** The single line of data this part shows, for example '48 seats'. */
  abstract readonly detail: string;

  /** What the train rules are allowed to know about this part's position. */
  abstract readonly restriction: PartRestriction;

  /**
   * How much cargo this part contributes, in tons. Zero is right for every
   * part that carries no cargo, so only the cargo wagon replaces this getter.
   */
  get cargoWeightTons(): number {
    return 0;
  }
}

// TODO: add the five parts below this line.
//
//   Locomotive    2400 kW    'must-be-first'
//   PassengerWagon  48 seats 'none'
//   CargoWagon      70 t max 'none', and it reports its weight as cargo
//   DiningWagon      8 tables 'none'
//   Caboose          2 crew  'must-be-last'
//
// TODO: then add `createPart(kind: PartKind): TrainPart`, which builds the
// part a button stands for.
