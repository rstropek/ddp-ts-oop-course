// Everybody who waits in the salon can say one line about themselves.
// The waiting line never asks what kind of customer it is holding.
export abstract class Customer {
  abstract describe(): string;
}

// TODO: add two classes that extend Customer.
// - Human, with a first name, a last name, and whether the hair is long.
//   describe() gives back `🧑 Mia Berger (long hair)` or `... (short hair)`.
// - Dog, with a name and a breed.
//   describe() gives back `🐕 Rex (Beagle)`.
